package demo.aplus.com

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.display.DisplayManager
import android.media.AudioAttributes
import android.media.AudioDeviceCallback
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Display
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import leader.aplus.com.security.AttestationService
import java.util.function.Consumer

class MainActivity : FlutterActivity() {
    private val screenSecurityChannel = "elhanbly/screen_security"
    private val contentProtectionChannel = "leader.aplus.com/content_protection"
    private val headphoneChannel = "elhanbly/headphone_detector"

    private lateinit var attestationService: AttestationService
    private var screenSecurityMethodChannel: MethodChannel? = null
    private var headphoneMethodChannel: MethodChannel? = null
    private var audioDeviceCallback: AudioDeviceCallback? = null
    private var headsetReceiver: BroadcastReceiver? = null
    private var screenRecordingCallback: Consumer<Int>? = null
    private var displayListener: DisplayManager.DisplayListener? = null
    private var isRecordingDetected: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        attestationService = AttestationService(applicationContext)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Headphone detector channel
        val hpChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            headphoneChannel
        )
        headphoneMethodChannel = hpChannel
        hpChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isHeadphonesConnected" -> {
                    result.success(isHeadphonesConnected())
                }
                else -> result.notImplemented()
            }
        }
        setupHeadphoneDetection()

        // Screen security channel
        val secChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            screenSecurityChannel
        )
        screenSecurityMethodChannel = secChannel
        secChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "enable" -> {
                    enableScreenSecurity()
                    result.success(null)
                }
                "disable" -> {
                    disableScreenSecurity()
                    result.success(null)
                }
                "isScreenRecording" -> {
                    result.success(checkIsScreenRecording())
                }
                else -> result.notImplemented()
            }
        }

        setupScreenRecordingDetection()

        // Content protection channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            contentProtectionChannel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "prepareIntegrity" -> {
                    val cloudProjectNumber = (call.argument<Number>("cloudProjectNumber"))?.toLong()
                    if (cloudProjectNumber == null) {
                        result.error("INVALID_ARGUMENT", "cloudProjectNumber is required", null)
                        return@setMethodCallHandler
                    }
                    attestationService.prepareIntegrity(cloudProjectNumber) { success, error ->
                        if (success) {
                            result.success(true)
                        } else {
                            result.error("INTEGRITY_PREPARE_FAILED", error, null)
                        }
                    }
                }

                "generateAttestationKey" -> {
                    val challengeBase64 = call.argument<String>("challenge")
                    if (challengeBase64.isNullOrEmpty()) {
                        result.error("INVALID_ARGUMENT", "challenge is required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val chain = attestationService.generateAttestationKey(challengeBase64)
                        result.success(chain)
                    } catch (e: Exception) {
                        result.error("KEY_GENERATION_FAILED", e.message, null)
                    }
                }

                "signPayload" -> {
                    val payloadBase64 = call.argument<String>("payload")
                    if (payloadBase64.isNullOrEmpty()) {
                        result.error("INVALID_ARGUMENT", "payload is required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        val signature = attestationService.signPayload(payloadBase64)
                        result.success(signature)
                    } catch (e: Exception) {
                        result.error("SIGNING_FAILED", e.message, null)
                    }
                }

                "requestPlayIntegrityToken" -> {
                    val requestHash = call.argument<String>("requestHash")
                    val cloudProjectNumber = (call.argument<Number>("cloudProjectNumber"))?.toLong()
                    if (requestHash.isNullOrEmpty()) {
                        result.error("INVALID_ARGUMENT", "requestHash is required", null)
                        return@setMethodCallHandler
                    }
                    attestationService.requestPlayIntegrityToken(requestHash, cloudProjectNumber) { token, error ->
                        if (token != null) {
                            result.success(token)
                        } else {
                            result.error("INTEGRITY_TOKEN_FAILED", error, null)
                        }
                    }
                }

                "hasAttestationKey" -> {
                    result.success(attestationService.hasAttestationKey())
                }

                "deleteAttestationKey" -> {
                    result.success(attestationService.deleteAttestationKey())
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun setupScreenRecordingDetection() {
        // 1. Android 14+ (API 34+) WindowManager.ScreenRecordingCallback via reflection for broad SDK support
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            try {
                val wm = getSystemService(Context.WINDOW_SERVICE) as? WindowManager
                val addMethod = WindowManager::class.java.methods.find { it.name == "addScreenRecordingCallback" }
                if (addMethod != null && wm != null) {
                    val callback = Consumer<Int> { state ->
                        val recording = (state == 1) // SCREEN_RECORDING_STATE_VISIBLE == 1
                        updateRecordingState(recording)
                    }
                    screenRecordingCallback = callback
                    addMethod.invoke(wm, mainExecutor, callback)
                }
            } catch (e: Exception) {
                Log.w("MainActivity", "Failed to add screen recording callback: ${e.message}")
            }
        }

        // 2. DisplayManager listener for Virtual Displays (MediaProjection / Mirroring) on all Android versions
        val displayManager = getSystemService(Context.DISPLAY_SERVICE) as? DisplayManager
        if (displayManager != null) {
            val listener = object : DisplayManager.DisplayListener {
                override fun onDisplayAdded(displayId: Int) {
                    checkAndNotifyRecording()
                }

                override fun onDisplayRemoved(displayId: Int) {
                    checkAndNotifyRecording()
                }

                override fun onDisplayChanged(displayId: Int) {
                    checkAndNotifyRecording()
                }
            }
            displayListener = listener
            displayManager.registerDisplayListener(listener, Handler(Looper.getMainLooper()))
        }
    }

    private fun isDisplayRecordingOrMirroring(display: Display): Boolean {
        if (display.displayId == Display.DEFAULT_DISPLAY) return false
        val flags = display.flags
        val isPresentation = (flags and Display.FLAG_PRESENTATION) != 0
        val isNonPrivate = (flags and Display.FLAG_PRIVATE) == 0
        return isPresentation || isNonPrivate
    }

    private fun checkIsScreenRecording(): Boolean {
        if (isRecordingDetected) return true

        // Check DisplayManager for external, presentation, or non-private virtual displays (Cast / Screen Mirroring)
        val displayManager = getSystemService(Context.DISPLAY_SERVICE) as? DisplayManager
        if (displayManager != null) {
            for (display in displayManager.displays) {
                if (isDisplayRecordingOrMirroring(display)) {
                    return true
                }
            }
        }

        return false
    }

    private fun checkAndNotifyRecording() {
        val recording = checkIsScreenRecording()
        updateRecordingState(recording)
    }

    private fun updateRecordingState(recording: Boolean) {
        if (isRecordingDetected != recording) {
            isRecordingDetected = recording
            runOnUiThread {
                screenSecurityMethodChannel?.invokeMethod("onScreenRecordingChanged", recording)
            }
        }
    }

    private fun enableScreenSecurity() {
        // Prevent video / visual screen capture (turns video black)
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )

        // Prevent internal audio capture by screen recording apps on Android 10+ (API 29+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            try {
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
                audioManager?.allowedCapturePolicy = AudioAttributes.ALLOW_CAPTURE_BY_NONE
            } catch (e: Exception) {
                Log.w("MainActivity", "Failed to set audio capture policy: ${e.message}")
            }
        }
    }

    private fun disableScreenSecurity() {
        // Clear flag secure
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)

        // Restore audio capture policy
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            try {
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
                audioManager?.allowedCapturePolicy = AudioAttributes.ALLOW_CAPTURE_BY_ALL
            } catch (e: Exception) {
                Log.w("MainActivity", "Failed to reset audio capture policy: ${e.message}")
            }
        }
    }

    private fun isHeadphonesConnected(): Boolean {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager ?: return false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val devices = audioManager.getDevices(AudioManager.GET_DEVICES_OUTPUTS)
            for (device in devices) {
                when (device.type) {
                    AudioDeviceInfo.TYPE_WIRED_HEADSET,
                    AudioDeviceInfo.TYPE_WIRED_HEADPHONES,
                    AudioDeviceInfo.TYPE_BLUETOOTH_A2DP,
                    AudioDeviceInfo.TYPE_BLUETOOTH_SCO,
                    AudioDeviceInfo.TYPE_USB_HEADSET,
                    AudioDeviceInfo.TYPE_USB_DEVICE,
                    AudioDeviceInfo.TYPE_HEARING_AID,
                    26, // AudioDeviceInfo.TYPE_BLE_HEADSET
                    27, // AudioDeviceInfo.TYPE_BLE_SPEAKER
                    30  // AudioDeviceInfo.TYPE_BLE_BROADCAST
                    -> return true
                }
            }
            return false
        } else {
            @Suppress("DEPRECATION")
            return audioManager.isWiredHeadsetOn || audioManager.isBluetoothA2dpOn || audioManager.isBluetoothScoOn
        }
    }

    private fun setupHeadphoneDetection() {
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && audioManager != null) {
            audioDeviceCallback = object : AudioDeviceCallback() {
                override fun onAudioDevicesAdded(addedDevices: Array<out AudioDeviceInfo>?) {
                    notifyHeadphoneStateChanged()
                }

                override fun onAudioDevicesRemoved(removedDevices: Array<out AudioDeviceInfo>?) {
                    notifyHeadphoneStateChanged()
                }
            }
            audioManager.registerAudioDeviceCallback(audioDeviceCallback, Handler(Looper.getMainLooper()))
        }

        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_HEADSET_PLUG)
            addAction(AudioManager.ACTION_AUDIO_BECOMING_NOISY)
            addAction("android.bluetooth.device.action.ACL_CONNECTED")
            addAction("android.bluetooth.device.action.ACL_DISCONNECTED")
        }

        headsetReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                notifyHeadphoneStateChanged()
            }
        }
        try {
            registerReceiver(headsetReceiver, filter)
        } catch (_: Exception) {}
    }

    private fun notifyHeadphoneStateChanged() {
        val connected = isHeadphonesConnected()
        runOnUiThread {
            headphoneMethodChannel?.invokeMethod("onHeadphonesStateChanged", connected)
        }
    }

    override fun onDestroy() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE && screenRecordingCallback != null) {
            try {
                val wm = getSystemService(Context.WINDOW_SERVICE) as? WindowManager
                val removeMethod = WindowManager::class.java.methods.find { it.name == "removeScreenRecordingCallback" }
                removeMethod?.invoke(wm, screenRecordingCallback)
            } catch (_: Exception) {}
        }
        displayListener?.let {
            val displayManager = getSystemService(Context.DISPLAY_SERVICE) as? DisplayManager
            displayManager?.unregisterDisplayListener(it)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && audioDeviceCallback != null) {
            try {
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
                audioManager?.unregisterAudioDeviceCallback(audioDeviceCallback)
            } catch (_: Exception) {}
        }
        headsetReceiver?.let {
            try {
                unregisterReceiver(it)
            } catch (_: Exception) {}
        }
        super.onDestroy()
    }
}

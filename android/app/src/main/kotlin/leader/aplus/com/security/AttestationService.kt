package leader.aplus.com.security

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import android.util.Log
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.StandardIntegrityManager
import com.google.android.play.core.integrity.StandardIntegrityManager.PrepareIntegrityTokenRequest
import com.google.android.play.core.integrity.StandardIntegrityManager.StandardIntegrityTokenProvider
import com.google.android.play.core.integrity.StandardIntegrityManager.StandardIntegrityTokenRequest
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.Signature
import java.security.spec.ECGenParameterSpec

class AttestationService(private val context: Context) {

    companion object {
        private const val TAG = "AttestationService"
        const val KEY_ALIAS = "aplus_content_protection_attestation_key"
        private const val KEYSTORE_PROVIDER = "AndroidKeyStore"
    }

    private val standardIntegrityManager: StandardIntegrityManager by lazy {
        IntegrityManagerFactory.createStandard(context)
    }

    private var tokenProvider: StandardIntegrityTokenProvider? = null
    private var currentCloudProjectNumber: Long? = null

    /**
     * Initializes and prepares the Standard Play Integrity token provider.
     */
    fun prepareIntegrity(cloudProjectNumber: Long, callback: (Boolean, String?) -> Unit) {
        if (tokenProvider != null && currentCloudProjectNumber == cloudProjectNumber) {
            callback(true, null)
            return
        }

        try {
            standardIntegrityManager.prepareIntegrityToken(
                PrepareIntegrityTokenRequest.builder()
                    .setCloudProjectNumber(cloudProjectNumber)
                    .build()
            ).addOnSuccessListener { provider ->
                tokenProvider = provider
                currentCloudProjectNumber = cloudProjectNumber
                Log.d(TAG, "Play Integrity provider prepared successfully for project $cloudProjectNumber")
                callback(true, null)
            }.addOnFailureListener { e ->
                Log.e(TAG, "Failed to prepare Play Integrity: ${e.message}", e)
                callback(false, e.message ?: "Failed to prepare Play Integrity")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Exception preparing Play Integrity: ${e.message}", e)
            callback(false, e.message ?: "Exception preparing Play Integrity")
        }
    }

    /**
     * Requests a Standard Play Integrity token using the provided requestHash.
     */
    fun requestPlayIntegrityToken(
        requestHash: String,
        cloudProjectNumber: Long?,
        callback: (String?, String?) -> Unit
    ) {
        fun fetchToken(provider: StandardIntegrityTokenProvider) {
            try {
                provider.request(
                    StandardIntegrityTokenRequest.builder()
                        .setRequestHash(requestHash)
                        .build()
                ).addOnSuccessListener { response ->
                    val token = response.token()
                    Log.d(TAG, "Play Integrity token retrieved successfully")
                    callback(token, null)
                }.addOnFailureListener { e ->
                    Log.e(TAG, "Failed to request Play Integrity token: ${e.message}", e)
                    callback(null, e.message ?: "Failed to request Play Integrity token")
                }
            } catch (e: Exception) {
                Log.e(TAG, "Exception requesting Play Integrity token: ${e.message}", e)
                callback(null, e.message ?: "Exception requesting Play Integrity token")
            }
        }

        if (tokenProvider != null) {
            fetchToken(tokenProvider!!)
        } else if (cloudProjectNumber != null) {
            prepareIntegrity(cloudProjectNumber) { success, error ->
                if (success && tokenProvider != null) {
                    fetchToken(tokenProvider!!)
                } else {
                    callback(null, error ?: "Failed to prepare Play Integrity token provider")
                }
            }
        } else {
            callback(null, "Play Integrity provider not initialized. No cloud project number provided.")
        }
    }

    /**
     * Generates an ECDSA P-256 key pair in Android KeyStore with the attestation challenge.
     * Prefers StrongBox and falls back to TEE, never software.
     * Returns the leaf-first certificate chain encoded as base64 list.
     */
    fun generateAttestationKey(challengeBase64: String): List<String> {
        val challengeBytes = Base64.decode(challengeBase64, Base64.DEFAULT)

        val keyStore = KeyStore.getInstance(KEYSTORE_PROVIDER).apply { load(null) }
        if (keyStore.containsAlias(KEY_ALIAS)) {
            keyStore.deleteEntry(KEY_ALIAS)
        }

        fun buildSpec(useStrongBox: Boolean): KeyGenParameterSpec {
            val builder = KeyGenParameterSpec.Builder(
                KEY_ALIAS,
                KeyProperties.PURPOSE_SIGN or KeyProperties.PURPOSE_VERIFY
            )
                .setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1"))
                .setDigests(KeyProperties.DIGEST_SHA256)
                .setAttestationChallenge(challengeBytes)

            if (useStrongBox && Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                builder.setIsStrongBoxBacked(true)
            }
            return builder.build()
        }

        var generated = false
        // Try StrongBox first if supported
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P &&
            context.packageManager.hasSystemFeature(PackageManager.FEATURE_STRONGBOX_KEYSTORE)
        ) {
            try {
                val kpg = KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, KEYSTORE_PROVIDER)
                kpg.initialize(buildSpec(useStrongBox = true))
                kpg.generateKeyPair()
                generated = true
                Log.d(TAG, "Generated ECDSA key with StrongBox backing")
            } catch (e: Exception) {
                Log.w(TAG, "StrongBox generation failed, falling back to TEE: ${e.message}")
            }
        }

        // Fallback to TEE
        if (!generated) {
            val kpg = KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, KEYSTORE_PROVIDER)
            kpg.initialize(buildSpec(useStrongBox = false))
            kpg.generateKeyPair()
            Log.d(TAG, "Generated ECDSA key with TEE backing")
        }

        // Retrieve certificate chain (AndroidKeyStore returns leaf first)
        keyStore.load(null)
        val chain = keyStore.getCertificateChain(KEY_ALIAS)
            ?: throw IllegalStateException("Certificate chain not found for alias: $KEY_ALIAS")

        return chain.map { cert ->
            Base64.encodeToString(cert.encoded, Base64.NO_WRAP)
        }
    }

    /**
     * Signs the decoded payload bytes using SHA256withECDSA.
     * Returns base64-encoded ASN.1 DER signature.
     */
    fun signPayload(payloadBase64: String): String {
        val payloadBytes = Base64.decode(payloadBase64, Base64.DEFAULT)

        val keyStore = KeyStore.getInstance(KEYSTORE_PROVIDER).apply { load(null) }
        val privateKey = keyStore.getKey(KEY_ALIAS, null) as? PrivateKey
            ?: throw IllegalStateException("Private key not found for alias: $KEY_ALIAS")

        val signature = Signature.getInstance("SHA256withECDSA")
        signature.initSign(privateKey)
        signature.update(payloadBytes)
        val derSignatureBytes = signature.sign()

        return Base64.encodeToString(derSignatureBytes, Base64.NO_WRAP)
    }

    /**
     * Checks if the enrolled key exists in AndroidKeyStore.
     */
    fun hasAttestationKey(): Boolean {
        return try {
            val keyStore = KeyStore.getInstance(KEYSTORE_PROVIDER).apply { load(null) }
            keyStore.containsAlias(KEY_ALIAS)
        } catch (e: Exception) {
            false
        }
    }

    /**
     * Deletes the enrolled key.
     */
    fun deleteAttestationKey(): Boolean {
        return try {
            val keyStore = KeyStore.getInstance(KEYSTORE_PROVIDER).apply { load(null) }
            if (keyStore.containsAlias(KEY_ALIAS)) {
                keyStore.deleteEntry(KEY_ALIAS)
            }
            true
        } catch (e: Exception) {
            false
        }
    }
}

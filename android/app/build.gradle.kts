import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val localProperties = Properties().apply {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
            load(reader)
        }
    }
}

val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "2"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "2.0"

android {
    namespace = "ahmed.elhanbly.com"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    lint {
        checkReleaseBuilds = false
    }

    defaultConfig {
        applicationId = "ahmed.elhanbly.com"
        minSdk = 24
        targetSdk = 36
        multiDexEnabled = true
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    packagingOptions {
        pickFirst("lib/**/libc++_shared.so")
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"))
        }
    }

    configurations.all {
        resolutionStrategy {
            force("androidx.webkit:webkit:1.13.0")
            force("androidx.appcompat:appcompat:1.6.1")
            force("com.android.tools:desugar_jdk_libs:2.1.4")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    implementation("androidx.webkit:webkit:1.13.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
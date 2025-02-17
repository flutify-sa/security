plugins {
    id("com.android.application")
    id("kotlin-android")
   id("dev.flutter.flutter-gradle-plugin")

}

android {
    namespace = "com.example.security"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // Change to Java 17 to avoid issues
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString() // Ensure compatibility with Java 17
    }

    defaultConfig {
        applicationId = "com.example.security"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") // <-- уже есть
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bmarket.baimarket"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.bmarket.baimarket"
        minSdk = flutter.minSdkVersion // <-- Убедись, что здесь minSdk не меньше 19
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

// ✅ Добавить зависимости для Firebase Messaging
dependencies {
    implementation("com.google.firebase:firebase-messaging:23.4.1")
}

// ✅ Эта строка обязательно должна идти в конце!
apply(plugin = "com.google.gms.google-services")

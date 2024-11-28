plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.kotlin.android)
    id("maven-publish")
}

android {
    namespace = "org.phoenixframework.liveview.liveform"
    compileSdk = Constants.compileSdkVersion

    defaultConfig {
        minSdk = Constants.minSdkVersion

        testInstrumentationRunner = Constants.instrumentationRunnerClass
        consumerProguardFiles("consumer-rules.pro")
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = Constants.sourceCompatibilityVersion
        targetCompatibility = Constants.targetCompatibilityVersion
    }
    kotlinOptions {
        jvmTarget = Constants.jvmTargetVersion
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = Constants.kotlinCompilerExtVersion
    }
}

dependencies {
    implementation(libs.liveview.client.jetpack) {
        isChanging = true
    }
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.compose.ui)
    implementation(libs.androidx.compose.foundation)
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    testImplementation(libs.junit)
}

afterEvaluate {
    publishing {
        publications {
            register<MavenPublication>("release") {
                from(components["release"])
                groupId = Constants.publishGroupId
                artifactId = Constants.publishArtifactLiveForm
                version = Constants.publishVersion
            }
        }
    }
}

import com.android.build.gradle.internal.api.ApkVariantOutputImpl
import java.io.FileInputStream
import java.util.Base64
import java.util.Properties

plugins {
   id("com.android.application")
   id("dev.flutter.flutter-gradle-plugin")
}

// Shared by app and flutter_tts native regressions.
val robolectricVersion = providers.gradleProperty("robolectricVersion").get()

val keystoreProperties = Properties()
val keystorePath = rootProject.projectDir.parentFile.resolve("key.properties")
val minimumInstalledVersionCode = 2127
// Google Play builds use Play-managed updates. The ordinary GitHub release keeps
// its verified APK updater. CI sets this only for the separate Play AAB.
val dartDefines = providers.gradleProperty("dart-defines").orNull.orEmpty()
    .split(',').filter { it.isNotEmpty() }
    .map { String(Base64.getDecoder().decode(it), Charsets.UTF_8) }
fun dartFlag(name: String): Boolean {
    val flags = dartDefines.filter { it.substringBefore('=') == name }
    require(flags.size <= 1 && flags.all { it == "$name=true" || it == "$name=false" }) {
        "Set --dart-define=$name once, to true or false"
    }
    return flags.singleOrNull() == "$name=true"
}
val playEnvironment = providers.environmentVariable("ARES_PLAY_BUILD").orNull
require(playEnvironment in setOf(null, "false", "true")) { "ARES_PLAY_BUILD must be true or false" }
val playBuild = playEnvironment == "true"
require(playBuild == dartFlag("ARES_PLAY_BUILD")) {
    "ARES_PLAY_BUILD environment and Dart define must agree; set both for a Play build"
}
val parked = dartFlag("ARES_PARKED_AUTOMOTIVE")
val parkedEnvironment = providers.environmentVariable("ARES_PARKED_AUTOMOTIVE").orNull
require(parkedEnvironment == null || parkedEnvironment == parked.toString()) {
    "Select Automotive using --dart-define=ARES_PARKED_AUTOMOTIVE, not the environment alone"
}
val parkedPreview = parked && !playBuild
val parkedPlay = parked && playBuild
val automotiveCodeOffset = 1_000_000_000
val maxPlayVersionCode = 2_100_000_000
if (parkedPlay) {
    // Flutter also rewrites split APK codes; never run its split path in the AAB lane.
    require(providers.gradleProperty("split-per-abi").orNull != "true") { "Build the Automotive Play AAB without --split-per-abi" }
    require(flutter.versionCode <= maxPlayVersionCode - automotiveCodeOffset) { "Automotive versionCode exceeds the Play limit" }
    val pubspec = rootProject.projectDir.parentFile.resolve("pubspec.yaml").readLines()
    require(pubspec.single { it.startsWith("version:") }.substringAfter(':').trim() == "${flutter.versionName}+${flutter.versionCode}") {
        "Automotive Play identity must come from pubspec.yaml, without Flutter version overrides"
    }
} else if (playBuild) {
    require(flutter.versionCode < automotiveCodeOffset) { "Phone Play versionCode enters the reserved Automotive lane" }
}

if (keystorePath.exists() && !parkedPreview) {
   keystoreProperties.load(FileInputStream(keystorePath))
}

android {
   namespace = "com.hermesagent.hermes_android"
   compileSdk = 36

   compileOptions {
       sourceCompatibility = JavaVersion.VERSION_17
       targetCompatibility = JavaVersion.VERSION_17
       isCoreLibraryDesugaringEnabled = true
   }

   defaultConfig {
       check(flutter.versionCode > minimumInstalledVersionCode) {
           "versionCode ${flutter.versionCode} must be greater than " +
               "$minimumInstalledVersionCode to upgrade the accepted Hermes APK"
       }
       applicationId = "com.hermesagent.hermes_android"
       minSdk = if (parked) 33 else 24
       targetSdk = 36
       versionCode = if (parkedPlay) automotiveCodeOffset + flutter.versionCode else flutter.versionCode
       versionName = flutter.versionName
       manifestPlaceholders["appLabel"] = "Ares"
       buildConfigField("boolean", "PLAY_BUILD", playBuild.toString())
       buildConfigField("boolean", "PARKED_AUTOMOTIVE", parked.toString())
       }

       buildFeatures {
       buildConfig = true
       }

       signingConfigs {
       create("release") {
           if (keystoreProperties.containsKey("storeFile")) {
               storeFile = file(keystoreProperties["storeFile"] as String)
               storePassword = keystoreProperties["storePassword"] as String
               keyAlias = keystoreProperties["keyAlias"] as String
               keyPassword = keystoreProperties["keyPassword"] as String
           }
       }
   }

   buildTypes {
       debug {
           // The guarded Flutter versionCode is the base. The F-Droid ABI-split
           // block below derives per-ABI codes as base * 10 + ABI code; CI
           // verifies the packaged arm64 code against that scheme.
           applicationIdSuffix = if (parkedPreview) ".automotive.preview" else ".dev"
           versionNameSuffix = if (parkedPreview) "-parked-preview" else "-dev"
           manifestPlaceholders["appLabel"] = if (parkedPreview) "Ares Parked" else "Ares Dev"
       }
       release {
           isMinifyEnabled = true
           isShrinkResources = true
           proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "voice-proguard-rules.pro")
           // CI/local analysis may build a release artifact without access to
           // the private distribution keystore. Never fall back to the debug
           // key: leave the APK explicitly unsigned until the real
           // key.properties file is supplied.
           if (keystorePath.exists()) {
               signingConfig = signingConfigs.getByName("release")
           }
       }
   }

   packaging {
      jniLibs.useLegacyPackaging = false
   }

   if (parked) {
      // This overlay includes the Play install-permission and updater-provider removals.
      sourceSets.getByName(if (parkedPlay) "release" else "debug").manifest.srcFile("src/parked/AndroidManifest.xml")
   } else if (playBuild) {
      // A build-invocation-specific overlay keeps the default GitHub release
      // unchanged without introducing flavour-specific APK names.
      sourceSets.getByName("release").manifest.srcFile("src/play/AndroidManifest.xml")
   }

   androidResources {
       noCompress += "onnx"
   }

   dependenciesInfo {
       includeInApk = false
       includeInBundle = false
   }
}

// No profile fallback, signed preview, or debug build with the production package.
androidComponents.beforeVariants { variant ->
    if (parked && variant.buildType != (if (parkedPlay) "release" else "debug")) variant.enable = false
}

kotlin {
   compilerOptions {
       jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
   }
}

flutter {
   source = "../.."
}

// Keep the Library notice/licence available in every distributed APK, not only
// in a repository URL. Source/relink archives accompany the APK separately.
val pushNotices = tasks.register<Sync>("prepareEmbeddedPushNotices") {
    from(rootProject.projectDir.parentFile.resolve("third_party")) {
        include("embedded-push-notice.md", "embedded-push-relink.md")
        include("licenses/embedded-fcm-distributor-LGPL-2.1.txt")
        include("NOTICE.md", "licenses/Apache-2.0.txt", "licenses/gradle-NOTICE.txt")
        include("sources/embedded-fcm-distributor-3.1.0/**")
        // Android's asset merger transparently decompresses *.gz and strips its
        // suffix. Preserve the verified archive bytes and hash with an alias.
        rename { name -> if (name.endsWith(".tar.gz")) "$name.bin" else name }
    }
    into(layout.buildDirectory.dir("generated/embeddedPushAssets/third_party"))
}
android.sourceSets.getByName("main").assets.srcDir(layout.buildDirectory.dir("generated/embeddedPushAssets").get().asFile)
tasks.matching { it.name.startsWith("merge") && it.name.endsWith("Assets") }.configureEach {
    dependsOn(pushNotices)
}

// F-Droid ABI split: version codes are derived per ABI as base * 10 + abiCode,
// with armeabi-v7a < arm64-v8a < x86_64 as required by fdroiddata.
val abiCodes = mapOf("armeabi-v7a" to 1, "arm64-v8a" to 2, "x86_64" to 3)
android.applicationVariants.configureEach {
    val variant = this
    variant.outputs.forEach { output ->
        val abiVersionCode =
            abiCodes[output.filters.find { it.filterType == "ABI" }?.identifier]
        if (!parkedPlay && abiVersionCode != null) {
            (output as ApkVariantOutputImpl).versionCodeOverride =
                variant.versionCode * 10 + abiVersionCode
        }
    }
}

// A task-backed file dependency: a clean Gradle build cannot resolve an unverified
// local AAR, nor package an untracked developer-only model directory.
val voiceInputsDir = rootProject.layout.buildDirectory.dir("voice-inputs")
val prepareVoiceInputs = tasks.register<Exec>("prepareVoiceInputs") {
    val repository = rootProject.projectDir.parentFile
    workingDir(repository)
    commandLine("python3", repository.resolve("scripts/prepare_voice_inputs.py").absolutePath,
        "--output", voiceInputsDir.get().asFile.absolutePath)
    inputs.file(repository.resolve("scripts/prepare_voice_inputs.py"))
    inputs.dir(repository.resolve("third_party/voice"))
    outputs.dir(voiceInputsDir)
    // Reverify cache/AAR/model hashes at the build boundary, even after a prior build.
    outputs.upToDateWhen { false }
}
val voiceAar = files(voiceInputsDir.map { it.file("sherpa-onnx-2.0.1.aar") }).builtBy(prepareVoiceInputs)
android.sourceSets.getByName("main").assets.srcDir(voiceInputsDir.get().dir("assets").asFile)
tasks.matching { it.name == "preBuild" || it.name.startsWith("merge") && it.name.endsWith("Assets") }.configureEach {
    dependsOn(prepareVoiceInputs)
}

dependencies {
   implementation(voiceAar)
   // Open-source C2DM IPC transport, not Firebase SDK/GMS client libraries.
   val replacementEmbeddedPushAar = providers.gradleProperty("embeddedPushAar").orNull
   if (replacementEmbeddedPushAar == null) {
       implementation("org.unifiedpush.android:embedded-fcm-distributor:3.1.0")
   } else {
       // LGPL relinking path: use the recipient's rebuilt Library, without any
       // release-signing secret. A local AAR has no POM, so retain runtime deps.
       val replacement = file(replacementEmbeddedPushAar)
       require(replacement.isFile && replacement.extension == "aar") { "embeddedPushAar must name an existing .aar" }
       implementation(files(replacement))
       implementation("org.jetbrains.kotlin:kotlin-stdlib:2.4.21")
       implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core-jvm:1.11.0")
   }
   implementation("org.unifiedpush.android:connector:3.3.6") {
       // flutter_secure_storage already uses tink-android. The JVM artifact
       // contains the same classes and cannot coexist in an APK.
       exclude(group = "com.google.crypto.tink", module = "tink")
   }
   implementation("com.google.crypto.tink:tink-android:1.24.0")
   testImplementation("junit:junit:4.13.2")
   testImplementation("org.robolectric:robolectric:$robolectricVersion")
   coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

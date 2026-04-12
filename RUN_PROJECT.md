# Run `city_voice_app_v3` Flutter Project

## 1. Install Flutter SDK

1. Download Flutter SDK for Linux from:
   - https://docs.flutter.dev/get-started/install/linux
2. Extract the archive into your home directory:
   ```bash
   cd ~
   tar xf flutter_linux_3.41.6-stable.tar.xz
   ```
3. Add Flutter to your shell path: 
   ```bash
   echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```
4. Verify Flutter is available:
   ```bash
   command -v flutter
   flutter --version
   ```

## 2. Install Android Studio and Android SDK tools

1. Install Android Studio if you have not already.
2. Open Android Studio, then `Configure` → `SDK Manager`.
3. In `SDK Platforms` install a recent Android SDK (for example API 36 or 37).
4. In `SDK Tools` install:
   - Android SDK Command-line Tools
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - Android SDK Tools (if available)
   - CMake
5. Set the Android SDK environment variables in `~/.bashrc`:
   ```bash
   echo 'export ANDROID_SDK_ROOT="$HOME/Android/Sdk"' >> ~/.bashrc
   echo 'export ANDROID_HOME="$HOME/Android/Sdk"' >> ~/.bashrc
   echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

## 3. Accept Android SDK licenses

Run:
```bash
cd ~/city_voice_app_v3
flutter doctor --android-licenses
```
Accept all license prompts.

## 4. Verify environment

Run:
```bash
cd ~/city_voice_app_v3
flutter doctor
```

In this project, only Android support is required. It is okay if `flutter doctor` shows warnings about:
- Chrome not found
- Linux toolchain missing `clang++`, `cmake`, `ninja`, `libgtk-3-dev`

## 5. Project setup

Run:
```bash
cd ~/city_voice_app_v3
flutter pub get
```

## 6. Run on Android device or emulator

1. Connect an Android device with USB debugging enabled or start an emulator.
2. Check devices:
   ```bash
   flutter devices
   ```
3. Run the app:
   ```bash
   flutter run
   ```

If your device is slow to connect, add a longer timeout:
```bash
flutter run --device-timeout 120s
```

## 7. Build release APK

To build a release APK for sharing or installation:
```bash
cd ~/city_voice_app_v3
flutter build apk --release
```

The APK output is at:
```bash
build/app/outputs/flutter-apk/app-release.apk
```

## 8. Fix Android build issues

### AndroidX
Make sure `android/gradle.properties` contains:
```properties
android.useAndroidX=true
android.enableJetifier=true
```

### MainActivity
If app crash says `MainActivity` not found, ensure file exists:
`android/app/src/main/kotlin/com/example/city_voice_app/MainActivity.kt`
with:
```kotlin
package com.example.city_voice_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {}
```

## 9. GitHub release (optional)

1. Commit changes:
   ```bash
git add .
git commit -m "Prepare release"
git push origin main
```
2. Create a GitHub release on the repository page.
3. Upload the APK asset from:
   - `build/app/outputs/flutter-apk/app-release.apk`

---

This file summarizes the exact process we followed to get the project running on Android.

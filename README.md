# 🎙️ City Voice App

A modern, fully-localized Flutter application for reporting civic issues and participating in community governance. Built for iOS and Android with multi-language support, rich authentication, and real-time social features.

[![Flutter](https://img.shields.io/badge/Flutter-3.41.0-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.0-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](#license)

---

## ✨ Features

### 🔐 Authentication
- **Email Authentication** - Gmail-only with real-time validation
- **Phone Authentication** - SMS verification with 6-digit codes
- **Guest Access** - Browse without registration
- **Secure Sessions** - Persistent login across app restarts

### 🌍 Localization
- **3 Languages:** English, Russian, Kazakh
- **Auto-detection:** Respects device language on first launch
- **Persistent Preferences:** User selection saved
- **Type-Safe:** No runtime localization errors

### 🎨 Theme Support
- **3 Modes:** Light, Dark, Auto (follows system)
- **Material Design 3** - Modern UI/UX
- **Accessible Colors** - WCAG AA compliant
- **Persistent Selection** - Theme preference saved

### 📝 Reports & Social Feed
- **Create Reports** - Submit civic issues with images
- **Social Feed** - Browse community reports
- **Interactive Features** - Like, comment, share
- **Lazy Loading** - Infinite scroll with refresh
- **User Avatars** - Visual identification

### 💾 Draft Management
- **Auto-Save** - Never lose unsaved work
- **Draft History** - View and manage all drafts
- **Quick Resume** - Continue editing previous reports

### ⚙️ Settings
- **Profile Management** - User account settings
- **Preferences** - Language, theme, notifications
- **FAQ & Support** - Comprehensive help documentation

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.10.1+
- Dart SDK 3.11.0+
- iOS: Xcode (macOS)
- Android: Android Studio with SDK

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/city_voice_app.git
cd city_voice_app_v1

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Run the app
flutter run
```

### Build

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 📱 Screenshots & UI

- **Modern Material Design 3** interface
- **Dark/Light theme** support with smooth transitions
- **Responsive layouts** for all device sizes
- **Smooth animations** and transitions
- **Accessible components** for all users

---

## 📂 Project Structure

```
lib/
├── screens/              # UI Screens
├── models/               # Data models
├── providers/            # State management (Provider)
├── services/             # Business logic
├── widgets/              # Reusable components
├── themes/               # Theme configuration
├── utils/                # Utility functions
└── l10n/                 # Localization files
```

---

## 🛠️ Technology Stack

- **Framework:** Flutter 3.41.0
- **Language:** Dart 3.11.0
- **State Management:** Provider
- **Local Storage:** Hive
- **Localization:** flutter_localizations, intl
- **Fonts:** Google Fonts
- **Location:** Geolocator
- **Media:** Image Picker
- **Permissions:** Permission Handler

---

## 📖 Documentation

- **[DOCUMENTATION_EN.md](DOCUMENTATION_EN.md)** - Complete English guide
- **[DOCUMENTATION_RU.md](DOCUMENTATION_RU.md)** - Полное руководство на русском
- **[pubspec.yaml](pubspec.yaml)** - Dependencies and configuration

---

## 🎯 Key Implementation Details

### Multi-Language Support
```dart
// Access translations easily
String email = context.l10n.email;
String password = context.l10n.password;
```

### Theme Management
```dart
// Access theme from provider
context.watch<ThemeProvider>().themeMode
```

### Local Storage
```dart
// Using Hive for persistence
final userBox = Hive.box('users');
```

---

## 🧪 Testing

Run tests with:
```bash
flutter test
```

---

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/YourFeature`)
3. Commit changes (`git commit -m 'Add YourFeature'`)
4. Push to branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

---

## 📝 License

This project is proprietary and confidential. Unauthorized copying or distribution is prohibited.

---

## 👨‍💻 Authors

- **Development Team** - City Voice App

---

## 📞 Support

For issues, questions, or feature requests:
- Create a [GitHub Issue](https://github.com/your-username/city_voice_app/issues)
- Email: support@cityvoiceapp.com
- In-app FAQ & Support section

---

## 🔄 Version History

- **v1.0.0** (February 2026) - Initial release
  - Multi-language support (EN, RU, KK)
  - Email & phone authentication
  - Social feed with reports
  - Theme management
  - Draft auto-save
  - Comprehensive documentation

---

## 🙏 Acknowledgments

- Flutter community for excellent documentation
- Material Design 3 for modern UI principles
- All contributors and testers

---

**Made with ❤️ for better civic engagement**
# city_voice_app
# city_voice_app
# city_voice

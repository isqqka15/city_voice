# City Voice App - Complete Documentation

## 📱 Project Overview

**City Voice App** is a modern, fully-localized Flutter mobile application designed for iOS and Android platforms. The app enables users to report civic issues, share updates with their community, and participate in local governance through an intuitive, multi-language interface.

**Version:** 1.0.0+1  
**Framework:** Flutter 3.10.1+  
**Platforms:** iOS & Android  
**Languages Supported:** English, Russian, Kazakh

---

## 🎯 Core Features

### 1. **Authentication & Authorization**
- **Email Authentication** - Gmail-only validation with real-time error feedback
- **Phone Authentication** - SMS-based verification with 6-digit code
- **Guest Access** - Browse app without registration
- **Persistent Sessions** - User stays logged in across app restarts
- **Secure Password Management** - 8+ character requirement with validation

**Auth Screens:**
- Welcome Screen - Initial entry point
- Auth Method Selection - Choose email or phone authentication
- Authentication Screen - Login/Registration with real-time validation
- Verification Screen - SMS code verification with countdown timer

### 2. **Multi-Language Support**
- **Automatic Detection** - Respects device system language on first launch
- **Persistent Preferences** - User selection saved across sessions
- **Three Languages Included:**
  - English (en) - Default fallback
  - Russian (ru)
  - Kazakh (kk)
- **Easy Extensibility** - Simple process to add new languages
- **Type-Safe Localization** - No runtime string errors

**Language Access:** `context.l10n.stringKey` syntax via custom extension

### 3. **Theme Management**
- **Three Theme Modes:**
  - Auto - Follows system settings
  - Light - Clean, bright interface
  - Dark - Eye-friendly dark mode
- **Persistent Selection** - Theme preference saved across sessions
- **Material Design 3** - Modern, cohesive design language
- **Accessible Color Scheme:**
  - Light: Earthy browns and off-whites
  - Dark: Deep blacks with light accents
  - WCAG AA contrast compliance

### 4. **Reports & Social Feed**
- **Create Reports** - Submit civic issues with text, images, and details
- **Rich Feed** - Browse community reports with infinite scroll
- **Interactive Elements:**
  - Like/Unlike reports
  - Comment on issues
  - Share reports
  - Expandable content for long texts
- **Real-Time Updates** - Pull-to-refresh functionality
- **Timestamps** - Human-readable relative time
- **User Avatars** - Visual identification with initials

### 5. **Draft Management**
- **Auto-Save Drafts** - Never lose unsaved reports
- **Draft History** - View and manage all saved drafts
- **Quick Resume** - Continue editing previously started reports
- **Local Storage** - All drafts stored securely on device

### 6. **Settings & Preferences**
- **User Profile** - View and manage account information
- **Language Selection** - Switch between English, Russian, Kazakh
- **Theme Switching** - Toggle between Light/Dark/Auto modes
- **FAQ & Support** - Comprehensive help documentation
- **Account Management** - Logout and account recovery

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── app.dart                           # App widget & routing
│
├── screens/                           # UI Screens
│   ├── welcome_screen.dart            # Initial welcome page
│   ├── auth_start_screen.dart         # Email/phone tab interface
│   ├── auth_screen.dart               # Login/registration form
│   ├── auth_method_selection_screen.dart
│   ├── onboarding_flow.dart           # Onboarding pages
│   ├── report_form_screen.dart        # Create/edit reports
│   ├── reports_feed_screen.dart       # Social feed
│   ├── drafts_screen.dart             # Saved drafts
│   ├── requests_screen.dart           # Service requests
│   ├── settings_screen.dart           # User settings
│   ├── support_screen.dart            # Support options
│   ├── faq_screen.dart                # FAQ & help
│   └── support_faq_combined_screen.dart
│
├── models/                            # Data Models
│   └── report.dart                    # Report data structure
│
├── providers/                         # State Management
│   ├── locale_provider.dart           # Language management
│   └── theme_provider.dart            # Theme management
│
├── services/                          # Business Logic
│   ├── report_service.dart            # Report operations
│   └── draft_service.dart             # Draft management
│
├── widgets/                           # Reusable Components
│   ├── language_selector.dart         # Language switcher
│   ├── theme_selector.dart            # Theme switcher
│   ├── phone_input_field.dart         # Unified phone input
│   ├── email_input_field.dart         # Email input with validation
│   ├── password_input_field.dart      # Password with show/hide
│   └── [other custom widgets]
│
├── utils/                             # Utility Functions
│   ├── email_validator.dart           # Gmail validation
│   ├── l10n_extension.dart            # Localization helper
│   └── [validators & helpers]
│
├── themes/                            # Theme Configuration
│   └── app_theme.dart                 # Light/Dark themes
│
└── l10n/                              # Localization Files
    ├── app_localizations.dart         # Base class
    ├── app_localizations_en.dart      # English
    ├── app_localizations_ru.dart      # Russian
    └── app_localizations_kk.dart      # Kazakh
```

---

## 🔧 Technology Stack

### Core Dependencies
- **Flutter** - Cross-platform mobile framework
- **Provider** - State management
- **Hive** - Local data storage
- **Google Fonts** - Custom typography
- **Geolocator** - Location services
- **Image Picker** - Camera/gallery access
- **Permission Handler** - Runtime permissions

### Localization & Internationalization
- **flutter_localizations** - Dart/Flutter localization
- **intl** - Internationalization utilities

### Development Tools
- **Build Runner** - Code generation
- **Hive Generator** - Type-safe storage
- **Flutter Lints** - Code quality

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.1 or higher
- Dart SDK (included with Flutter)
- iOS: Xcode with command line tools (macOS)
- Android: Android Studio with SDK tools

### Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd city_voice_app_v1
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Code**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the App**
   ```bash
   # iOS
   flutter run -d ios
   
   # Android
   flutter run -d android
   
   # Generic
   flutter run
   ```

### Build for Release

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 🎨 Design System

### Color Palette

**Light Theme:**
```
Primary:        #545145 (Muted Brown)
Background:     #F1F0EE (Off-White)
Surface:        #FFFFFF (Pure White)
Text:           #0E0D0B (Deep Brown)
Secondary:      #ABBAB8 (Light Gray)
Error:          #BA1A1A (Red)
```

**Dark Theme:**
```
Primary:        #BAB7AB (Light Brown)
Background:     #11100E (Deep Black)
Surface:        #1C1B19 (Charcoal)
Text:           #F4F3F1 (Off-White)
Secondary:      #455452 (Dark Gray)
Error:          #FFB4AB (Light Red)
```

### Typography
- **Font Family:** Google Fonts (configurable)
- **Display Sizes:** 32sp, 28sp, 24sp for headers
- **Body Sizes:** 16sp, 14sp for content
- **Caption Size:** 12sp for helpers

### Component Styles
- **Buttons:** Rounded corners (12dp), Material 3 style
- **Input Fields:** Outlined style with rounded borders (12dp)
- **Cards:** Elevated with subtle shadows
- **Lists:** Clean typography with proper spacing

---

## 👤 User Flows

### 1. Registration Flow (Email)
```
Welcome Screen
    ↓
Auth Method Selection (Email/Phone)
    ↓
Auth Screen - Sign Up Tab
    ├─ Enter Email (Gmail only)
    ├─ Enter Password (8+ characters)
    ├─ Confirm Password
    ├─ Accept Terms
    ↓
Account Created
    ↓
Login Successful
    ↓
Dashboard/Home Screen
```

### 2. Registration Flow (Phone)
```
Auth Screen - Phone Tab
    ├─ Enter Phone Number (international format)
    ├─ Receive SMS Code
    ↓
Verification Screen
    ├─ Enter 6-digit Code
    ├─ 60-second Resend Timer
    ↓
Account Created
    ↓
Dashboard/Home Screen
```

### 3. Report Creation Flow
```
Dashboard
    ↓
Tap "Create Report" Button
    ↓
Report Form Screen
    ├─ Enter Title
    ├─ Enter Description
    ├─ Add Photo (optional)
    ├─ Select Category
    ├─ Add Location (optional)
    ↓
Preview Report
    ↓
Submit
    ↓
Report Published to Feed
    ↓
Notification Sent to Followers
```

---

## 🌐 Localization

### Adding a New Language

1. **Add Language Code to Locale Provider:**
   ```dart
   // lib/providers/locale_provider.dart
   List<Locale> getSupportedLocales() {
     return [
       Locale('en'),
       Locale('ru'),
       Locale('kk'),
       Locale('fr'), // New language
     ];
   }
   ```

2. **Create Localization File:**
   ```dart
   // lib/l10n/app_localizations_fr.dart
   class AppLocalizationsFr extends AppLocalizations {
     @override
     String get appTitle => 'City Voice';
     @override
     String get email => 'E-mail';
     // ... all translation strings
   }
   ```

3. **Update App Localizations:**
   ```dart
   // lib/l10n/app_localizations.dart
   static AppLocalizations of(BuildContext context) {
     switch(locale.languageCode) {
       case 'fr':
         return AppLocalizationsFr();
       // ... other languages
     }
   }
   ```

### Accessing Translations

```dart
// Using the extension (recommended)
String email = context.l10n.email;

// Using AppLocalizations directly
String password = AppLocalizations.of(context)!.password;
```

---

## 🔐 Authentication Details

### Email Validation Rules
- **Format:** Must be a valid email format
- **Provider:** Gmail only (gmail.com, googlemail.com)
- **Error Messages:** Localized in 3 languages

**Validation Flow:**
```
Empty?      → "Email is required"
Invalid?    → "Please enter a valid email"
Not Gmail?  → "Please use a Gmail address"
Valid       → ✓ Accepted
```

### Password Requirements
- **Minimum Length:** 8 characters
- **Confirmation:** Must match on registration
- **Storage:** Securely hashed (production)
- **Show/Hide:** Toggle visibility on input field

### Phone Authentication
- **Format:** International format supported (+1-555-0000)
- **Verification:** SMS with 6-digit code
- **Timeout:** 60-second resend limit
- **Attempts:** Unlimited with rate limiting (production)

---

## 💾 Data Storage

### Local Storage (Hive)
- **User Session:** Persistent login token
- **Preferences:** Language & theme selections
- **Drafts:** Unsaved report drafts
- **Cache:** Recent reports and user data

### Data Models

**Report:**
```dart
class Report {
  String id;
  String userId;
  String title;
  String content;
  List<String> tags;
  DateTime createdAt;
  int likes;
  int comments;
  // ... other fields
}
```

---

## 🎬 Animations & Transitions

### Page Transitions
- **Fade In/Out:** Screen navigation
- **Slide Up:** Bottom sheet dialogs
- **Scale:** Button presses and taps

### Loading States
- **Shimmer Animation:** Content loading
- **Progress Indicator:** Form submission
- **Staggered List Animation:** Feed items

### Interactive Animations
- **Like Button:** Scale animation on tap
- **Expandable Text:** Smooth height transition
- **Theme Toggle:** Cross-fade between light/dark

---

## 📞 Settings & Preferences

### User Settings Available
- **Language:** Switch between 3 languages
- **Theme:** Light/Dark/Auto modes
- **Notifications:** Enable/disable notifications
- **Privacy:** Control data sharing options
- **Account:** View profile, logout

### SharedPreferences Storage
```dart
// Language preference
'selectedLocale' → Locale object

// Theme preference
'selectedTheme' → ThemeMode enum

// User data
'userId' → String
'userEmail' → String
```

---

## ⚙️ Configuration

### App Manifest (Android)
- **Package Name:** com.example.city_voice_app
- **Min SDK:** 21 (Android 5.0+)
- **Target SDK:** 34 (Android 14+)
- **Permissions:** Camera, Location, Storage, SMS, Phone

### Info.plist (iOS)
- **Bundle ID:** com.example.cityVoiceApp
- **Deployment Target:** 12.0+
- **Permissions:** Camera, Location, Photo Library

### pubspec.yaml
```yaml
version: 1.0.0+1
environment:
  sdk: ^3.10.1
dependencies:
  flutter: sdk: flutter
  provider: ^6.1.2
  hive: ^2.2.3
  google_fonts: ^6.1.0
  # ... other packages
```

---

## 🐛 Troubleshooting

### Common Issues

**App Won't Start**
- Clear build cache: `flutter clean`
- Reinstall dependencies: `flutter pub get`
- Run code generation: `flutter pub run build_runner build`

**Language Not Changing**
- Verify locale provider initialization in main()
- Check SharedPreferences for saved locale
- Confirm AppLocalizations.of() uses correct locale

**Theme Not Persisting**
- Ensure ThemeProvider.initialize() called in main()
- Check SharedPreferences for saved theme mode
- Verify MaterialApp receives themeMode from provider

**Build Errors**
- Check Flutter version: `flutter --version`
- Verify Android SDK: `flutter doctor`
- Clean build: `flutter clean && flutter pub get`

---

## 📝 Code Style & Conventions

### Naming Conventions
- **Classes:** PascalCase (MyClass)
- **Methods/Variables:** camelCase (myVariable)
- **Constants:** camelCase with const keyword
- **Files:** snake_case (my_file.dart)

### Best Practices
1. **Separation of Concerns** - UI/Logic/Storage layers
2. **Provider Pattern** - State management
3. **Widget Composition** - Reusable components
4. **Error Handling** - Try-catch with user feedback
5. **Documentation** - Comments for complex logic

### File Templates

**Screen:**
```dart
import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: Center(child: Text('Content')),
    );
  }
}
```

---

## 🚀 Deployment

### Pre-Release Checklist
- [ ] All strings localized in 3 languages
- [ ] Theme tested in light/dark modes
- [ ] Authentication flows verified
- [ ] Error messages user-friendly
- [ ] Images/assets optimized
- [ ] App icons configured
- [ ] Privacy policy ready
- [ ] Terms of service prepared

### Release Steps

**Android:**
1. Update version in pubspec.yaml
2. Build signed APK/bundle: `flutter build appbundle --release`
3. Upload to Google Play Console
4. Configure store listing & screenshots
5. Submit for review

**iOS:**
1. Update version in pubspec.yaml
2. Update build number: `flutter build ios --release`
3. Archive in Xcode
4. Upload to App Store Connect
5. Configure app info & screenshots
6. Submit for review

---

## 📚 Additional Resources

- **Flutter Documentation:** https://flutter.dev/docs
- **Material Design 3:** https://m3.material.io/
- **Dart Language:** https://dart.dev/guides
- **Provider Package:** https://pub.dev/packages/provider
- **Hive Database:** https://docs.hivedb.dev/

---

## 📞 Support & Contact

For issues, questions, or feature requests:
- Create GitHub issue: [Repository Issues]
- Email support: support@cityvoiceapp.com
- FAQ & Help: In-app Settings → FAQ & Support

---

## 📄 License

This project is proprietary and confidential. Unauthorized copying or distribution is prohibited.

---

**Last Updated:** February 12, 2026  
**Maintained By:** Development Team  
**Version:** 1.0.0+1

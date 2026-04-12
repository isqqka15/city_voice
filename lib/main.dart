import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:city_voice_app/app.dart';
import 'package:city_voice_app/models/report.dart';
import 'package:city_voice_app/providers/locale_provider.dart';
import 'package:city_voice_app/providers/theme_provider.dart';

// Main entry point of the app.
// Initializes Flutter bindings, sets up Hive for local storage,
// registers the Report adapter, and runs the App widget.
// Also initializes locale and theme providers for persistence.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hide system status bar for immersive fullscreen experience
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ReportAdapter());
  
  // Initialize providers before running the app
  final localeProvider = LocaleProvider();
  final themeProvider = ThemeProvider();
  
  await localeProvider.initialize();
  await themeProvider.initialize();
  
  runApp(const App());
}

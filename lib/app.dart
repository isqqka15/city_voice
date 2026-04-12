import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:city_voice_app/screens/auth_start_screen.dart';
import 'package:city_voice_app/screens/welcome_screen.dart';
import 'package:city_voice_app/screens/auth_method_selection_screen.dart';
import 'package:city_voice_app/screens/auth_screen.dart';
import 'package:city_voice_app/screens/requests_screen.dart';
import 'package:city_voice_app/providers/report_provider.dart';
import 'package:city_voice_app/providers/locale_provider.dart';
import 'package:city_voice_app/providers/report_filter_provider.dart';
import 'package:city_voice_app/providers/theme_provider.dart';
import 'package:city_voice_app/providers/auth_provider.dart';
import 'package:city_voice_app/providers/draft_provider.dart';
import 'package:city_voice_app/services/draft_service.dart';
import 'package:city_voice_app/themes/app_themes.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';

// Root widget of the application.
// Sets up the Provider for state management, configures MaterialApp
// with theme, localization support for EN/RU/KZ, and routes for onboarding/auth flow.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => ReportFilterProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => DraftProvider(DraftService()),
          lazy: false,
        ),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProvider, themeProvider, child) => Consumer<AuthProvider>(
          builder: (context, authProvider, _) => MaterialApp(
            title: 'CityVoiceApp',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode, // Dynamic theme mode from provider
            locale: localeProvider.locale, // Dynamic locale from provider
            localizationsDelegates: const [
              AppLocalizations.delegate, // Generated localizations
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('ru', ''), // Russian
              Locale('kk', ''), // Kazakh
            ],
            // Named routes for navigation
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/welcome':
                  return MaterialPageRoute(builder: (_) => const WelcomeScreen());
                case '/auth-method-selection':
                  return MaterialPageRoute(builder: (_) => const AuthMethodSelectionScreen());
                case '/auth':
                  final authMethod = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (_) => AuthScreen(initialTab: authMethod == 'phone' ? 1 : 0),
                  );
                case '/requests':
                  return MaterialPageRoute(builder: (_) => const RequestsScreen());
                default:
                  return MaterialPageRoute(
                    builder: (_) => const AuthStartScreen(),
                  );
              }
            },
            // Home screen based on authentication state
            home: authProvider.isAuthenticated
                ? const RequestsScreen()
                : const WelcomeScreen(),
          ),
        ),
      ),
    );
  }
}
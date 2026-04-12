import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_voice_app/providers/theme_provider.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/widgets/language_selector.dart';

/// Welcome/Onboarding screen - first screen users see
/// Shows app greeting and "Get Started" button with language selector
/// Features smooth entrance animations for visual polish
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with theme toggle and language selector
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Language selector
                    const LanguageSelector(isDense: true),
                    // Theme toggle
                    IconButton(
                      icon: Icon(
                        context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      onPressed: () async {
                        await context.read<ThemeProvider>().toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Main content
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App icon/logo with pulse animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1.0, end: 1.08),
                        duration: const Duration(milliseconds: 2000),
                        curve: Curves.easeInOut,
                        onEnd: () {},
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(60),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: 60,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // App name
                      Text(
                        localizations.appTitle,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Subtitle/description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          localizations.welcomeDescription,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),

            // Get Started button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/auth-method-selection');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.brightness == Brightness.dark
                              ? theme.colorScheme.surface
                              : theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          localizations.getStarted,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Terms and conditions note
                    Text(
                      localizations.agreeToTerms,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

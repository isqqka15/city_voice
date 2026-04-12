import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_voice_app/providers/locale_provider.dart';
import 'package:city_voice_app/providers/theme_provider.dart';
import 'package:city_voice_app/providers/auth_provider.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/screens/welcome_screen.dart';
import 'package:city_voice_app/utils/animated_route.dart';

// Settings screen with language, theme, and authentication options.
// Uses flat UI design with minimal styling.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          _buildSectionHeader(localizations.language),
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return Column(
                children: [
                  _buildLanguageOption(
                    context,
                    localizations.englishNative,
                    const Locale('en'),
                    localeProvider.locale,
                    () => localeProvider.setLocale(const Locale('en')),
                  ),
                  _buildLanguageOption(
                    context,
                    localizations.russianNative,
                    const Locale('ru'),
                    localeProvider.locale,
                    () => localeProvider.setLocale(const Locale('ru')),
                  ),
                  _buildLanguageOption(
                    context,
                    localizations.kazakhNative,
                    const Locale('kk'),
                    localeProvider.locale,
                    () => localeProvider.setLocale(const Locale('kk')),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Theme Section
          _buildSectionHeader(localizations.theme),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Column(
                children: [
                  _buildThemeOption(
                    context,
                    localizations.light,
                    ThemeMode.light,
                    themeProvider.themeMode,
                    () => themeProvider.setThemeMode(ThemeMode.light),
                  ),
                  _buildThemeOption(
                    context,
                    localizations.dark,
                    ThemeMode.dark,
                    themeProvider.themeMode,
                    () => themeProvider.setThemeMode(ThemeMode.dark),
                  ),
                  _buildThemeOption(
                    context,
                    localizations.system,
                    ThemeMode.system,
                    themeProvider.themeMode,
                    () => themeProvider.setThemeMode(ThemeMode.system),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Account Section
          _buildSectionHeader(localizations.account),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isAuthenticated) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${localizations.welcome}, ${authProvider.currentUser!.name}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () => _showChangePasswordDialog(context, authProvider),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(localizations.changePassword),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                              // Clear user session
                              await authProvider.logout();
                              
                              if (context.mounted) {
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(localizations.loggedOutSuccessfully),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                
                                // Navigate to WelcomeScreen (Get Started screen) with smooth transition
                                // Use pushAndRemoveUntil to clear all routes from stack
                                Navigator.of(context).pushAndRemoveUntil(
                                  FadePageRoute(builder: (_) => const WelcomeScreen()),
                                  (route) => false, // Remove all routes from stack
                                );
                              }
                            },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(localizations.logout),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        localizations.loginPrompt,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showLoginDialog(context),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(localizations.login),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    Locale locale,
    Locale currentLocale,
    VoidCallback onTap,
  ) {
    final isSelected = locale.languageCode == currentLocale.languageCode;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  fontWeight: isSelected ? FontWeight.w500 : null,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label,
    ThemeMode themeMode,
    ThemeMode currentThemeMode,
    VoidCallback onTap,
  ) {
    final isSelected = themeMode == currentThemeMode;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  fontWeight: isSelected ? FontWeight.w500 : null,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.login),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: localizations.email,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: localizations.password,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              final success = await authProvider.loginWithEmail(
                emailController.text,
                passwordController.text,
              );
              if (success && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(localizations.login),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(
      BuildContext context, AuthProvider authProvider) {
    final localizations = AppLocalizations.of(context)!;
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(localizations.changePassword),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    decoration: InputDecoration(
                      labelText: localizations.currentPassword,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: localizations.newPassword,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: localizations.confirmPassword,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                  ),
                  if (authProvider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      authProvider.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(localizations.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (newPasswordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.passwordsDoNotMatch),
                        ),
                      );
                      return;
                    }

                    final success = await authProvider.changePassword(
                      authProvider.currentUser?.email ?? '',
                      currentPasswordController.text,
                      newPasswordController.text,
                    );

                    if (success && context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.passwordChangedSuccessfully),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(localizations.change),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
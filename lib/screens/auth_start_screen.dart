import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_voice_app/providers/auth_provider.dart';
import 'package:city_voice_app/providers/locale_provider.dart';
import 'package:city_voice_app/providers/theme_provider.dart';
import 'package:city_voice_app/screens/requests_screen.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/utils/email_validator.dart';

class AuthStartScreen extends StatefulWidget {
  const AuthStartScreen({super.key});

  @override
  State<AuthStartScreen> createState() => _AuthStartScreenState();
}

class _AuthStartScreenState extends State<AuthStartScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoginMode = true;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  void _validateEmail(AppLocalizations localizations) {
    setState(() {
      _emailError = EmailValidator.validate(_emailController.text, localizations);
    });
  }

  void _validatePassword(AppLocalizations localizations) {
    setState(() {
      if (_passwordController.text.isEmpty) {
        _passwordError = localizations.passwordRequired;
      } else if (!_isValidPassword(_passwordController.text)) {
        _passwordError = localizations.passwordMinLength;
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateConfirmPassword(AppLocalizations localizations) {
    setState(() {
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = localizations.passwordConfirmRequired;
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = localizations.passwordMismatch;
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  bool _isFormValid(AppLocalizations localizations) {
    _validateEmail(localizations);
    _validatePassword(localizations);
    if (!_isLoginMode) {
      _validateConfirmPassword(localizations);
      return _emailError == null &&
          _passwordError == null &&
          _confirmPasswordError == null;
    }
    return _emailError == null && _passwordError == null;
  }

  void _toggleMode() {
    _animationController.reset();
    setState(() {
      _isLoginMode = !_isLoginMode;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
    _animationController.forward();
  }

  Future<void> _handleSubmit(BuildContext context, AppLocalizations localizations) async {
    if (!_isFormValid(localizations)) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    if (_isLoginMode) {
      // Login logic
      final success = await authProvider.loginWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      if (success && mounted && context.mounted) {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RequestsScreen()),
        );
      }
    } else {
      // Sign up logic
      final success = await authProvider.registerWithEmail(
        _emailController.text,
        _passwordController.text,
        _emailController.text.split('@')[0],
      );
      if (success && mounted && context.mounted) {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RequestsScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Settings Bar (Language & Theme)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language Selector
                  _buildLanguageSelector(context, localeProvider, localizations),
                  // Theme Selector
                  _buildThemeSelector(context, themeProvider, localizations),
                ],
              ),
              const SizedBox(height: 32),

              // Header
              Text(
                'CityVoice',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isLoginMode ? localizations.welcome : localizations.register,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 40),

              // Form with fade animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email Field
                    TextField(
                      controller: _emailController,
                      onChanged: (_) {
                        setState(() => _emailError = null);
                      },
                      onSubmitted: (_) => _validateEmail(localizations),
                      decoration: InputDecoration(
                        labelText: localizations.email,
                        hintText: localizations.enterEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                        errorText: _emailError,
                        errorMaxLines: 2,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextField(
                      controller: _passwordController,
                      onChanged: (_) {
                        setState(() => _passwordError = null);
                      },
                      onSubmitted: (_) => _validatePassword(localizations),
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: localizations.password,
                        hintText: localizations.enterPassword,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() => _showPassword = !_showPassword);
                          },
                        ),
                        errorText: _passwordError,
                        errorMaxLines: 2,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),

                    // Forgot Password Link (Login mode only)
                    if (_isLoginMode) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            localizations.forgotPassword,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 16),
                      // Confirm Password Field (Sign Up mode only)
                      TextField(
                        controller: _confirmPasswordController,
                        onChanged: (_) {
                          setState(() => _confirmPasswordError = null);
                        },
                        onSubmitted: (_) => _validateConfirmPassword(localizations),
                        obscureText: !_showConfirmPassword,
                        decoration: InputDecoration(
                          labelText: localizations.confirmPassword,
                          hintText: localizations.enterPassword,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() =>
                                  _showConfirmPassword = !_showConfirmPassword);
                            },
                          ),
                          errorText: _confirmPasswordError,
                          errorMaxLines: 2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],

                    // Error message from auth provider
                    if (authProvider.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.error.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        child: Text(
                          authProvider.errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Primary Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () => _handleSubmit(context, localizations),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isLoginMode
                                    ? localizations.login
                                    : localizations.register,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Toggle Mode Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLoginMode
                              ? localizations.noAccount
                              : localizations.haveAccount,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: _toggleMode,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            _isLoginMode
                                ? localizations.signUp
                                : localizations.login,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    LocaleProvider localeProvider,
    AppLocalizations localizations,
  ) {
    return PopupMenuButton<String>(
      initialValue: localeProvider.locale.languageCode,
      onSelected: (String languageCode) async {
        await localeProvider.setLocale(Locale(languageCode));
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'en',
          child: Text(localizations.english),
        ),
        PopupMenuItem(
          value: 'ru',
          child: Text(localizations.russian),
        ),
        PopupMenuItem(
          value: 'kk',
          child: Text(localizations.kazakh),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              localeProvider.locale.languageCode.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    return PopupMenuButton<ThemeMode>(
      initialValue: themeProvider.themeMode,
      onSelected: (ThemeMode mode) async {
        await themeProvider.setThemeMode(mode);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            children: [
              const Icon(Icons.brightness_auto),
              const SizedBox(width: 8),
              Text(localizations.auto),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            children: [
              const Icon(Icons.brightness_7),
              const SizedBox(width: 8),
              Text(localizations.light),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            children: [
              const Icon(Icons.brightness_4),
              const SizedBox(width: 8),
              Text(localizations.dark),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getThemeIcon(themeProvider.themeMode),
          color: Theme.of(context).colorScheme.onSurface,
          size: 24,
        ),
      ),
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.brightness_7;
      case ThemeMode.dark:
        return Icons.brightness_4;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}

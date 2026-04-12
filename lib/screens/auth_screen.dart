import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_voice_app/providers/auth_provider.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/widgets/phone_input_field.dart';
import 'package:city_voice_app/widgets/language_selector.dart';

/// Main authentication screen with tabbed interface for email and phone authentication.
/// 
/// Provides:
/// - Toggle between Login and Sign Up modes
/// - Email and Phone authentication tabs
/// - Real-time validation with user feedback
/// - Smooth animations and transitions
/// - Localized error messages
/// - SMS verification flow for phone auth
class AuthScreen extends StatefulWidget {
  final int initialTab;

  const AuthScreen({super.key, this.initialTab = 0});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoginMode = true;

  @override
  void initState() {
    super.initState();
    // Only initialize TabController if needed (for backward compatibility)
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final selectedMethod = authProvider.selectedAuthMethod;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLoginMode ? localizations.login : localizations.signUp,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: const LanguageSelector(isDense: true),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with mode description
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(10),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          
          // Auth form - show only based on selected method
          Expanded(
            child: selectedMethod == 'email'
                ? _EmailAuthTab(
                    isLoginMode: _isLoginMode,
                    onToggleMode: () => setState(() => _isLoginMode = !_isLoginMode),
                  )
                : selectedMethod == 'phone'
                    ? _PhoneAuthTab(
                        isLoginMode: _isLoginMode,
                        onToggleMode: () => setState(() => _isLoginMode = !_isLoginMode),
                      )
                    : Center(
                        child: Text(AppLocalizations.of(context)!.selectAuthenticationMethod),
                      ),
          ),
        ],
      ),
    );
  }
}

class _EmailAuthTab extends StatefulWidget {
  final bool isLoginMode;
  final VoidCallback onToggleMode;

  const _EmailAuthTab({
    required this.isLoginMode,
    required this.onToggleMode,
  });

  @override
  State<_EmailAuthTab> createState() => _EmailAuthTabState();
}

class _EmailAuthTabState extends State<_EmailAuthTab> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            onChanged: (_) => authProvider.clearError(),
            decoration: InputDecoration(
              labelText: localizations.email,
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          if (!widget.isLoginMode)
            Column(
              children: [
                TextField(
                  controller: _firstNameController,
                  onChanged: (_) => authProvider.clearError(),
                  decoration: InputDecoration(
                    labelText: localizations.firstName,
                    hintText: localizations.enterFirstName,
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  onChanged: (_) => authProvider.clearError(),
                  decoration: InputDecoration(
                    labelText: localizations.lastName,
                    hintText: localizations.enterLastName,
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          TextField(
            controller: _passwordController,
            onChanged: (_) => authProvider.clearError(),
            decoration: InputDecoration(
              labelText: localizations.password,
              hintText: localizations.enterPassword,
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          if (authProvider.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                authProvider.errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      // Dismiss keyboard
                      FocusScope.of(context).unfocus();

                      // Validate inputs
                      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                        authProvider.setError('Email and password are required');
                        return;
                      }

                      if (!widget.isLoginMode && 
                          (_firstNameController.text.isEmpty || 
                           _lastNameController.text.isEmpty)) {
                        authProvider.setError('First name and last name are required');
                        return;
                      }

                      final success = widget.isLoginMode
                          ? await authProvider.loginWithEmail(
                              _emailController.text,
                              _passwordController.text,
                            )
                          : await authProvider.registerWithEmail(
                              _emailController.text,
                              _passwordController.text,
                              '${_firstNameController.text} ${_lastNameController.text}',
                            );

                      if (success) {
                        if (mounted) {
                          // Navigate to main app (RequestsScreen)
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/requests',
                            (route) => false,
                          );
                        }
                      }
                    },
              child: authProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.isLoginMode ? localizations.login : localizations.register,
                    ),
            ),
          ),
          const SizedBox(height: 24),
          if (widget.isLoginMode) ...[
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _ForgotPasswordDialog(
                    emailController: _emailController,
                  ),
                );
              },
              child: Text(localizations.forgotPassword),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha(50),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isLoginMode
                      ? localizations.noAccount
                      : localizations.haveAccount,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: widget.onToggleMode,
                  child: Text(
                    widget.isLoginMode
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
          ),
        ],
      ),
    );
  }
}

class _PhoneAuthTab extends StatefulWidget {
  final bool isLoginMode;
  final VoidCallback onToggleMode;

  const _PhoneAuthTab({
    required this.isLoginMode,
    required this.onToggleMode,
  });

  @override
  State<_PhoneAuthTab> createState() => _PhoneAuthTabState();
}

class _PhoneAuthTabState extends State<_PhoneAuthTab> {
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _showVerification = false;
  final _codeController = TextEditingController();
  bool _isPhoneValid = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();

    if (_showVerification) {
      return _PhoneVerificationWidget(
        phone: _phoneController.text,
        isLoginMode: widget.isLoginMode,
        codeController: _codeController,
        onBack: () {
          setState(() => _showVerification = false);
          authProvider.clearVerificationState();
        },
        onNameNeeded: !widget.isLoginMode 
            ? '${_firstNameController.text} ${_lastNameController.text}' 
            : null,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Phone input field with country code selector
          PhoneInputField(
            controller: _phoneController,
            labelText: localizations.phoneNumber,
            hintText: localizations.enterPhone,
            onValidationChanged: (validation) {
              setState(() {
                _isPhoneValid = validation['valid'] as bool;
              });
              authProvider.clearError();
            },
            initialCountryCode: '+1',
          ),
          const SizedBox(height: 24),
          
          // Name fields for registration
          if (!widget.isLoginMode)
            Column(
              children: [
                TextField(
                  controller: _firstNameController,
                  onChanged: (_) => authProvider.clearError(),
                  decoration: InputDecoration(
                    labelText: localizations.firstName,
                    hintText: localizations.enterFirstName,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  onChanged: (_) => authProvider.clearError(),
                  decoration: InputDecoration(
                    labelText: localizations.lastName,
                    hintText: localizations.enterLastName,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          
          // Error message display
          if (authProvider.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      authProvider.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          
          // Send code button (disabled until phone is valid)
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: (!authProvider.isLoading && _isPhoneValid)
                  ? () async {
                      FocusScope.of(context).unfocus();

                      if (!widget.isLoginMode && 
                          (_firstNameController.text.isEmpty || 
                           _lastNameController.text.isEmpty)) {
                        authProvider.setError('First name and last name are required');
                        return;
                      }

                      // Ensure phone has country code
                      final phone = _phoneController.text.startsWith('+')
                          ? _phoneController.text
                          : '+1${_phoneController.text}';

                      final success = widget.isLoginMode
                          ? await authProvider.loginWithPhone(phone)
                          : await authProvider.registerWithPhone(
                              phone,
                              '${_firstNameController.text} ${_lastNameController.text}',
                            );

                      if (success && mounted) {
                        authProvider.setPhoneForVerification(phone);
                        authProvider.startResendTimer();
                        setState(() => _showVerification = true);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                disabledBackgroundColor: Theme.of(context).disabledColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: authProvider.isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
                      ),
                    )
                  : Text(
                      localizations.sendCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Toggle between login/signup
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha(50),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isLoginMode
                      ? localizations.noAccount
                      : localizations.haveAccount,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: widget.onToggleMode,
                  child: Text(
                    widget.isLoginMode
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
          ),
        ],
      ),
    );
  }
}

class _PhoneVerificationWidget extends StatefulWidget {
  final String phone;
  final bool isLoginMode;
  final TextEditingController codeController;
  final VoidCallback onBack;
  final String? onNameNeeded;

  const _PhoneVerificationWidget({
    required this.phone,
    required this.isLoginMode,
    required this.codeController,
    required this.onBack,
    this.onNameNeeded,
  });

  @override
  State<_PhoneVerificationWidget> createState() =>
      _PhoneVerificationWidgetState();
}

class _PhoneVerificationWidgetState extends State<_PhoneVerificationWidget> {
  @override
  void initState() {
    super.initState();
    // Clear previous code and focus on input
    widget.codeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.mark_email_read,
                  size: 48,
                  color: theme.primaryColor,
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.verifyPhone,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Instruction text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.primaryColor.withAlpha(50)),
            ),
            child: Column(
              children: [
                Text(
                  localizations.smsSent,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.phone,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Verification code input
          TextField(
            controller: widget.codeController,
            onChanged: (value) => authProvider.clearError(),
            decoration: InputDecoration(
              labelText: localizations.verificationCode,
              hintText: localizations.enterCode,
              prefixIcon: const Icon(Icons.security),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              counterText: '',
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          
          // Error message
          if (authProvider.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.error.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      authProvider.errorMessage!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          
          // Verify button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: (authProvider.isLoading ||
                      widget.codeController.text.length != 6)
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      final success = widget.isLoginMode
                          ? await authProvider.verifyPhoneCodeLogin(
                              widget.phone,
                              widget.codeController.text,
                            )
                          : await authProvider.verifyPhoneCode(
                              widget.phone,
                              widget.codeController.text,
                              widget.onNameNeeded ?? '',
                            );

                      if (success && mounted) {
                        // Navigate to main app (RequestsScreen)
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/requests',
                          (route) => false,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                disabledBackgroundColor: Theme.of(context).disabledColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: authProvider.isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                      ),
                    )
                  : Text(
                      localizations.verify,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Resend code section
          if (authProvider.resendCountdown > 0)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    '${localizations.resendCodeIn} ${authProvider.resendCountdown} ${localizations.seconds}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 1 - (authProvider.resendCountdown / 60),
                    minHeight: 4,
                  ),
                ],
              ),
            )
          else
            TextButton.icon(
              onPressed: authProvider.canResendCode
                  ? () {
                      if (widget.isLoginMode) {
                        authProvider.loginWithPhone(widget.phone);
                      } else {
                        authProvider.registerWithPhone(
                          widget.phone,
                          widget.onNameNeeded ?? '',
                        );
                      }
                      authProvider.startResendTimer();
                    }
                  : null,
              icon: const Icon(Icons.refresh),
              label: Text(localizations.resendCode),
            ),
          const SizedBox(height: 16),
          
          // Back button
          TextButton(
            onPressed: widget.onBack,
            child: Text(
              localizations.cancel,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgotPasswordDialog extends StatefulWidget {
  final TextEditingController emailController;

  const _ForgotPasswordDialog({required this.emailController});

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();

    return AlertDialog(
      title: Text(localizations.resetPassword),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${localizations.passwordReset}\n\n${widget.emailController.text}',
            textAlign: TextAlign.center,
          ),
          if (authProvider.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                authProvider.errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
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
            await authProvider.resetPassword(widget.emailController.text);
            if (mounted) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            }
          },
          child: Text(localizations.sendCode),
        ),
      ],
    );
  }
}

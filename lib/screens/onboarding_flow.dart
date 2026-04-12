import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_voice_app/providers/auth_provider.dart';
import 'package:city_voice_app/providers/locale_provider.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 0; // 0: name, 1: registration, 2: language, 3: complete
  final _nameController = TextEditingController();
  String? _registeredEmail;
  String? _registeredPhone;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / 4,
              minHeight: 4,
            ),
            Expanded(
              child: IndexedStack(
                index: _currentStep,
                children: [
                  _NameStep(
                    nameController: _nameController,
                    onNext: () => _goToStep(1),
                  ),
                  _RegistrationStep(
                    name: _nameController.text,
                    onRegistrationComplete: (email, phone, method) {
                      setState(() {
                        _registeredEmail = email;
                        _registeredPhone = phone;
                      });
                      _goToStep(2);
                    },
                    onBack: () => _goToStep(0),
                  ),
                  _LanguageStep(
                    onNext: () => _goToStep(3),
                    onBack: () => _goToStep(1),
                  ),
                  _CompletionStep(
                    name: _nameController.text,
                    email: _registeredEmail,
                    phone: _registeredPhone,
                    onComplete: () {
                      final authProvider = context.read<AuthProvider>();
                      authProvider.markOnboardingComplete();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameStep extends StatefulWidget {
  final TextEditingController nameController;
  final VoidCallback onNext;

  const _NameStep({
    required this.nameController,
    required this.onNext,
  });

  @override
  State<_NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<_NameStep> {
  void _showLoginDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(localizations.login),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: localizations.email,
                hintText: localizations.enterEmail,
                prefixIcon: const Icon(Icons.email),
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
                hintText: localizations.enterPassword,
                prefixIcon: const Icon(Icons.lock),
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
              if (success && mounted) {
                // Mark onboarding as complete for existing users
                authProvider.markOnboardingComplete();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            },
            child: Text(localizations.login),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 48),
          Text(
            localizations.welcome,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.welcomeDescription,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Text(
            localizations.fullName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.nameController,
            decoration: InputDecoration(
              labelText: localizations.fullName,
              hintText: localizations.enterFullName,
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: widget.nameController.text.isEmpty
                ? null
                : widget.onNext,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(localizations.register),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _showLoginDialog,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(localizations.login),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationStep extends StatefulWidget {
  final String name;
  final Function(String?, String?, String) onRegistrationComplete;
  final VoidCallback onBack;

  const _RegistrationStep({
    required this.name,
    required this.onRegistrationComplete,
    required this.onBack,
  });

  @override
  State<_RegistrationStep> createState() => _RegistrationStepState();
}

class _RegistrationStepState extends State<_RegistrationStep>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            'Hello, ${widget.name}!',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            localizations.register,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: localizations.emailTab),
              Tab(text: localizations.phoneTab),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                _EmailRegistrationTab(
                  name: widget.name,
                  onComplete: (email) =>
                      widget.onRegistrationComplete(email, null, 'email'),
                ),
                _PhoneRegistrationTab(
                  name: widget.name,
                  onComplete: (phone) =>
                      widget.onRegistrationComplete(null, phone, 'phone'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: widget.onBack,
            child: Text(localizations.cancel),
          ),
        ],
      ),
    );
  }
}

class _EmailRegistrationTab extends StatefulWidget {
  final String name;
  final Function(String) onComplete;

  const _EmailRegistrationTab({
    required this.name,
    required this.onComplete,
  });

  @override
  State<_EmailRegistrationTab> createState() => _EmailRegistrationTabState();
}

class _EmailRegistrationTabState extends State<_EmailRegistrationTab> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: localizations.email,
              hintText: localizations.enterEmail,
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: localizations.password,
              hintText: localizations.enterPassword,
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
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
          ElevatedButton(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    final success = await authProvider.registerWithEmail(
                      _emailController.text,
                      _passwordController.text,
                      widget.name,
                    );
                    if (success) {
                      widget.onComplete(_emailController.text);
                    }
                  },
            child: authProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(localizations.register),
          ),
        ],
      ),
    );
  }
}

class _PhoneRegistrationTab extends StatefulWidget {
  final String name;
  final Function(String) onComplete;

  const _PhoneRegistrationTab({
    required this.name,
    required this.onComplete,
  });

  @override
  State<_PhoneRegistrationTab> createState() => _PhoneRegistrationTabState();
}

class _PhoneRegistrationTabState extends State<_PhoneRegistrationTab> {
  final _phoneController = TextEditingController();
  bool _showVerification = false;
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();

    if (_showVerification) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localizations.verifyPhone,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text('${localizations.smsSent}\n${_phoneController.text}'),
            const SizedBox(height: 24),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: localizations.verificationCode,
                hintText: localizations.enterCode,
                prefixIcon: const Icon(Icons.code),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
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
            ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      final success = await authProvider.verifyPhoneCode(
                        _phoneController.text,
                        _codeController.text,
                        widget.name,
                      );
                      if (success) {
                        widget.onComplete(_phoneController.text);
                      }
                    },
              child: authProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(localizations.verify),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _showVerification = false),
              child: Text(localizations.cancel),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: localizations.phoneNumber,
              hintText: localizations.enterPhone,
              prefixIcon: const Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
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
          ElevatedButton(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    final success = await authProvider.registerWithPhone(
                      _phoneController.text,
                      widget.name,
                    );
                    if (success) {
                      setState(() => _showVerification = true);
                    }
                  },
            child: authProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(localizations.sendCode),
          ),
        ],
      ),
    );
  }
}

class _LanguageStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _LanguageStep({
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 48),
          Text(
            localizations.language,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Choose your preferred language',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _LanguageOption(
            locale: const Locale('en'),
            label: 'English',
            isSelected: localeProvider.locale.languageCode == 'en',
            onTap: () => localeProvider.setLocale(const Locale('en')),
          ),
          const SizedBox(height: 16),
          _LanguageOption(
            locale: const Locale('ru'),
            label: 'Русский',
            isSelected: localeProvider.locale.languageCode == 'ru',
            onTap: () => localeProvider.setLocale(const Locale('ru')),
          ),
          const SizedBox(height: 16),
          _LanguageOption(
            locale: const Locale('kk'),
            label: 'Қазақша',
            isSelected: localeProvider.locale.languageCode == 'kk',
            onTap: () => localeProvider.setLocale(const Locale('kk')),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: onNext,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(localizations.login),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onBack,
            child: Text(localizations.cancel),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final Locale locale;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.locale,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withAlpha(25)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            // ignore: deprecated_member_use
            Radio<bool>(
              value: true,
              // ignore: deprecated_member_use
              groupValue: isSelected,
              // ignore: deprecated_member_use
              onChanged: (_) => onTap(),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionStep extends StatelessWidget {
  final String name;
  final String? email;
  final String? phone;
  final VoidCallback onComplete;

  const _CompletionStep({
    required this.name,
    this.email,
    this.phone,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 48),
          Icon(
            Icons.check_circle,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            localizations.registrationSuccess,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(label: 'Name', value: name),
                  if (email != null) _DetailRow(label: 'Email', value: email!),
                  if (phone != null) _DetailRow(label: 'Phone', value: phone!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: onComplete,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(AppLocalizations.of(context)!.enterApp),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

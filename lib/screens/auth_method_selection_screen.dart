import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/widgets/language_selector.dart';
import 'package:city_voice_app/providers/auth_provider.dart';

/// Auth Method Selection screen - users choose between phone and email authentication
/// Features smooth card animations and staggered entrance effects
class AuthMethodSelectionScreen extends StatefulWidget {
  const AuthMethodSelectionScreen({super.key});

  @override
  State<AuthMethodSelectionScreen> createState() =>
      _AuthMethodSelectionScreenState();
}

class _AuthMethodSelectionScreenState extends State<AuthMethodSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
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
      appBar: AppBar(
        title: Text(localizations.selectAuthMethod),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: LanguageSelector(isDense: true),
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Subtitle
                Text(
                  localizations.selectAuthMethodDescription,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Phone auth button with staggered animation
                SlideTransition(
                  position: Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero)
                      .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                        ),
                      ),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
                      ),
                    ),
                    child: _AuthMethodCard(
                      icon: Icons.phone,
                      title: localizations.continueWithPhone,
                      onTap: () {
                        context.read<AuthProvider>().setSelectedAuthMethod('phone');
                        Navigator.of(context).pushNamed(
                          '/auth',
                          arguments: 'phone',
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Email auth button with staggered animation
                SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero)
                      .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                        ),
                      ),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
                      ),
                    ),
                    child: _AuthMethodCard(
                      icon: Icons.email,
                      title: localizations.continueWithEmail,
                      onTap: () {
                        context.read<AuthProvider>().setSelectedAuthMethod('email');
                        Navigator.of(context).pushNamed(
                          '/auth',
                          arguments: 'email',
                        );
                      },
                    ),
                  ),
                ),

                const Spacer(),

                // Privacy/terms note
                FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
                    ),
                  ),
                  child: Text(
                    localizations.agreeToTerms,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withAlpha(150),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable authentication method card widget with smooth animations
class _AuthMethodCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AuthMethodCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<_AuthMethodCard> createState() => _AuthMethodCardState();
}

class _AuthMethodCardState extends State<_AuthMethodCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _tapController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _tapController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _tapController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isHovered
                  ? theme.colorScheme.primary.withAlpha(40)
                  : theme.colorScheme.primary.withAlpha(25),
              border: Border.all(
                color: theme.colorScheme.primary
                    .withAlpha(_isHovered ? 200 : 150),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(30),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                // Icon container with animated background
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: _isHovered ? 1.1 : 1.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(80),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Arrow icon with animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _isHovered ? 6.0 : 0.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, offset, child) {
                    return Transform.translate(
                      offset: Offset(offset, 0),
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

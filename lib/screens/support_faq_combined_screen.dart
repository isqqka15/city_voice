import 'package:flutter/material.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';
import 'package:city_voice_app/screens/faq_screen.dart';
import 'package:city_voice_app/screens/support_screen.dart';

/// Combined Support and FAQ screen with tabbed interface.
/// Shows FAQ in one tab and Support form in another tab.
/// Clean, minimalistic, and stylish Material 3 design.
class SupportAndFAQCombinedScreen extends StatefulWidget {
  const SupportAndFAQCombinedScreen({super.key});

  @override
  State<SupportAndFAQCombinedScreen> createState() =>
      _SupportAndFAQCombinedScreenState();
}

/// Using TickerProviderStateMixin instead of SingleTickerProviderStateMixin
/// to safely support multiple AnimationControllers on the screen
class _SupportAndFAQCombinedScreenState extends State<SupportAndFAQCombinedScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${l10n.support} & ${l10n.faq}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Column(
            children: [
              Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant.withAlpha(100),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: theme.colorScheme.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: theme.textTheme.labelLarge,
                tabs: [
                  Tab(
                    height: 52,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.help_outline, size: 20),
                        const SizedBox(width: 8),
                        Text(l10n.faq),
                      ],
                    ),
                  ),
                  Tab(
                    height: 52,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.support_agent, size: 20),
                        const SizedBox(width: 8),
                        Text(l10n.support),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            // FAQ Tab
            _buildFAQTab(context),
            // Support Tab
            _buildSupportTab(context),
          ],
        ),
      ),
    );
  }

  /// Builds the FAQ tab content
  Widget _buildFAQTab(BuildContext context) {
    return const FAQScreen();
  }

  /// Builds the Support tab content
  Widget _buildSupportTab(BuildContext context) {
    return const SupportScreen();
  }
}

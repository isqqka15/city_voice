import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_voice_app/providers/locale_provider.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';

/// Минималистичный переключатель языков с плавными анимациями
/// - Иконка 🌐 + код языка (EN/RU/KZ)
/// - Открывает bottom-sheet для выбора
/// - Плавные переходы и анимации взаимодействия
/// - Чистый, компактный дизайн
class LanguageSelector extends StatefulWidget {
  final bool isDense;

  const LanguageSelector({
    super.key,
    this.isDense = true,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  String _codeForLocale(Locale locale) {
    if (locale == const Locale('ru', '')) return 'RU';
    if (locale == const Locale('kk', '')) return 'KZ';
    return 'EN';
  }

  void _openSelector(BuildContext context, LocaleProvider localeProvider,
      AppLocalizations localizations) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(top: 8, bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                _buildOption(
                  context,
                  label: localizations.englishNative,
                  value: const Locale('en', ''),
                  selected: localeProvider.locale == const Locale('en', ''),
                  onTap: (v) => _selectLocale(localeProvider, v),
                ),
                _buildOption(
                  context,
                  label: localizations.russianNative,
                  value: const Locale('ru', ''),
                  selected: localeProvider.locale == const Locale('ru', ''),
                  onTap: (v) => _selectLocale(localeProvider, v),
                ),
                _buildOption(
                  context,
                  label: localizations.kazakhNative,
                  value: const Locale('kk', ''),
                  selected: localeProvider.locale == const Locale('kk', ''),
                  onTap: (v) => _selectLocale(localeProvider, v),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context,
      {required String label,
      required Locale value,
      required bool selected,
      required ValueChanged<Locale> onTap}) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
      child: ListTile(
        title: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing: selected
            ? Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
              )
            : null,
        onTap: () {
          Navigator.of(context).pop();
          onTap(value);
        },
      ),
    );
  }

  void _selectLocale(LocaleProvider provider, Locale locale) {
    provider.setLocale(locale);
  }

  void _onTapDown(TapDownDetails details) {
    _tapController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _tapController.reverse();
  }

  void _onTapCancel() {
    _tapController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final localizations = AppLocalizations.of(context)!;

    final languageCode = _codeForLocale(localeProvider.locale);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          _tapController.reverse();
          _openSelector(context, localeProvider, localizations);
        },
        child: Material(
          color: Colors.transparent,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: theme.colorScheme.primary.withAlpha(25),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(100),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(20),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.language_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                    weight: 500,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    languageCode,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

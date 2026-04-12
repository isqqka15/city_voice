import 'package:flutter/material.dart';
import 'package:city_voice_app/l10n/app_localizations.dart';

/// Extension to easily access localizations from any BuildContext
extension LocalizationsExtension on BuildContext {
  AppLocalizations get l10n {
    return AppLocalizations.of(this)!;
  }
}

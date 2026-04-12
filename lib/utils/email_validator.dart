import 'package:city_voice_app/l10n/app_localizations.dart';

/// Email validation utility for Gmail-only validation
class EmailValidator {
  // Gmail domain variations
  static const List<String> gmailDomains = [
    'gmail.com',
    'googlemail.com',
  ];

  /// Validate if email is not empty
  static String? validateNotEmpty(String email, AppLocalizations localizations) {
    if (email.trim().isEmpty) {
      return localizations.emailRequired;
    }
    return null;
  }

  /// Validate if email has valid format
  static String? validateFormat(String email, AppLocalizations localizations) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );
    
    if (!emailRegex.hasMatch(email)) {
      return localizations.emailInvalid;
    }
    return null;
  }

  /// Validate if email is Gmail-only
  static String? validateGmailOnly(String email, AppLocalizations localizations) {
    final domain = email.split('@').last.toLowerCase();
    
    if (!gmailDomains.contains(domain)) {
      return localizations.emailGmailOnly;
    }
    return null;
  }

  /// Full email validation (empty, format, Gmail)
  static String? validate(String email, AppLocalizations localizations) {
    // Check if empty
    final emptyError = validateNotEmpty(email, localizations);
    if (emptyError != null) return emptyError;

    // Check format
    final formatError = validateFormat(email, localizations);
    if (formatError != null) return formatError;

    // Check Gmail
    final gmailError = validateGmailOnly(email, localizations);
    if (gmailError != null) return gmailError;

    return null;
  }

  /// Check if email is valid (used for button enabling)
  static bool isValid(String email, AppLocalizations localizations) {
    return validate(email, localizations) == null;
  }
}

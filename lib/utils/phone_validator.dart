import 'package:city_voice_app/l10n/app_localizations.dart';

/// Phone number validation and formatting utility
/// Supports international phone formats with country codes
class PhoneValidator {
  // Common country codes with their phone number length ranges
  static const Map<String, Map<String, dynamic>> countryCodes = {
    '+1': {'name': 'US/Canada', 'minLength': 10, 'maxLength': 10},
    '+7': {'name': 'Russia/Kazakhstan', 'minLength': 10, 'maxLength': 11},
    '+44': {'name': 'UK', 'minLength': 10, 'maxLength': 11},
    '+49': {'name': 'Germany', 'minLength': 9, 'maxLength': 11},
    '+33': {'name': 'France', 'minLength': 9, 'maxLength': 9},
    '+81': {'name': 'Japan', 'minLength': 10, 'maxLength': 10},
    '+86': {'name': 'China', 'minLength': 11, 'maxLength': 11},
    '+91': {'name': 'India', 'minLength': 10, 'maxLength': 10},
  };

  /// Validate if phone is not empty
  static String? validateNotEmpty(String phone, AppLocalizations localizations) {
    if (phone.trim().isEmpty) {
      return localizations.phoneRequired;
    }
    return null;
  }

  /// Extract country code and number from phone string
  static Map<String, String> parsePhoneNumber(String phone) {
    final trimmed = phone.replaceAll(RegExp(r'[\s\-\(\)\.]+'), '');
    
    String countryCode = '+1'; // Default
    String number = trimmed;

    // Try to extract country code
    for (final code in countryCodes.keys) {
      if (trimmed.startsWith(code)) {
        countryCode = code;
        number = trimmed.substring(code.length);
        break;
      }
    }

    // If no country code but starts with +, extract it
    if (trimmed.startsWith('+') && !countryCodes.containsKey(countryCode)) {
      final match = RegExp(r'^\+(\d{1,3})(.*)$').firstMatch(trimmed);
      if (match != null) {
        countryCode = '+${match.group(1)}';
        number = match.group(2) ?? '';
      }
    }

    return {
      'countryCode': countryCode,
      'number': number.replaceAll(RegExp(r'[^\d]'), ''),
    };
  }

  /// Format phone number for display
  static String formatPhoneNumber(String phone) {
    final parsed = parsePhoneNumber(phone);
    final code = parsed['countryCode'] ?? '+1';
    final number = parsed['number'] ?? '';

    if (number.isEmpty) return code;
    
    // Format based on country code
    if (code == '+1' && number.length == 10) {
      return '$code (${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6)}';
    } else if (code == '+7' && number.length >= 10) {
      return '$code ${number.substring(0, 3)} ${number.substring(3, 6)}-${number.substring(6, 8)}-${number.substring(8)}';
    }
    
    return '$code $number';
  }

  /// Validate phone number format and length
  static String? validateFormat(String phone, AppLocalizations localizations) {
    if (!phone.contains('+')) {
      return localizations.phoneInvalid;
    }

    final parsed = parsePhoneNumber(phone);
    final code = parsed['countryCode']!;
    final number = parsed['number']!;

    if (number.isEmpty) {
      return localizations.phoneInvalid;
    }

    // Validate length based on country code
    if (countryCodes.containsKey(code)) {
      final minLen = countryCodes[code]!['minLength'] as int;
      final maxLen = countryCodes[code]!['maxLength'] as int;

      if (number.length < minLen || number.length > maxLen) {
        return localizations.phoneInvalid;
      }
    } else {
      // Generic validation: must have at least 7-15 digits
      if (number.length < 7 || number.length > 15) {
        return localizations.phoneInvalid;
      }
    }

    return null;
  }

  /// Full phone validation (empty, format)
  static Map<String, dynamic> validate(String phone) {
    // Check if empty
    final emptyError = validateNotEmpty(phone, _DummyLocalizations());
    if (emptyError != null) {
      return {
        'valid': false,
        'message': emptyError,
      };
    }

    // Check format
    final formatError = validateFormat(phone, _DummyLocalizations());
    if (formatError != null) {
      return {
        'valid': false,
        'message': formatError,
      };
    }

    return {
      'valid': true,
      'message': 'Phone number is valid',
    };
  }

  /// Check if phone number is valid for submission
  static bool isValid(String phone) {
    final result = validate(phone);
    return result['valid'] as bool;
  }

  /// Get country code from phone
  static String getCountryCode(String phone) {
    return parsePhoneNumber(phone)['countryCode'] ?? '+1';
  }

  /// Get raw phone number without country code
  static String getRawNumber(String phone) {
    return parsePhoneNumber(phone)['number'] ?? '';
  }
}

/// Dummy localizations for fallback
class _DummyLocalizations extends AppLocalizations {
  _DummyLocalizations() : super('en');

  @override
  String get account => 'Account';
  @override
  String get addReport => 'Add Report';
  @override
  String get agreeToTerms => 'By continuing, you agree to our Terms of Service and Privacy Policy';
  @override
  String get appTitle => 'CityVoiceApp';
  @override
  String get apply => 'Apply';
  @override
  String get attachEvidence => 'Attach Evidence';
  @override
  String get auto => 'Auto';
  @override
  String get autoDetect => 'Auto-detect';
  @override
  String get cancel => 'Cancel';
  @override
  String get categories => 'Categories';
  @override
  String get category => 'Category';
  @override
  String get categoryGarbage => 'Garbage';
  @override
  String get categoryLighting => 'Lighting';
  @override
  String get categoryOther => 'Other';
  @override
  String get categoryPublicSafety => 'Public Safety';
  @override
  String get categoryRoads => 'Roads';
  @override
  String get categoryWaterSewage => 'Water & Sewage';
  @override
  String get change => 'Change';
  @override
  String get changePassword => 'Change Password';
  @override
  String get clearFilters => 'Clear filters';
  @override
  String get codeExpired => 'Verification code expired, please request a new one';
  @override
  String get codeNotMatch => 'Verification code does not match';
  @override
  String get confirmPassword => 'Confirm Password';
  @override
  String get continueWithEmail => 'Continue with Email';
  @override
  String get continueWithPhone => 'Continue with Phone Number';
  @override
  String get countryCode => 'Country Code';
  @override
  String get createdAt => 'Created At';
  @override
  String get currentPassword => 'Current Password';
  @override
  String get dark => 'Dark';
  @override
  String get description => 'Description';
  @override
  String get editReport => 'Edit Report';
  @override
  String get email => 'Email';
  @override
  String get emailExists => 'Email already registered';
  @override
  String get emailGmailOnly => 'Please use a Gmail address (gmail.com)';
  @override
  String get emailInvalid => 'Please enter a valid email address';
  @override
  String get emailRequired => 'Email is required';
  @override
  String get emailTab => 'Email';
  @override
  String get english => 'English';
  @override
  String get enterCode => 'Enter 6-digit code';
  @override
  String get enterEmail => 'Enter your email';
  @override
  String get enterFullName => 'Enter your full name';
  @override
  String get enterLocation => 'Enter Location';
  @override
  String get enterPassword => 'Enter your password';
  @override
  String get enterPhone => 'Enter your phone number';
  @override
  String get enterVerificationCode => 'Enter the 6-digit code sent to your phone';
  @override
  String get forgotPassword => 'Forgot password?';
  @override
  String get fromCamera => 'From Camera';
  @override
  String get fromGallery => 'From Gallery';
  @override
  String get fullName => 'Full Name';
  @override
  String get getStarted => 'Get Started';
  @override
  String get haveAccount => 'Already have an account?';
  @override
  String get incorrectPassword => 'Incorrect password';
  @override
  String get invalidPhoneFormat => 'Invalid phone number format';
  @override
  String get invalidVerificationCode => 'Invalid verification code';
  @override
  String get kazakh => 'Kazakh';
  @override
  String get language => 'Language';
  @override
  String get light => 'Light';
  @override
  String get loggedOutSuccessfully => 'Logged out successfully';
  @override
  String get login => 'Login';
  @override
  String get loginPrompt => 'Please log in to access all features';
  @override
  String get loginSuccess => 'Login successful';
  @override
  String get logout => 'Logout';
  @override
  String get manualEntry => 'Manual Entry';
  @override
  String get newPassword => 'New Password';
  @override
  String get newestFirst => 'Newest first';
  @override
  String get noAccount => 'Don\'t have an account?';
  @override
  String get noReports => 'No reports yet. Add one!';
  @override
  String get oldestFirst => 'Oldest first';
  @override
  String get password => 'Password';
  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';
  @override
  String get passwordConfirmRequired => 'Please confirm your password';
  @override
  String get passwordMinLength => 'Password must be at least 8 characters';
  @override
  String get passwordMismatch => 'Passwords do not match';
  @override
  String get passwordRequired => 'Password is required';
  @override
  String get passwordReset => 'Password reset link sent to your email';
  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
  @override
  String get phoneExists => 'Phone number already registered';
  @override
  String get phoneInvalid => 'Please enter a valid phone number (with country code, e.g., +1)';
  @override
  String get phoneNumber => 'Phone Number';
  @override
  String get phoneNumberTooLong => 'Phone number is too long';
  @override
  String get phoneNumberTooShort => 'Phone number is too short';
  @override
  String get phoneNumberWith => 'Phone number (with country code)';
  @override
  String get phoneRequired => 'Phone number is required';
  @override
  String get phoneTab => 'Phone';
  @override
  String get register => 'Register';
  @override
  String get registrationSuccess => 'Registration successful';
  @override
  String get resendCode => 'Resend Code';
  @override
  String get resendCodeIn => 'Resend code in';
  @override
  String get resetPassword => 'Reset Password';
  @override
  String get russian => 'Russian';
  @override
  String get save => 'Save';
  @override
  String get saveReport => 'Save Report';
  @override
  String get seconds => 'seconds';
  @override
  String get selectAuthMethod => 'Select authentication method';
  @override
  String get selectAuthMethodDescription => 'Choose your preferred way to sign in or create an account';
  @override
  String get selectCountry => 'Select Country';
  @override
  String get selectDate => 'Select Date';
  @override
  String get selectLocation => 'Select Location';
  @override
  String get sendCode => 'Send Code';
  @override
  String get settings => 'Settings';
  @override
  String get signUp => 'Sign Up';
  @override
  String get smsSent => 'SMS verification code sent to your phone';
  @override
  String get sortByDate => 'Sort by Date';
  @override
  String get status => 'Status';
  @override
  String get statusNotReviewed => 'Not Reviewed';
  @override
  String get statusUnderReview => 'Under Review';
  @override
  String get statusApproved => 'Approved';
  @override
  String get statusRejected => 'Rejected';
  @override
  String get reportApproved => 'This report has been approved and cannot be edited or deleted';
  @override
  String get reportRejected => 'This report has been rejected and cannot be edited or deleted';
  @override
  String get statusNew => 'New';
  @override
  String get statusSolved => 'Solved';
  @override
  String get system => 'System';
  @override
  String get theme => 'Theme';
  @override
  String get title => 'Title';
  @override
  String get updateReport => 'Update Report';
  @override
  String get verificationCode => 'Verification Code';
  @override
  String get verificationCodeSent => 'Verification code sent to your phone';
  @override
  String get verificationInProgress => 'Verifying your phone number...';
  @override
  String get verify => 'Verify';
  @override
  String get verifyEmail => 'Verify Email';
  @override
  String get verifyPhone => 'Verify Phone Number';
  @override
  String get welcome => 'Welcome';
  @override
  String get welcomeDescription => 'Report city issues and help improve your community';
  @override
  String get englishNative => 'English';
  @override
  String get russianNative => 'Русский';
  @override
  String get kazakhNative => 'Қазақша';
  @override
  String get firstName => 'First Name';
  @override
  String get lastName => 'Last Name';
  @override
  String get enterFirstName => 'Enter your first name';
  @override
  String get enterLastName => 'Enter your last name';
  @override
  String get drafts => 'Drafts';
  @override
  String get noDrafts => 'No draft reports yet';
  @override
  String get draftSavedSuccessfully => 'Draft saved successfully';
  @override
  String get deleteDraft => 'Delete Draft';
  @override
  String get deleteDraftConfirm => 'Are you sure you want to delete this draft?';
  @override
  String get saveDraft => 'Save Draft';
  @override
  String get discardDraft => 'Discard Draft';
  @override
  String get discardDraftConfirm => 'Discard this draft and return to reports?';
  @override
  String get draftProgress => 'Progress';
  @override
  String get editingDraft => 'Editing Draft';
  @override
  String get newReport => 'New Report';
  @override
  String get submitDraft => 'Submit Report';
  @override
  String get lastModified => 'Last modified';
  @override
  String get untitledDraft => 'Untitled Draft';
  @override
  String get delete => 'Delete';
  @override
  String get edit => 'Edit';
  @override
  String get reportCannotBeEdited => 'Submitted reports cannot be edited or deleted';
  @override
  String get reportLocked => 'This report has been submitted and is read-only';
  @override
  String get chooseMedia => 'Choose how to add media:';
  @override
  String get chooseLocation => 'Choose how to set your location:';
  @override
  String get ok => 'OK';
  @override
  String get locationPermissionDenied => 'Location permission denied. Please enable location services.';
  @override
  String get unableToGetLocation => 'Unable to get location. Please try manual entry.';
  @override
  String get errorSavingDraft => 'Error saving draft';
  @override
  String get selectAuthenticationMethod => 'Please select an authentication method';
  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';
  @override
  String get draftDeleted => 'Draft deleted';
  @override
  String get deleteReportConfirm => 'Are you sure you want to delete this report?';
  @override
  String get typeYourLocation => 'Type your location';
  @override
  String get enterApp => 'Enter App';
  @override
  String get cannotDeleteReport => 'Cannot delete: Report is';
  @override
  String get inProgress => 'In Progress';
  @override
  String get resolved => 'Resolved';
  @override
  String get support => 'Support';
  @override
  String get supportAndHelp => 'Support & Help';
  @override
  String get contactUs => 'Contact Us';
  @override
  String get sendMessage => 'Send Message';
  @override
  String get faq => 'FAQ';
  @override
  String get frequentlyAskedQuestions => 'Frequently Asked Questions';
  @override
  String get supportCategory => 'Category';
  @override
  String get supportCategoryBug => 'Bug Report';
  @override
  String get supportCategoryFeature => 'Feature Request';
  @override
  String get supportCategoryQuestion => 'Question';
  @override
  String get supportCategoryOther => 'Other';
  @override
  String get supportMessage => 'Message';
  @override
  String get supportAttachment => 'Attachment (Optional)';
  @override
  String get supportAttachScreenshot => 'Attach Screenshot';
  @override
  String get supportAttachPhoto => 'Attach Photo';
  @override
  String get supportNameAutoFilled => 'Name (auto-filled)';
  @override
  String get supportEmailAutoFilled => 'Email (auto-filled)';
  @override
  String get messageSentSuccessfully => 'Message sent successfully';
  @override
  String get errorSendingMessage => 'Error sending message. Please try again.';
  @override
  String get selectCategory => 'Select a category';
  @override
  String get messageRequired => 'Message is required';
  @override
  String get searchFAQ => 'Search FAQ';
  @override
  String get noFAQFound => 'No FAQ items found';
  @override
  String get expandAll => 'Expand All';
  @override
  String get collapseAll => 'Collapse All';
  @override
  String get faqItem1Q => 'How do I create a report?';
  @override
  String get faqItem1A => 'Tap the + button on the main screen to create a new report. Fill in the required information and submit.';
  @override
  String get faqItem2Q => 'How do I edit a report I already submitted?';
  @override
  String get faqItem2A => 'You can only edit draft reports. Once submitted, reports cannot be modified. Create a new report if needed.';
  @override
  String get faqItem3Q => 'What is a draft report?';
  @override
  String get faqItem3A => 'A draft is an unsaved report. You can save drafts and return to them later to complete or submit.';
  @override
  String get faqItem4Q => 'How do I save a draft?';
  @override
  String get faqItem4A => 'While creating a report, tap \'Save Draft\' to save your progress. You can access drafts from the drafts screen.';
  @override
  String get faqItem5Q => 'What categories can I choose from?';
  @override
  String get faqItem5A => 'Available categories include Lighting, Garbage, Roads, Water & Sewage, Public Safety, and Other.';
  @override
  String get faqItem6Q => 'How do I attach photos or evidence?';
  @override
  String get faqItem6A => 'Tap \'Attach Evidence\' and choose between taking a photo with your camera or selecting from your gallery.';
  @override
  String get faqItem7Q => 'How do I change my password?';
  @override
  String get faqItem7A => 'Go to Settings > Account > Change Password and enter your current and new passwords.';
  @override
  String get faqItem8Q => 'Can I use the app offline?';
  @override
  String get faqItem8A => 'Drafts are saved locally on your device, so you can work offline. Reports need internet to be submitted.';
  @override
  String get faqItem9Q => 'What languages are supported?';
  @override
  String get faqItem9A => 'The app supports English, Russian, and Kazakh. You can change the language in Settings.';
  @override
  String get faqItem10Q => 'How do I contact support?';
  @override
  String get faqItem10A => 'Use the Support section to send us a message directly with your question or issue.';
}

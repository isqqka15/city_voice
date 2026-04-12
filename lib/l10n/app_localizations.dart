import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CityVoiceApp'**
  String get appTitle;

  /// No description provided for @addReport.
  ///
  /// In en, this message translates to:
  /// **'Add Report'**
  String get addReport;

  /// No description provided for @editReport.
  ///
  /// In en, this message translates to:
  /// **'Edit Report'**
  String get editReport;

  /// No description provided for @saveReport.
  ///
  /// In en, this message translates to:
  /// **'Save Report'**
  String get saveReport;

  /// No description provided for @updateReport.
  ///
  /// In en, this message translates to:
  /// **'Update Report'**
  String get updateReport;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @noReports.
  ///
  /// In en, this message translates to:
  /// **'No reports yet. Add one!'**
  String get noReports;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @kazakh.
  ///
  /// In en, this message translates to:
  /// **'Kazakh'**
  String get kazakh;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @loginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access all features'**
  String get loginPrompt;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @categoryLighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get categoryLighting;

  /// No description provided for @categoryGarbage.
  ///
  /// In en, this message translates to:
  /// **'Garbage'**
  String get categoryGarbage;

  /// No description provided for @categoryRoads.
  ///
  /// In en, this message translates to:
  /// **'Roads'**
  String get categoryRoads;

  /// No description provided for @categoryWaterSewage.
  ///
  /// In en, this message translates to:
  /// **'Water & Sewage'**
  String get categoryWaterSewage;

  /// No description provided for @categoryPublicSafety.
  ///
  /// In en, this message translates to:
  /// **'Public Safety'**
  String get categoryPublicSafety;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @statusNotReviewed.
  ///
  /// In en, this message translates to:
  /// **'Not Reviewed'**
  String get statusNotReviewed;

  /// No description provided for @statusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get statusUnderReview;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @reportApproved.
  ///
  /// In en, this message translates to:
  /// **'This report has been approved and cannot be edited or deleted'**
  String get reportApproved;

  /// No description provided for @reportRejected.
  ///
  /// In en, this message translates to:
  /// **'This report has been rejected and cannot be edited or deleted'**
  String get reportRejected;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @attachEvidence.
  ///
  /// In en, this message translates to:
  /// **'Attach Evidence'**
  String get attachEvidence;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @autoDetect.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect'**
  String get autoDetect;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter Location'**
  String get enterLocation;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'From Gallery'**
  String get fromGallery;

  /// No description provided for @fromCamera.
  ///
  /// In en, this message translates to:
  /// **'From Camera'**
  String get fromCamera;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @emailTab.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailTab;

  /// No description provided for @phoneTab.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneTab;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhone;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone Number'**
  String get verifyPhone;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @codeNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Verification code does not match'**
  String get codeNotMatch;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// No description provided for @emailExists.
  ///
  /// In en, this message translates to:
  /// **'Email already registered'**
  String get emailExists;

  /// No description provided for @phoneExists.
  ///
  /// In en, this message translates to:
  /// **'Phone number already registered'**
  String get phoneExists;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccess;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @smsSent.
  ///
  /// In en, this message translates to:
  /// **'SMS verification code sent to your phone'**
  String get smsSent;

  /// No description provided for @passwordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email'**
  String get passwordReset;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @emailGmailOnly.
  ///
  /// In en, this message translates to:
  /// **'Please use a Gmail address (gmail.com)'**
  String get emailGmailOnly;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get passwordConfirmRequired;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// No description provided for @statusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get statusNew;

  /// No description provided for @statusSolved.
  ///
  /// In en, this message translates to:
  /// **'Solved'**
  String get statusSolved;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get newestFirst;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get oldestFirst;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @loggedOutSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get loggedOutSuccessfully;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number (with country code, e.g., +1)'**
  String get phoneInvalid;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to your phone'**
  String get verificationCodeSent;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get resendCodeIn;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @codeExpired.
  ///
  /// In en, this message translates to:
  /// **'Verification code expired, please request a new one'**
  String get codeExpired;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your phone'**
  String get enterVerificationCode;

  /// No description provided for @invalidVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidVerificationCode;

  /// No description provided for @selectAuthMethod.
  ///
  /// In en, this message translates to:
  /// **'Select authentication method'**
  String get selectAuthMethod;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'Country Code'**
  String get countryCode;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @phoneNumberWith.
  ///
  /// In en, this message translates to:
  /// **'Phone number (with country code)'**
  String get phoneNumberWith;

  /// No description provided for @invalidPhoneFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format'**
  String get invalidPhoneFormat;

  /// No description provided for @phoneNumberTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too short'**
  String get phoneNumberTooShort;

  /// No description provided for @phoneNumberTooLong.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too long'**
  String get phoneNumberTooLong;

  /// No description provided for @verificationInProgress.
  ///
  /// In en, this message translates to:
  /// **'Verifying your phone number...'**
  String get verificationInProgress;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get enterCode;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Report city issues and help improve your community'**
  String get welcomeDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @selectAuthMethodDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred way to sign in or create an account'**
  String get selectAuthMethodDescription;

  /// No description provided for @continueWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with Phone Number'**
  String get continueWithPhone;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continueWithEmail;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy'**
  String get agreeToTerms;

  /// No description provided for @englishNative.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishNative;

  /// No description provided for @russianNative.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russianNative;

  /// No description provided for @kazakhNative.
  ///
  /// In en, this message translates to:
  /// **'Қазақша'**
  String get kazakhNative;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// No description provided for @drafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get drafts;

  /// No description provided for @noDrafts.
  ///
  /// In en, this message translates to:
  /// **'No draft reports yet'**
  String get noDrafts;

  /// No description provided for @draftSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Draft saved successfully'**
  String get draftSavedSuccessfully;

  /// No description provided for @deleteDraft.
  ///
  /// In en, this message translates to:
  /// **'Delete Draft'**
  String get deleteDraft;

  /// No description provided for @deleteDraftConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this draft?'**
  String get deleteDraftConfirm;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @discardDraft.
  ///
  /// In en, this message translates to:
  /// **'Discard Draft'**
  String get discardDraft;

  /// No description provided for @discardDraftConfirm.
  ///
  /// In en, this message translates to:
  /// **'Discard this draft and return to reports?'**
  String get discardDraftConfirm;

  /// No description provided for @draftProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get draftProgress;

  /// No description provided for @editingDraft.
  ///
  /// In en, this message translates to:
  /// **'Editing Draft'**
  String get editingDraft;

  /// No description provided for @newReport.
  ///
  /// In en, this message translates to:
  /// **'New Report'**
  String get newReport;

  /// No description provided for @submitDraft.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitDraft;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get lastModified;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @untitledDraft.
  ///
  /// In en, this message translates to:
  /// **'Untitled Draft'**
  String get untitledDraft;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @reportCannotBeEdited.
  ///
  /// In en, this message translates to:
  /// **'Submitted reports cannot be edited or deleted'**
  String get reportCannotBeEdited;

  /// No description provided for @reportLocked.
  ///
  /// In en, this message translates to:
  /// **'This report has been submitted and is read-only'**
  String get reportLocked;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @chooseMedia.
  ///
  /// In en, this message translates to:
  /// **'Choose how to add media:'**
  String get chooseMedia;

  /// No description provided for @chooseLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose how to set your location:'**
  String get chooseLocation;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Please enable location services.'**
  String get locationPermissionDenied;

  /// No description provided for @unableToGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to get location. Please try manual entry.'**
  String get unableToGetLocation;

  /// No description provided for @errorSavingDraft.
  ///
  /// In en, this message translates to:
  /// **'Error saving draft'**
  String get errorSavingDraft;

  /// No description provided for @selectAuthenticationMethod.
  ///
  /// In en, this message translates to:
  /// **'Please select an authentication method'**
  String get selectAuthenticationMethod;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// No description provided for @draftDeleted.
  ///
  /// In en, this message translates to:
  /// **'Draft deleted'**
  String get draftDeleted;

  /// No description provided for @deleteReportConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this report?'**
  String get deleteReportConfirm;

  /// No description provided for @typeYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Type your location'**
  String get typeYourLocation;

  /// No description provided for @enterApp.
  ///
  /// In en, this message translates to:
  /// **'Enter App'**
  String get enterApp;

  /// No description provided for @cannotDeleteReport.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete: Report is'**
  String get cannotDeleteReport;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportAndHelp.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportAndHelp;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @supportCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get supportCategory;

  /// No description provided for @supportCategoryBug.
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get supportCategoryBug;

  /// No description provided for @supportCategoryFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get supportCategoryFeature;

  /// No description provided for @supportCategoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get supportCategoryQuestion;

  /// No description provided for @supportCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get supportCategoryOther;

  /// No description provided for @supportMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get supportMessage;

  /// No description provided for @supportAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment (Optional)'**
  String get supportAttachment;

  /// No description provided for @supportAttachScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Attach Screenshot'**
  String get supportAttachScreenshot;

  /// No description provided for @supportAttachPhoto.
  ///
  /// In en, this message translates to:
  /// **'Attach Photo'**
  String get supportAttachPhoto;

  /// No description provided for @supportNameAutoFilled.
  ///
  /// In en, this message translates to:
  /// **'Name (auto-filled)'**
  String get supportNameAutoFilled;

  /// No description provided for @supportEmailAutoFilled.
  ///
  /// In en, this message translates to:
  /// **'Email (auto-filled)'**
  String get supportEmailAutoFilled;

  /// No description provided for @messageSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully'**
  String get messageSentSuccessfully;

  /// No description provided for @errorSendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Error sending message. Please try again.'**
  String get errorSendingMessage;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategory;

  /// No description provided for @messageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get messageRequired;

  /// No description provided for @searchFAQ.
  ///
  /// In en, this message translates to:
  /// **'Search FAQ'**
  String get searchFAQ;

  /// No description provided for @noFAQFound.
  ///
  /// In en, this message translates to:
  /// **'No FAQ items found'**
  String get noFAQFound;

  /// No description provided for @expandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand All'**
  String get expandAll;

  /// No description provided for @collapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse All'**
  String get collapseAll;

  /// No description provided for @faqItem1Q.
  ///
  /// In en, this message translates to:
  /// **'How to create a new city report?'**
  String get faqItem1Q;

  /// No description provided for @faqItem1A.
  ///
  /// In en, this message translates to:
  /// **'Go to \"Create Report\", fill all required fields, optionally attach photos/videos, choose a category, and tap \"Save as Report\" or \"Save as Draft\".'**
  String get faqItem1A;

  /// No description provided for @faqItem2Q.
  ///
  /// In en, this message translates to:
  /// **'Can I edit submitted reports?'**
  String get faqItem2Q;

  /// No description provided for @faqItem2A.
  ///
  /// In en, this message translates to:
  /// **'No, submitted reports cannot be edited. Only drafts can be edited before submission.'**
  String get faqItem2A;

  /// No description provided for @faqItem3Q.
  ///
  /// In en, this message translates to:
  /// **'What if my report is rejected?'**
  String get faqItem3Q;

  /// No description provided for @faqItem3A.
  ///
  /// In en, this message translates to:
  /// **'Rejected reports cannot be changed or deleted. You can create a new report with correct information.'**
  String get faqItem3A;

  /// No description provided for @faqItem4Q.
  ///
  /// In en, this message translates to:
  /// **'How to delete a draft?'**
  String get faqItem4Q;

  /// No description provided for @faqItem4A.
  ///
  /// In en, this message translates to:
  /// **'On the Drafts page, select the draft and tap \"Delete\". Drafts can be deleted anytime before submission.'**
  String get faqItem4A;

  /// No description provided for @faqItem5Q.
  ///
  /// In en, this message translates to:
  /// **'Can I delete a report after submission?'**
  String get faqItem5Q;

  /// No description provided for @faqItem5A.
  ///
  /// In en, this message translates to:
  /// **'Reports can be deleted only if status is \"Not Reviewed\". Once \"Under Review\", \"Approved\", or \"Rejected\", deletion is disabled.'**
  String get faqItem5A;

  /// No description provided for @faqItem6Q.
  ///
  /// In en, this message translates to:
  /// **'How to check the status of my report?'**
  String get faqItem6Q;

  /// No description provided for @faqItem6A.
  ///
  /// In en, this message translates to:
  /// **'Each report has a status: \"Not Reviewed\", \"Under Review\", \"Approved\", or \"Rejected\". Status is visible in the report list and details.'**
  String get faqItem6A;

  /// No description provided for @faqItem7Q.
  ///
  /// In en, this message translates to:
  /// **'Can I attach photos or videos to a report?'**
  String get faqItem7Q;

  /// No description provided for @faqItem7A.
  ///
  /// In en, this message translates to:
  /// **'Yes, use the \"Attach Proof\" button when creating a report.'**
  String get faqItem7A;

  /// No description provided for @faqItem8Q.
  ///
  /// In en, this message translates to:
  /// **'How to change the app language?'**
  String get faqItem8Q;

  /// No description provided for @faqItem8A.
  ///
  /// In en, this message translates to:
  /// **'Use the language switcher 🌐 on the login/registration screen. Supported languages: EN, RU, KZ.'**
  String get faqItem8A;

  /// No description provided for @faqItem9Q.
  ///
  /// In en, this message translates to:
  /// **'What if I find a bug or app problem?'**
  String get faqItem9Q;

  /// No description provided for @faqItem9A.
  ///
  /// In en, this message translates to:
  /// **'Go to the Support section in the bottom-left corner and submit a message through the contact form.'**
  String get faqItem9A;

  /// No description provided for @faqItem10Q.
  ///
  /// In en, this message translates to:
  /// **'Can I use the app without registration?'**
  String get faqItem10Q;

  /// No description provided for @faqItem10A.
  ///
  /// In en, this message translates to:
  /// **'No, you must log in to create reports and manage drafts.'**
  String get faqItem10A;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

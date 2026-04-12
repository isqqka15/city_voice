import 'package:flutter/material.dart';
import 'dart:async';

// Simple user model for authentication
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String authMethod; // 'email' or 'phone'

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.authMethod,
  });
}

// Provider for managing authentication state.
// Handles email/phone registration, login, password reset, and phone verification.
// Features:
// - Email/Phone authentication flows
// - SMS verification with countdown timer
// - Real-time phone validation
// - Error message management
// - Onboarding state tracking
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasCompletedOnboarding = false;
  String? _selectedAuthMethod; // 'phone' or 'email'
  
  // Phone-specific state tracking
  String? _currentPhoneForVerification;
  int _resendCountdown = 0;
  Timer? _resendTimer;
  bool _canResendCode = false;
  
  // Store registered users (mock database)
  static final Map<String, Map<String, String>> _registeredUsers = {
    'test@example.com': {'password': 'test123', 'name': 'Test User', 'method': 'email'},
    '+1234567890': {'code': '123456', 'name': 'Phone User', 'method': 'phone'},
  };
  
  // Store verification codes (mock SMS)
  static final Map<String, String> _verificationCodes = {};

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  String? get selectedAuthMethod => _selectedAuthMethod;
  
  // Phone verification state
  String? get currentPhoneForVerification => _currentPhoneForVerification;
  int get resendCountdown => _resendCountdown;
  bool get canResendCode => _canResendCode;

  // Set selected auth method (phone or email)
  void setSelectedAuthMethod(String method) {
    _selectedAuthMethod = method;
    clearError();
    notifyListeners();
  }

  // Clear selected auth method
  void clearSelectedAuthMethod() {
    _selectedAuthMethod = null;
    notifyListeners();
  }

  // Set error message
  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Email Registration
  Future<bool> registerWithEmail(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Check if email already exists
    if (_registeredUsers.containsKey(email)) {
      _errorMessage = 'Email already registered';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Register user
    _registeredUsers[email] = {
      'password': password,
      'name': name,
      'method': 'email',
    };

    _currentUser = User(
      id: DateTime.now().toString(),
      name: name,
      email: email,
      authMethod: 'email',
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Email Login
  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Check if email exists
    if (!_registeredUsers.containsKey(email)) {
      _errorMessage = 'Email not found';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Check password
    final user = _registeredUsers[email]!;
    if (user['password'] != password) {
      _errorMessage = 'Incorrect password';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _currentUser = User(
      id: email,
      name: user['name']!,
      email: email,
      authMethod: 'email',
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Phone Registration - Send SMS code
  Future<bool> registerWithPhone(String phone, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Check if phone already exists
    if (_registeredUsers.containsKey(phone)) {
      _errorMessage = 'Phone number already registered';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Generate and store verification code
    final code = (DateTime.now().millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');
    _verificationCodes[phone] = code;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Phone Verification
  Future<bool> verifyPhoneCode(String phone, String code, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Check verification code
    if (_verificationCodes[phone] != code) {
      _errorMessage = 'Verification code does not match';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Register user
    _registeredUsers[phone] = {
      'name': name,
      'method': 'phone',
      'code': code,
    };
    
    _verificationCodes.remove(phone);

    _currentUser = User(
      id: DateTime.now().toString(),
      name: name,
      email: 'phone_$phone@app.local',
      phone: phone,
      authMethod: 'phone',
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Phone Login - Send SMS code
  Future<bool> loginWithPhone(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Check if phone exists
    if (!_registeredUsers.containsKey(phone)) {
      _errorMessage = 'Phone number not found';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Generate and store verification code
    final code = (DateTime.now().millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');
    _verificationCodes[phone] = code;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Verify Phone Code on Login
  Future<bool> verifyPhoneCodeLogin(String phone, String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Check verification code
    if (_verificationCodes[phone] != code) {
      _errorMessage = 'Verification code does not match';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final user = _registeredUsers[phone]!;
    _verificationCodes.remove(phone);

    _currentUser = User(
      id: phone,
      name: user['name']!,
      email: 'phone_$phone@app.local',
      phone: phone,
      authMethod: 'phone',
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Password Reset
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Check if email exists
    if (!_registeredUsers.containsKey(email)) {
      _errorMessage = 'Email not found';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // In a real app, send reset email
    // For now, just simulate it
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Mock logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    // Clear all user session data
    _currentUser = null;
    _errorMessage = null;
    _selectedAuthMethod = null;
    _currentPhoneForVerification = null;
    clearVerificationState();
    
    _isLoading = false;
    notifyListeners();
  }

  // Mark onboarding as complete
  void markOnboardingComplete() {
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  // Change password
  Future<bool> changePassword(
      String email, String currentPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Check if email exists
    if (!_registeredUsers.containsKey(email)) {
      _errorMessage = 'Email not found';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final user = _registeredUsers[email]!;
    // Check current password
    if (user['password'] != currentPassword) {
      _errorMessage = 'Incorrect password';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Update password
    user['password'] = newPassword;

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // ============= Phone Verification Timer Management =============

  /// Start resend code timer (60 seconds countdown)
  void startResendTimer() {
    _resendCountdown = 60;
    _canResendCode = false;
    notifyListeners();

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendCountdown--;
      notifyListeners();

      if (_resendCountdown <= 0) {
        _canResendCode = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  /// Stop and cancel the resend timer
  void stopResendTimer() {
    _resendTimer?.cancel();
    _resendCountdown = 0;
    _canResendCode = false;
    notifyListeners();
  }

  /// Set the phone currently being verified
  void setPhoneForVerification(String phone) {
    _currentPhoneForVerification = phone;
    notifyListeners();
  }

  /// Clear verification state
  void clearVerificationState() {
    _currentPhoneForVerification = null;
    stopResendTimer();
  }

  @override
  void dispose() {
    stopResendTimer();
    super.dispose();
  }
}
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userToken;
  Map<String, dynamic>? _userData;

  bool get isLoggedIn => _isLoggedIn;
  String? get userToken => _userToken;
  Map<String, dynamic>? get userData => _userData;

  // Static methods for convenience - RENAMED TO AVOID CONFLICTS
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey('first_time_completed');
  }

  static Future<bool> checkIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_token');
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      return {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+91 98765 43210',
      };
    }
    return null;
  }

  static Future<void> staticLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_data');
  }

  static Future<void> staticLogin(String identifier, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', 'mock_token');
    await prefs.setString('user_data', identifier);
  }

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time_completed', true);
  }

  // Social login methods
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'user': {
        'email': 'user@gmail.com',
        'name': 'John Doe',
      }
    };
  }

  static Future<Map<String, dynamic>> signInWithFacebook() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'user': {
        'email': 'user@facebook.com',
        'name': 'John Doe',
      }
    };
  }

  static Future<Map<String, dynamic>> signInWithApple() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'user': {
        'email': 'user@apple.com',
        'name': 'John Doe',
      }
    };
  }

  // Instance methods
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('user_token');
    _isLoggedIn = _userToken != null;

    if (_isLoggedIn) {
      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        _userData = {
          'email': userDataString,
          'name': 'John Doe',
        };
      }
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      _userToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      _isLoggedIn = true;
      _userData = {
        'id': '1',
        'email': email,
        'name': 'John Doe',
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', _userToken!);
      await prefs.setString('user_data', email);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return await login(email, password);
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginWithPhone(String phone, String otp) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      _userToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      _isLoggedIn = true;
      _userData = {
        'id': '1',
        'phone': phone,
        'name': 'John Doe',
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', _userToken!);
      await prefs.setString('user_data', phone);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendOTP(String phone) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userToken = null;
    _userData = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_data');

    notifyListeners();
  }

  Future<bool> socialLogin(String provider) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      _userToken = 'social_token_${DateTime.now().millisecondsSinceEpoch}';
      _isLoggedIn = true;
      _userData = {
        'id': '1',
        'provider': provider,
        'name': 'John Doe',
        'email': 'john.doe@example.com',
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', _userToken!);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}

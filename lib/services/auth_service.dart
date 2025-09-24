// lib/services/auth_service.dart (Updated with Remember Me)
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static const String _firstTimeKey = 'first_time';
  static const String _loggedInKey = 'logged_in';
  static const String _userTokenKey = 'user_token';
  static const String _rememberMeKey = 'remember_me';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';
  static const String _userNameKey = 'user_name';

  // Google Sign In instance
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Check if this is the first time the app is opened
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTimeKey) ?? true;
  }

  // Mark that the user has completed onboarding
  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, false);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_loggedInKey) ?? false;
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    return isLoggedIn && rememberMe;
  }

  // Login user with Remember Me option
  static Future<void> login(
    String token, {
    bool rememberMe = false,
    String? email,
    String? phone,
    String? name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setBool(_rememberMeKey, rememberMe);
    await prefs.setString(_userTokenKey, token);

    if (email != null) await prefs.setString(_userEmailKey, email);
    if (phone != null) await prefs.setString(_userPhoneKey, phone);
    if (name != null) await prefs.setString(_userNameKey, name);
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
    await prefs.setBool(_rememberMeKey, false);
    await prefs.remove(_userTokenKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userNameKey);

    // Sign out from social platforms
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }

  // Google Sign In
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      return {
        'token': googleAuth.accessToken,
        'email': googleUser.email,
        'name': googleUser.displayName,
        'photo': googleUser.photoUrl,
      };
    } catch (error) {
      print('Google Sign In Error: $error');
      return null;
    }
  }

  // Facebook Sign In
  static Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        return {
          'token': result.accessToken?.token,
          'email': userData['email'],
          'name': userData['name'],
          'photo': userData['picture']['data']['url'],
        };
      }
      return null;
    } catch (error) {
      print('Facebook Sign In Error: $error');
      return null;
    }
  }

  // Apple Sign In
  static Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return {
        'token': credential.identityToken,
        'email': credential.email,
        'name': '${credential.givenName ?? ''} ${credential.familyName ?? ''}',
      };
    } catch (error) {
      print('Apple Sign In Error: $error');
      return null;
    }
  }

  // Get user data
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(_userTokenKey),
      'email': prefs.getString(_userEmailKey),
      'phone': prefs.getString(_userPhoneKey),
      'name': prefs.getString(_userNameKey),
    };
  }
}

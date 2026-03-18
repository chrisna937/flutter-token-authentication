import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  // -------------------- SECURE STORAGE --------------------
  // Singleton instance of FlutterSecureStorage for storing sensitive data (like JWT tokens)
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // -------------------- SHARED PREFERENCES --------------------
  // SharedPreferences singleton instance for non-sensitive data (like user ID, email)
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences once
  static Future<void> initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // -------------------- TOKEN (Sensitive) --------------------
  
  /// Save JWT token securely
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'jwt_auth', value: token);
  }

  /// Read JWT token
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_auth');
  }

  /// Delete JWT token (used on logout)
  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'jwt_auth');
  }

  // -------------------- USER INFO (Non-sensitive) --------------------
  
  /// Save non-sensitive user info
  static Future<void> saveUserInfo({required String userId, required String email}) async {
    await initPrefs();
    await _prefs?.setString('userid', userId);
    await _prefs?.setString('email', email);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    await initPrefs();
    return _prefs?.getString('userid');
  }

  /// Get email
  static Future<String?> getEmail() async {
    await initPrefs();
    return _prefs?.getString('email');
  }

  /// Clear non-sensitive user info
  static Future<void> clearUserInfo() async {
    await initPrefs();
    await _prefs?.remove('userid');
    await _prefs?.remove('email');
  }

  // -------------------- LOGOUT --------------------
  
  /// Logout user
  static Future<void> logout() async {
    await deleteToken();
    await clearUserInfo();
  }
}


// class AuthService {
//   static const storage = FlutterSecureStorage();
  
//   //Non-sensitive info in SharedPreferences
//   static Future<String?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userid');
//   }

//     static Future<String?> getEmail() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('email');
//   }

//   //Sensitive token in secure storage
//   static Future<String?> getToken() async {
//    return await storage.read(key: 'jwt_auth');
    
//   }

//   static Future<void> logout() async {
//     await storage.delete(key: 'jwt_auth');

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('userid');
//     await prefs.remove('email');
//   }
// }

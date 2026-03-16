import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const storage = FlutterSecureStorage();
  
  //Non-sensitive info in SharedPreferences
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userid');
  }

    static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  //Sensitive token in secure storage
  static Future<String?> getToken() async {
   return await storage.read(key: 'jwt_auth');
    
  }

  static Future<void> logout() async {
    await storage.delete(key: 'jwt_auth');

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userid');
    await prefs.remove('email');
  }
}

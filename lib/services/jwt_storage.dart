import 'package:shared_preferences/shared_preferences.dart';

class JwtStorage {
  static Future<void> saveToken(String jwtToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', jwtToken);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}

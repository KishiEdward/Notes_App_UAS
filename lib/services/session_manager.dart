import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _lastLoginKey = 'last_login_time';
  static const String _loginMethodKey = 'login_method';

  Future<void> saveLoginSession(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginMethodKey, method);
    await prefs.setInt(_lastLoginKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<String?> getLoginMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loginMethodKey);
  }

  Future<DateTime?> getLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastLoginKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginMethodKey);
    await prefs.remove(_lastLoginKey);
  }

  Future<bool> hasActiveSession() async {
    final lastLogin = await getLastLoginTime();
    if (lastLogin == null) return false;
    
    final daysSinceLogin = DateTime.now().difference(lastLogin).inDays;
    return daysSinceLogin < 30;
  }
}

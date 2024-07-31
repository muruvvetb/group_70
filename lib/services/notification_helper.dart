import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {
  static const String _key = 'notifications';

  Future<void> addNotification(String notification) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notifications = prefs.getStringList(_key) ?? [];
    notifications.add(notification);
    await prefs.setStringList(_key, notifications);
  }

  Future<List<String>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

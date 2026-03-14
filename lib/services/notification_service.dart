import '../models/alert_model.dart';

/// Notification Service — In-App Notifications
///
/// Manages farming notifications shown within the app.
/// For push notifications, integrate Firebase Cloud Messaging (FCM).
///
/// FCM Setup (when ready):
///   1. Enable Cloud Messaging in Firebase Console
///   2. Add firebase_messaging package to pubspec.yaml
///   3. Request notification permissions
///   4. Handle background/foreground messages
///
/// For hackathon: Uses in-app notifications only.
class NotificationService {
  final List<FarmAlert> _notifications = [];

  List<FarmAlert> get notifications => List.unmodifiable(_notifications);

  /// Add a notification to the queue.
  void addNotification(FarmAlert alert) {
    _notifications.insert(0, alert);
  }

  /// Add multiple notifications.
  void addNotifications(List<FarmAlert> alerts) {
    _notifications.insertAll(0, alerts);
  }

  /// Get unread notification count.
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Mark a notification as read.
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].markAsRead();
    }
  }

  /// Mark all as read.
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].markAsRead();
      }
    }
  }

  /// Remove a notification.
  void remove(String id) {
    _notifications.removeWhere((n) => n.id == id);
  }

  /// Clear all notifications.
  void clearAll() {
    _notifications.clear();
  }
}

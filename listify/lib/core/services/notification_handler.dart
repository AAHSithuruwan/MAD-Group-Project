import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_notification_service.dart';

class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();

  factory NotificationHandler() => _instance;

  NotificationHandler._internal();

  StreamSubscription<QuerySnapshot>? _subscription;
  bool _isFirstSnapshot = true;

  void startListeningToNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;

    _isFirstSnapshot = true; // Reset flag when starting to listen

    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Notifications') // Capital "N"
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      if (_isFirstSnapshot) {
        _isFirstSnapshot = false;
        return; // Skip notifications for the first snapshot
      }
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data();
          if (data != null) {
            _handleIncomingNotification(data);
          }
        }
      }
    });
  }

  void _handleIncomingNotification(Map<String, dynamic> data) {
    final String title = data['title'] ?? 'New Notification';
    final String body = data['body'] ?? '';

    // Currently ignoring 'data' field
    LocalNotificationService.showNotification(
      title,
      body,
      data: null,
    );
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
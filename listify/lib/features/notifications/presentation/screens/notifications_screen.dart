import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listify/core/services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;
  const NotificationsScreen({super.key, required this.userId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<AppNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = NotificationService.getUserNotifications(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    // Use Listify's main green and background colors
    const Color primaryGreen = Color(0xFF1BA424);
    const Color background = Color(0xFFF0F4F0);

    return Scaffold(
      backgroundColor: background,
      body: FutureBuilder<List<AppNotification>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notifications found."));
          }
          final notifications = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final n = notifications[index];
              return GestureDetector(
                onTap: () {
                  context.push(
                    '/notification',
                    extra: {
                      'title': n.title,
                      'body': n.body,
                      'data': n.data,
                    },
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: n.isRead ? 1 : 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: n.isRead ? Colors.black54 : primaryGreen,
                            fontFamily: "Inter",
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${n.body}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontFamily: "Inter",
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${n.createdAt.toLocal()}".split(' ')[0],
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black38,
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
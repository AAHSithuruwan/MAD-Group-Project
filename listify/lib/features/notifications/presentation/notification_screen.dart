import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;

  const NotificationScreen({
    super.key,
    this.title,
    this.body,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Use Listify's main green and background colors
    const Color primaryGreen = Color(0xFF1BA424);
    const Color lightGreen = Color(0xFFE8F6E9);
    const Color background = Color(0xFFF0F4F0);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Notification",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: "Inter",
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryGreen.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: Text(
            //         title ?? "No Title",
            //         style: const TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //           color: primaryGreen,
            //           fontFamily: "Inter",
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Center(
              child: Text(
                title ?? "No Title",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                  fontFamily: "Inter",
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              body ?? "No message body.",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontFamily: "Inter",
              ),
            ),
            if (data != null && data!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                "Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notification"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title: ${title ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Body: ${body ?? ''}"),
              const SizedBox(height: 8),
              Text("Data: ${data != null ? data.toString() : ''}"),
            ],
          ),
        ),
      ),
    );
  }
}
// main.dart
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsAppState();
}

class _SettingsAppState extends State<Settings> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: SettingsScreen(
        onThemeChanged: _changeTheme,
        currentTheme: _themeMode,
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentTheme;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentTheme,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationOn = false;

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Theme"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text("Light Mode"),
                value: ThemeMode.light,
                groupValue: widget.currentTheme,
                onChanged: (value) {
                  widget.onThemeChanged(value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text("Dark Mode"),
                value: ThemeMode.dark,
                groupValue: widget.currentTheme,
                onChanged: (value) {
                  widget.onThemeChanged(value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text("System Default"),
                value: ThemeMode.system,
                groupValue: widget.currentTheme,
                onChanged: (value) {
                  widget.onThemeChanged(value!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Settings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_none,
            label: "Notification",
            value: isNotificationOn,
            onChanged: (val) => setState(() => isNotificationOn = val),
          ),
          _buildSimpleTile(Icons.person_outline, "Personal Info"),
          _buildSimpleTile(Icons.shield_outlined, "Security"),
          ListTile(
            leading:
                const Icon(Icons.brightness_6_outlined, color: Colors.black),
            title: const Text("Theme", style: TextStyle(fontSize: 16)),
            onTap: _showThemeDialog,
          ),
          _buildSimpleTile(Icons.star_border, "Rate App"),
          _buildSimpleTile(Icons.share_outlined, "Share App"),
          _buildSimpleTile(Icons.lock_outline, "Privacy Policy"),
          _buildSimpleTile(Icons.description_outlined, "Terms and Conditions"),
          _buildSimpleTile(Icons.article_outlined, "Cookies Policy"),
          _buildSimpleTile(Icons.mail_outline, "Contact"),
          _buildSimpleTile(Icons.feedback_outlined, "Feedback"),
          const Divider(),
          _buildSimpleTile(Icons.logout, "Logout"),
        ],
      ),
    );
  }

  Widget _buildSimpleTile(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: () {
        // Navigation logic placeholder
      },
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.black,
      ),
    );
  }
}

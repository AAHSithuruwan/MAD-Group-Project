// settings.dart
import 'package:flutter/material.dart';
import 'package:listify/common/widgets/custom_app_bar.dart';
import 'package:listify/features/menu/presentation/screens/menu_screen.dart';
import 'package:listify/features/profile/profile.dart'; // ✅ Make sure this import path is correct

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => SettingsAppState();
}

class SettingsAppState extends State<Settings> {
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
      appBar: CustomAppBar(title: "Settings", displayTitle: true),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_none,
            label: "Notification",
            value: isNotificationOn,
            onChanged: (val) => setState(() => isNotificationOn = val),
          ),
          _buildSimpleTile(
            Icons.person_outline,
            "Personal Info",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => profile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.brightness_6_outlined,
              color: Colors.black,
            ),
            title: const Text("Theme", style: TextStyle(fontSize: 16)),
            onTap: _showThemeDialog,
          ),

          const Divider(),
          _buildSimpleTile(Icons.logout, "Logout"),
        ],
      ),
    );
  }

  Widget _buildSimpleTile(IconData icon, String label, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: onTap ?? () {}, // Leave empty or handle other cases
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

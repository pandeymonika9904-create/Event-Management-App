import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('Notification Preferences'),
            subtitle: Text('Configure push notifications'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text('Language'),
            subtitle: Text('English'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Coming soon'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

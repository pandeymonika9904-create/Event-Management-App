import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
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
          ListTile(title: Text('How to book tickets')),
          ListTile(title: Text('Refund policy')),
          ListTile(
            title: Text('Contact support'),
            subtitle: Text('pandeymonika9904@gmail.com'),
          ),
          SizedBox(height: 24),
          Text(
            'Need more help? Send an email to pandeymonika9904@gmail.com or call +91 99999 99999.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

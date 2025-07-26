import 'package:flutter/material.dart';
import 'login.dart';

class PatientSettingsPage extends StatefulWidget {
  const PatientSettingsPage({super.key});

  @override
  State<PatientSettingsPage> createState() => _PatientSettingsPageState();
}

class _PatientSettingsPageState extends State<PatientSettingsPage> {
  bool notifications = true;
  bool darkMode = false;
  bool shareData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: SwitchListTile(
              value: notifications,
              onChanged: (v) => setState(() => notifications = v),
              title: const Text('Enable Notifications'),
              secondary: const Icon(Icons.notifications),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: SwitchListTile(
              value: darkMode,
              onChanged: (v) => setState(() => darkMode = v),
              title: const Text('Dark Mode'),
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: SwitchListTile(
              value: shareData,
              onChanged: (v) => setState(() => shareData = v),
              title: const Text('Share Data with Family'),
              secondary: const Icon(Icons.share),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

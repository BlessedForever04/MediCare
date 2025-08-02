import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  const PatientDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<PatientDrawer> createState() => _PatientDrawerState();
}

class _PatientDrawerState extends State<PatientDrawer> {
  String userName = "Loading..";

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        setState(() {
          userName = doc.data()?['first_name'] ?? 'User';
        });
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Patient', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          _buildTile(Icons.home, 'Home', 0),
          _buildTile(Icons.family_restroom, 'Family Connect', 1),
          _buildTile(Icons.person, 'Profile', 2),
          _buildTile(Icons.psychology, 'AI Assistant', 3),
          _buildTile(Icons.medication, 'Reminders', 4),
          const Divider(),
          _buildTile(Icons.settings, 'Settings', 5),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: widget.selectedIndex == index,
      selectedTileColor: Colors.blue.shade50,
      onTap: () => widget.onSelect(index),
    );
  }
}

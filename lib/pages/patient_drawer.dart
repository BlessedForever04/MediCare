import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onSelect;
  const PatientDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<PatientDrawer> createState() => _PatientDrawerState();
}

String userName = "Loading";

class _PatientDrawerState extends State<PatientDrawer> {
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        setState(() {
          userName = doc.data()?['first_name'] ?? 'Loading..';
        });
      }
    }
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
                SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Patient', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: widget.selectedIndex == 0,
            selectedTileColor: Colors.blue.shade50,
            onTap: () => widget.onSelect(0),
          ),
          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text('Family Connect'),
            selected: widget.selectedIndex == 1,
            selectedTileColor: Colors.blue.shade50,
            onTap: () => widget.onSelect(1),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            selected: widget.selectedIndex == 2,
            selectedTileColor: Colors.blue.shade50,
            onTap: () => widget.onSelect(2),
          ),
          ListTile(
            leading: const Icon(Icons.psychology),
            title: const Text('AI Assistant'),
            selected: widget.selectedIndex == 3,
            selectedTileColor: Colors.blue.shade50,
            onTap: () => widget.onSelect(3),
          ),
          ListTile(
            leading: const Icon(Icons.medication),
            title: const Text('Reminders'),
            selected: widget.selectedIndex == 4,
            selectedTileColor: Colors.blue.shade50,
            onTap: () => widget.onSelect(4),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: widget.selectedIndex == 5,
            selectedTileColor: Colors.blue.shade50,
            onTap: () => widget.onSelect(5),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onSelect;
  const DoctorDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<DoctorDrawer> createState() => _DoctorDrawerState();
}

String userName = "Loading";

class _DoctorDrawerState extends State<DoctorDrawer> {
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
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 12),
                Text(
                  "Dr. $userName",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Cardiologist', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: widget.selectedIndex == 0,
            onTap: () => widget.onSelect(0),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Patients'),
            selected: widget.selectedIndex == 1,
            onTap: () => widget.onSelect(1),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            selected: widget.selectedIndex == 2,
            onTap: () => widget.onSelect(2),
          ),
          ListTile(
            leading: const Icon(Icons.assistant),
            title: const Text('AI Assistant'),
            selected: widget.selectedIndex == 3,
            onTap: () => widget.onSelect(3),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: widget.selectedIndex == 4,
            onTap: () => widget.onSelect(4),
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

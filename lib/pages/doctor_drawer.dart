import 'package:flutter/material.dart';

class DoctorDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;
  const DoctorDrawer({Key? key, required this.selectedIndex, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, size: 40)),
                SizedBox(height: 12),
                Text('Dr. John Doe', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Cardiologist', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: selectedIndex == 0,
            onTap: () => onSelect(0),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Patients'),
            selected: selectedIndex == 1,
            onTap: () => onSelect(1),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            selected: selectedIndex == 2,
            onTap: () => onSelect(2),
          ),
          ListTile(
            leading: const Icon(Icons.assistant),
            title: const Text('AI Assistant'),
            selected: selectedIndex == 3,
            onTap: () => onSelect(3),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: selectedIndex == 4,
            onTap: () => onSelect(4),
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
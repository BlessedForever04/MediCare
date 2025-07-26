import 'package:flutter/material.dart';
import 'package:temp/pages/notification.dart';
import 'patient_home_page.dart';
import 'family_connect_page.dart';
import 'patient_profile_page.dart';
import 'patient_ai_assistant_page.dart';
import 'patient_medicine_reminder_page.dart';
import 'patient_settings_page.dart';
import 'patient_drawer.dart';
import 'login.dart';

int _currentIndex = 0;

class PatientMainNavigation extends StatefulWidget {
  const PatientMainNavigation({super.key});

  @override
  State<PatientMainNavigation> createState() => _PatientMainNavigationState();
}

class _PatientMainNavigationState extends State<PatientMainNavigation> {
  final List<Widget> _pages = [
    PatientHomePage(), // 0: Home
    FamilyConnectPage(), // 1: Family Connect
    PatientProfilePage(), // 2: Profile
    PatientAIAssistantPage(), // 3: AI Assistant
    PatientMedicineReminderPage(), // 4: Reminders
    PatientSettingsPage(), // 5: Settings
    login(),
  ];

  @override
  final List<String> _pageTitles = [
    'Patient Dashboard',
    'Family Connect',
    'Profile',
    'AI Health Assistant',
    'Reminders',
    'Settings',
    'logout',
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentIndex]),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => notification()),
                );
              },
              child: Icon(Icons.notifications_active),
            ),
          ),
        ],
      ),
      drawer: PatientDrawer(
        selectedIndex: _currentIndex,
        onSelect: (i) {
          setState(() {
            _currentIndex = i;
            print(i);
          });
          Navigator.pop(context);
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}

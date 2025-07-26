import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  @override
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

  String userName = 'Loading...';

  Map<String, dynamic> patient = {
    'id': 'p123',
    'name': 'John Doe',
    'age': 29,
    'gender': 'Male',
    'email': 'john.doe@example.com',
    'phone': '+1 234 567 890',
    'profilePic': null,
    'medicalHistory': [
      {
        'disease': 'Hypertension',
        'diagnosisDate': '2023-11-15',
        'medicine': 'Lisinopril 10mg',
      },
      {
        'disease': 'Type 2 Diabetes',
        'diagnosisDate': '2023-09-22',
        'medicine': 'Metformin 500mg',
      },
    ],
  };

  void _editProfile() {
    // Mock edit dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile (Mock)'),
        content: const Text('Profile editing coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'ID: ${patient['id']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _editProfile,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Info',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(
                        FirebaseAuth.instance.currentUser?.email ?? 'No email',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medical History',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(patient['medicalHistory'].length, (i) {
                      final record = patient['medicalHistory'][i];
                      return ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(record['disease']),
                        subtitle: Text(
                          'Diagnosed: ${record['diagnosisDate']}\nMedicine: ${record['medicine']}',
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

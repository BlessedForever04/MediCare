import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  String firstName = "Loading...";
  String lastName = "";
  String specialization = "";
  String bio = "";
  List<String> achievements = [];
  List<String> specialties = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctorInfo();
  }

  Future<void> _fetchDoctorInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(uid)
        .get();
    if (doc.exists) {
      final data = doc.data()?['UserInfo'];
      if (data != null) {
        setState(() {
          firstName = data['first_name'] ?? '';
          lastName = data['last_name'] ?? '';
          specialization = data['specialization'] ?? 'Specialist';
          bio = data['bio'] ?? '';
          achievements = List<String>.from(data['achievements'] ?? []);
          specialties = List<String>.from(data['specialties'] ?? []);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullName = "$firstName $lastName";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/doctor.jpg'),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(specialization),
                  Row(
                    children: List.generate(
                      5,
                      (i) =>
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Major Achievements',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          ...achievements.map((a) => Text('• $a')).toList(),
          const SizedBox(height: 24),
          const Text(
            'Specialties',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Text(
            ''
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: specialties.map((s) => Chip(label: Text(s))).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            bio.isNotEmpty
                ? bio
                : 'Dr. $fullName is a dedicated healthcare professional.',
          ),
        ],
      ),
    );
  }
}

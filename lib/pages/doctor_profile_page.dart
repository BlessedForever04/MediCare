import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  String userName = "Loading";
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(
                  'assets/doctor.jpg',
                ), 
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Cardiologist'),
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
          const Text(
            '• Published 10+ research papers in cardiology\n• Winner of National Medical Award 2022\n• 15 years of experience',
          ),
          const SizedBox(height: 24),
          const Text(
            'Specialties',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: const [
              Chip(label: Text('Cardiology')),
              Chip(label: Text('Hypertension')),
              Chip(label: Text('Diabetes')),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dr. John Doe is a renowned cardiologist with over 15 years of experience. He is passionate about patient care and medical research.',
          ),
        ],
      ),
    );
  }
}

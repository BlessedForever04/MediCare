import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  String? userId;
  String? patientId;
  Map<String, dynamic>? patientData;
  List<dynamic> medicineReminders = [];

  final List<String> healthTips = [
    'Drink plenty of water every day!',
    'Take a short walk after meals.',
    'Eat more fruits and vegetables.',
    'Get at least 7 hours of sleep.',
    'Practice deep breathing to reduce stress.',
    'Wash your hands regularly.',
    'Limit sugary drinks and snacks.',
  ];

  String? todayTip;
  bool showFullQR = false;

  @override
  void initState() {
    super.initState();
    todayTip = (healthTips..shuffle()).first;
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      final healthInfo = data?['HealthInfo'] ?? {};
      final history = List.from(healthInfo['History'] ?? []);
      setState(() {
        userId = uid;
        patientId = data?['userid']?.toString() ?? 'N/A';
        patientData = data;
        medicineReminders = history;
      });
    }
  }

  Future<void> markConsumed(int index) async {
    setState(() {
      medicineReminders[index]['consumed'] = true;
      medicineReminders[index]['streak'] =
          (medicineReminders[index]['streak'] ?? 0) + 1;
    });

    // Update Firestore
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('patients').doc(uid).update({
      'HealthInfo.History': medicineReminders,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (patientData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // QR + Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => showFullQR = !showFullQR),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade100, width: 2),
                        ),
                        child: showFullQR
                            ? QrImageView(data: patientId ?? 'N/A', size: 80)
                            : const Icon(Icons.qr_code, size: 60, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Patient ID: $patientId', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              // You can implement your medical history modal or navigation here.
                            },
                            icon: const Icon(Icons.folder_open),
                            label: const Text('View Medical History & Docs'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Health Tip Card
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const Icon(Icons.tips_and_updates, color: Colors.blue),
                title: const Text('Daily Health Tip'),
                subtitle: Text(todayTip ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      todayTip = (healthTips..shuffle()).first;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Reminders
            Text('Today\'s Reminders', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...medicineReminders.map((med) {
              final index = medicineReminders.indexOf(med);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(Icons.medication, color: (med['consumed'] ?? false) ? Colors.green : Colors.red),
                  title: Text(med['medicine'] ?? 'Unknown Medicine'),
                  subtitle: Text(
                    'Time: ${med['consumptionTime'] ?? 'N/A'}\n'
                    'Streak: ${med['streak'] ?? 0} days',
                  ),
                  trailing: (med['consumed'] ?? false)
                      ? const Icon(Icons.check, color: Colors.green)
                      : ElevatedButton(
                          onPressed: () => markConsumed(index),
                          child: const Text('Mark Consumed'),
                        ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientMedicineReminderPage extends StatefulWidget {
  const PatientMedicineReminderPage({super.key});

  @override
  State<PatientMedicineReminderPage> createState() =>
      _PatientMedicineReminderPageState();
}

class _PatientMedicineReminderPageState
    extends State<PatientMedicineReminderPage> {
  List<Map<String, dynamic>> medicineReminders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMedicineReminders();
  }

  Future<void> fetchMedicineReminders() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      final history = data?['HealthInfo']?['History'] ?? [];

      setState(() {
        medicineReminders = List<Map<String, dynamic>>.from(history);
        isLoading = false;
      });
    }
  }

  Future<void> markConsumed(int index) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      medicineReminders[index]['consumed'] = true;
      medicineReminders[index]['streak'] =
          (medicineReminders[index]['streak'] ?? 0) + 1;
    });
    await FirebaseFirestore.instance.collection('patients').doc(uid).update({
      'HealthInfo.History': medicineReminders,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Reminders'),
        backgroundColor: Colors.green.shade400,
      ),
      body: medicineReminders.isEmpty
          ? const Center(child: Text('No reminders found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: medicineReminders.length,
              itemBuilder: (context, index) {
                final med = medicineReminders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      Icons.medication,
                      color: med['consumed'] ? Colors.green : Colors.red,
                    ),
                    title: Text(med['medicine'] ?? 'Unknown Medicine'),
                    subtitle: Text(
                      'Time: ${med['consumptionTime'] ?? 'N/A'}\n'
                      'Streak: ${med['streak'] ?? 0} days',
                    ),
                    trailing: med['consumed']
                        ? const Icon(Icons.check, color: Colors.green)
                        : ElevatedButton(
                            onPressed: () => markConsumed(index),
                            child: const Text('Mark Consumed'),
                          ),
                  ),
                );
              },
            ),
    );
  }
}

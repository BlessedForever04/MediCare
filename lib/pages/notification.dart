import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temp/main.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  final List<String> notifications = [
    'Bob Doe reported fever today.',
    'Alice Doe completed her medicine streak!',
    'Jane Doe updated her health status.',
  ];

  List<Map<String, dynamic>> medicines = [];
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
        medicines = List<Map<String, dynamic>>.from(history);
        isLoading = false;
      });
    }
  }

  Future<void> markConsumed(int index) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      medicines[index]['consumed'] = true;
      medicines[index]['streak'] = (medicines[index]['streak'] ?? 0) + 1;
    });

    await FirebaseFirestore.instance.collection('patients').doc(uid).update({
      'HealthInfo.History': medicines,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme_color,
        centerTitle: true,
        title: const Text(
          "Notification",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Static notifications
                if (notifications.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Health Alerts",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...notifications.map(
                    (n) => Card(
                      color: Colors.blue.shade50,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.notifications_active),
                        title: Text(n),
                      ),
                    ),
                  ),
                  const Divider(height: 30),
                ],

                // Medicine Reminders
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "Pending Medicines",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...medicines.asMap().entries.map((entry) {
                  int index = entry.key;
                  final med = entry.value;
                  if (med['consumed'] == true) return const SizedBox.shrink();

                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      leading: const Icon(Icons.medication, color: Colors.red),
                      title: Text(med['medicine'] ?? 'Medicine'),
                      subtitle: Text(
                        'Time: ${med['consumptionTime'] ?? 'N/A'}\nStreak: ${med['streak'] ?? 0} days',
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => markConsumed(index),
                        child: const Text('Mark Consumed'),
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';

class PatientMedicineReminderPage extends StatefulWidget {
  const PatientMedicineReminderPage({super.key});

  @override
  State<PatientMedicineReminderPage> createState() =>
      _PatientMedicineReminderPageState();
}

class _PatientMedicineReminderPageState
    extends State<PatientMedicineReminderPage> {
  List<Map<String, dynamic>> medicines = [
    {
      'name': 'Lisinopril 10mg',
      'time': '8:00 AM',
      'consumed': false,
      'streak': 3,
    },
    {
      'name': 'Metformin 500mg',
      'time': '9:00 PM',
      'consumed': false,
      'streak': 5,
    },
  ];

  void markConsumed(int index) {
    setState(() {
      medicines[index]['consumed'] = true;
      medicines[index]['streak'] += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final med = medicines[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                Icons.medication,
                color: med['consumed'] ? Colors.green : Colors.red,
              ),
              title: Text(med['name']),
              subtitle: Text(
                'Time: ${med['time']}\nStreak: ${med['streak']} days',
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

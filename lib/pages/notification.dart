import 'package:flutter/material.dart';
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
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final med = medicines[index];
          if (med['consumed'] == true) return const SizedBox.shrink();

          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.medication, color: Colors.red),
              title: Text(med['name']),
              subtitle: Text(
                'Time: ${med['time']}\nStreak: ${med['streak']} days',
              ),
              trailing: ElevatedButton(
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

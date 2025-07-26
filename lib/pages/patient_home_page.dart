import 'package:flutter/material.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
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

  @override
  void initState() {
    super.initState();
    todayTip = (healthTips..shuffle()).first;
  }

  void _showMedicalHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Medical History & Documents'),
        content: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('All Medical Records (Mock)'),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Blood Test Report'),
                subtitle: const Text('2024-05-10'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {},
                ),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('X-Ray Result'),
                subtitle: const Text('2024-04-22'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {},
                ),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Prescription'),
                subtitle: const Text('2024-06-01'),
                trailing: IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAppointmentBookingDialog() {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Appointment'),
        content: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Doctor Name'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                ),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g. 10:00 AM)',
                ),
              ),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
         
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment booked (mock)!')),
              );
            },
            child: const Text('Book'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final patientId = '22310183';
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code,
                          size: 60,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patient ID: $patientId',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _showMedicalHistoryDialog,
                            icon: const Icon(Icons.folder_open),
                            label: const Text('View Medical History & Docs'),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
 
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.deepPurple,
                      size: 40,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Book a Doctor Appointment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _showAppointmentBookingDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Book Appointment'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
        
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.tips_and_updates, color: Colors.blue),
                title: const Text('Daily Health Tip'),
                subtitle: Text(todayTip ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'New Tip',
                  onPressed: () {
                    setState(() {
                      todayTip = (healthTips..shuffle()).first;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
       
            Card(
              color: Colors.orange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.orange),
                title: const Text('Achievements'),
                subtitle: const Text(
                  'Medicine Streak: 5 days\nHealth Tips Read: 3',
                ),
                trailing: const Icon(Icons.star, color: Colors.amber),
              ),
            ),
            const SizedBox(height: 16),
    
            Card(
              color: Colors.purple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.format_quote, color: Colors.purple),
                title: const Text('Motivation'),
                subtitle: const Text('"The greatest wealth is health."'),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Today\'s Reminders',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            SizedBox(
              height: medicines.length * 100,
              child: ListView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}

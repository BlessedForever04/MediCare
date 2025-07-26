import 'package:flutter/material.dart';

class FamilyConnectPage extends StatefulWidget {
  const FamilyConnectPage({Key? key}) : super(key: key);

  @override
  State<FamilyConnectPage> createState() => _FamilyConnectPageState();
}

class _FamilyConnectPageState extends State<FamilyConnectPage> {
  final List<Map<String, dynamic>> familyMembers = [
    {
      'name': 'Alice Doe',
      'relation': 'Mother',
      'status': 'Healthy',
      'lastUpdate': 'Today',
      'ill': false,
    },
    {
      'name': 'Bob Doe',
      'relation': 'Father',
      'status': 'Fever',
      'lastUpdate': 'Today',
      'ill': true,
    },
    {
      'name': 'Jane Doe',
      'relation': 'Sister',
      'status': 'Healthy',
      'lastUpdate': 'Yesterday',
      'ill': false,
    },
  ];
  final List<String> notifications = [
    'Bob Doe reported fever today.',
    'Alice Doe completed her medicine streak!',
    'Jane Doe updated her health status.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family Members',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...familyMembers.map(
              (member) => Card(
                color: member['ill']
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: member['ill'] ? Colors.red : Colors.green,
                  ),
                  title: Text('${member['name']} (${member['relation']})'),
                  subtitle: Text(
                    'Status: ${member['status']}\nLast update: ${member['lastUpdate']}',
                  ),
                  trailing: member['ill']
                      ? const Icon(Icons.warning, color: Colors.red)
                      : const Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...notifications.map(
              (n) => Card(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(n),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

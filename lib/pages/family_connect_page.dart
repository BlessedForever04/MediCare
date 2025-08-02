import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FamilyConnectPage extends StatefulWidget {
  const FamilyConnectPage({super.key});

  @override
  State<FamilyConnectPage> createState() => _FamilyConnectPageState();
}

class _FamilyConnectPageState extends State<FamilyConnectPage> {
  List<Map<String, dynamic>> familyMembers = [];
  List<String> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFamilyConnections();
  }

  Future<void> fetchFamilyConnections() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();

      if (!doc.exists) return;

      final connections = doc.data()?['FamilyConnections']?['members'] ?? [];

      List<Map<String, dynamic>> fetchedMembers = [];
      List<String> fetchedNotifications = [];

      for (final member in connections) {
        final memberDoc = await FirebaseFirestore.instance
            .collection('patients')
            .doc(member['id'])
            .get();

        if (!memberDoc.exists) continue;

        final data = memberDoc.data();
        final name =
            '${data?['first_name'] ?? 'Unknown'} ${data?['last_name'] ?? ''}';
        final status = data?['HealthInfo']?['currentHealthStatus'] ?? 'Unknown';
        final lastUpdate = data?['HealthInfo']?['lastUpdated'] ?? 'N/A';

        bool isIll = status.toLowerCase() != 'healthy';

        fetchedMembers.add({
          'name': name,
          'relation': member['relation'] ?? 'Relative',
          'status': status,
          'lastUpdate': lastUpdate,
          'ill': isIll,
        });

        fetchedNotifications.add('$name updated health status: $status');
      }

      setState(() {
        familyMembers = fetchedMembers;
        notifications = fetchedNotifications;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching family connections: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Family Members',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (familyMembers.isEmpty)
                    const Text('No family members linked.'),
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
                        title: Text(
                          '${member['name']} (${member['relation']})',
                        ),
                        subtitle: Text(
                          'Status: ${member['status']}\nLast update: ${member['lastUpdate']}',
                        ),
                        trailing: member['ill']
                            ? const Icon(Icons.warning, color: Colors.red)
                            : const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (notifications.isEmpty)
                    const Text('No recent notifications.'),
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_medical_record_page.dart';

class PatientDetailsPage extends StatefulWidget {
  final Map<String, dynamic> patient;

  const PatientDetailsPage({super.key, required this.patient});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicalHistory();
  }

  Future<void> _fetchMedicalHistory() async {
    final patientId = widget.patient['userid'] ?? widget.patient['id'];

    final doc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(patientId)
        .get();

    if (doc.exists) {
      final history = doc.data()?['HealthInfo']?['History'] ?? [];
      setState(() {
        records = List<Map<String, dynamic>>.from(history);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientName =
        '${widget.patient['first_name'] ?? ''} ${widget.patient['last_name'] ?? ''}';
    final patientId = widget.patient['userid'] ?? widget.patient['id'];

    return Scaffold(
      appBar: AppBar(title: Text(patientName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey.shade300,
                    child: const Center(child: Icon(Icons.qr_code, size: 80)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Patient ID: $patientId',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Medical History',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (records.isEmpty) const Text("No medical records found."),
            ...records.map((record) => _MedicalRecordCard(record: record)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicalRecordPage(patientId: patientId),
            ),
          ).then((_) => _fetchMedicalHistory()); // Refresh after adding
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
      ),
    );
  }
}

class _MedicalRecordCard extends StatefulWidget {
  final Map<String, dynamic> record;
  const _MedicalRecordCard({required this.record});

  @override
  State<_MedicalRecordCard> createState() => _MedicalRecordCardState();
}

class _MedicalRecordCardState extends State<_MedicalRecordCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.record;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            title: Text(r['disease'] ?? 'Unknown Disease'),
            subtitle: Text(
              'Diagnosed: ${r['diagnosisDate'] ?? 'Unknown Date'}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => expanded = !expanded),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // You can navigate to edit page here later
                  },
                ),
              ],
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Medicine: ${r['medicine'] ?? 'N/A'}'),
                  Text('Duration: ${r['duration'] ?? 'N/A'}'),
                  Text('Hospital: ${r['hospital'] ?? 'N/A'}'),
                  Text('Doctor: ${r['doctor'] ?? 'N/A'}'),
                  Text('Notes: ${r['notes'] ?? 'N/A'}'),
                  Text('Precautions: ${r['precautions'] ?? 'N/A'}'),
                  Text('Avoid: ${r['avoid'] ?? 'N/A'}'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

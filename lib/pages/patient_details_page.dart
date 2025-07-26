import 'package:flutter/material.dart';
import 'add_medical_record_page.dart';

class PatientDetailsPage extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientDetailsPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> records = [
      {
        'disease': 'Hypertension',
        'diagnosisDate': '2023-11-15',
        'medicine': 'Lisinopril 10mg',
        'duration': '6 months',
        'hospital': 'City Hospital',
        'doctor': 'Dr. Sarah Miller',
        'notes': 'Monitor BP daily',
        'precautions': 'Reduce salt intake',
        'avoid': 'Salty foods',
      },
      {
        'disease': 'Type 2 Diabetes',
        'diagnosisDate': '2023-09-22',
        'medicine': 'Metformin 500mg',
        'duration': 'Ongoing',
        'hospital': 'Metro Clinic',
        'doctor': 'Dr. James Wilson',
        'notes': 'Check blood sugar before breakfast',
        'precautions': 'Exercise regularly',
        'avoid': 'Sugary foods',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(patient['name']),
      ),
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
                  Text('Patient ID: ${patient['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Medical History', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...records.map((record) => _MedicalRecordCard(record: record)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicalRecordPage()),
          );
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
            title: Text(r['disease']),
            subtitle: Text('Diagnosed: ${r['diagnosisDate']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => expanded = !expanded),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {}, 
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
                  Text('Medicine: ${r['medicine']}'),
                  Text('Duration: ${r['duration']}'),
                  Text('Hospital: ${r['hospital']}'),
                  Text('Doctor: ${r['doctor']}'),
                  Text('Notes: ${r['notes']}'),
                  Text('Precautions: ${r['precautions']}'),
                  Text('Avoid: ${r['avoid']}'),
                ],
              ),
            ),
        ],
      ),
    );
  }
} 
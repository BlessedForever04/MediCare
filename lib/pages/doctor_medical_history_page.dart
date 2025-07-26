import 'package:flutter/material.dart';

class DoctorMedicalHistoryPage extends StatelessWidget {
  const DoctorMedicalHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> medicalRecords = [
      {
        'condition': 'Hypertension',
        'date': '2023-11-15',
        'medication': 'Lisinopril 10mg',
        'doctor': 'Dr. Sarah Miller'
      },
      {
        'condition': 'Type 2 Diabetes',
        'date': '2023-09-22',
        'medication': 'Metformin 500mg',
        'doctor': 'Dr. James Wilson'
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.qr_code, size: 40),
              const SizedBox(width: 12),
              const Text('Patient ID: P-789456', style: TextStyle(fontSize: 18)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Update History'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Medical Records', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: medicalRecords.length,
              itemBuilder: (context, index) {
                final record = medicalRecords[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.medical_services, size: 36),
                    title: Text(record['condition']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Diagnosed: ${record['date']}'),
                        Text('Medication: ${record['medication']}'),
                        Text('Doctor: ${record['doctor']}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'patient_details_page.dart';

class DoctorPatientsPage extends StatelessWidget {
  final List<Map<String, dynamic>> patients;
  final void Function(Map<String, dynamic>) addPatient;

  const DoctorPatientsPage({
    super.key,
    required this.patients,
    required this.addPatient,
  });

  void _showAddPatientDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _idController = TextEditingController();
    final _phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Patient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'Patient ID'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              addPatient({
                'id': _idController.text,
                'name': _nameController.text,
                'avatar': _nameController.text.isNotEmpty ? _nameController.text[0] : '?',
                'condition': 'Unknown',
                'status': 'New',
                'lastRecord': '',
                'compliance': true,
                'records': [],
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Patient added (mock)!')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: patients.length,
          itemBuilder: (context, index) {
            final patient = patients[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(patient['name']),
                subtitle: Text('ID: ${patient['id']}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientDetailsPage(patient: patient),
                    ),
                  );
                },
              ),
            );
          },
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: () => _showAddPatientDialog(context),
            child: const Icon(Icons.person_add),
            tooltip: 'Add Patient',
          ),
        ),
      ],
    );
  }
} 
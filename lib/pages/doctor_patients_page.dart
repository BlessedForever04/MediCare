import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'patient_details_page.dart';

class DoctorPatientsPage extends StatefulWidget {
  final List<Map<String, dynamic>> patients;
  final void Function(Map<String, dynamic>) addPatient;

  const DoctorPatientsPage({
    super.key,
    required this.patients,
    required this.addPatient,
  });

  @override
  State<DoctorPatientsPage> createState() => _DoctorPatientsPageState();
}

class _DoctorPatientsPageState extends State<DoctorPatientsPage> {
  void _showAddPatientDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Patient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Patient Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              final email = emailController.text.trim();

              if (uid != null && email.isNotEmpty) {
                try {
                  final querySnapshot = await FirebaseFirestore.instance
                      .collection('patients')
                      .where('email', isEqualTo: email)
                      .limit(1)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    final patientDoc = querySnapshot.docs.first;
                    final patientData = patientDoc.data();
                    final patientId = patientDoc.id;

                    patientData['id'] = patientId;
                    widget.addPatient(patientData);

                    final doctorRef = FirebaseFirestore.instance
                        .collection('doctors')
                        .doc(uid);
                    final doctorSnap = await doctorRef.get();

                    final activePatients = List<String>.from(
                      doctorSnap.data()?['PatientDetails']['ActivePatients'] ??
                          [],
                    );

                    if (!activePatients.contains(patientId)) {
                      activePatients.add(patientId);
                      await doctorRef.update({
                        'PatientDetails.ActivePatients': activePatients,
                      });
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Patient added successfully.'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Patient not found.')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
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
          itemCount: widget.patients.length,
          itemBuilder: (context, index) {
            final patient = widget.patients[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(patient['first_name'] ?? 'Unnamed'),
                subtitle: Text('ID: ${patient['id'] ?? 'Unknown'}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PatientDetailsPage(patient: patient),
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
            tooltip: 'Add Patient',
            child: const Icon(Icons.person_add),
          ),
        ),
      ],
    );
  }
}

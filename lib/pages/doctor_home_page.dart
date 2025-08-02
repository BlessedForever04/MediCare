import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_details_page.dart';

class DoctorHomePage extends StatefulWidget {
  final List<Map<String, dynamic>> patients; 
  final List<Map<String, dynamic>> appointments;
  final void Function(Map<String, dynamic>) addAppointment;
  final void Function(int) markAppointmentDone;
  final void Function(int) deleteAppointment;

  const DoctorHomePage({
    super.key,
    required this.patients, 
    required this.appointments,
    required this.addAppointment,
    required this.markAppointmentDone,
    required this.deleteAppointment,
  });

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  late List<Map<String, dynamic>> patients;

  @override
  void initState() {
    super.initState();
    patients = widget.patients; 
  }

  void _showQRScanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Patient QR'),
        content: SizedBox(
          height: 220,
          child: Column(
            children: [
              Container(
                width: 180,
                height: 180,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.qr_code_scanner, size: 100),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Mock QR Scanner UI'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (patients.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PatientDetailsPage(patient: patients[0]),
                  ),
                );
              }
            },
            child: const Text('Simulate Scan'),
          ),
        ],
      ),
    );
  }

  void _showAddAppointmentDialog(BuildContext context) {
    final patientNameController = TextEditingController();
    final patientIdController = TextEditingController();
    final reasonController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Appointment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: patientNameController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
              ),
              TextField(
                controller: patientIdController,
                decoration: const InputDecoration(labelText: 'Patient UID'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) selectedDate = pickedDate;
                },
                child: const Text('Pick Appointment Date'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) selectedTime = pickedTime;
                },
                child: const Text('Pick Appointment Time'),
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
            onPressed: () async {
              if (selectedDate != null && selectedTime != null) {
                final newAppointment = {
                  'patient': patientNameController.text,
                  'avatar': patientNameController.text.isNotEmpty
                      ? patientNameController.text[0]
                      : '?',
                  'patientId': patientIdController.text,
                  'reason': reasonController.text,
                  'date':
                      '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                  'time': selectedTime!.format(context),
                  'done': false,
                };

                widget.addAppointment(newAppointment);

                final doctorUid = FirebaseAuth.instance.currentUser?.uid;
                if (doctorUid != null) {
                  await FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(doctorUid)
                      .collection('PatientAppointments')
                      .add(newAppointment);
                }

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please pick both date and time'),
                  ),
                );
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
    final summaryData = {
      'appointments': widget.appointments.where((a) => !a['done']).length,
      'active_patients': patients.length,
    };

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showQRScanner(context),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Patient QR'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildSummaryCard(
                  'Today\'s Appointments',
                  summaryData['appointments'].toString(),
                  Icons.event,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  'Active Patients',
                  summaryData['active_patients'].toString(),
                  Icons.people,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '${summaryData['appointments']} Upcoming Appointments',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ...widget.appointments
                .asMap()
                .entries
                .where((e) => !e.value['done'])
                .map((entry) {
                  final appt = entry.value;
                  final idx = entry.key;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(appt['avatar'])),
                      title: Text(appt['patient']),
                      subtitle: Text(
                        '${appt['date']} at ${appt['time']}\n${appt['reason']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => widget.markAppointmentDone(idx),
                            child: const Text('Done'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => widget.deleteAppointment(idx),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 24),
            Text(
              'Active Patients',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ...patients.map(
              (patient) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (patient['compliance'] ?? false)
                        ? Colors.green
                        : Colors.red,
                    child: Text(patient['avatar'] ?? '?'),
                  ),
                  title: Text(patient['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Condition: ${patient['condition']}'),
                      Text('Status: ${patient['status']}'),
                      Text('Last Record: ${patient['lastRecord']}'),
                      Text(
                        'Compliance: ${(patient['compliance'] ?? false) ? "Yes" : "No"}',
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientDetailsPage(patient: patient),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: () => _showAddAppointmentDialog(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

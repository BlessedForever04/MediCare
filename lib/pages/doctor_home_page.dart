import 'package:flutter/material.dart';
import 'add_medical_record_page.dart';
import 'patient_details_page.dart';

class DoctorHomePage extends StatelessWidget {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PatientDetailsPage(patient: patients[0]),
                ),
              );
            },
            child: const Text('Simulate Scan'),
          ),
        ],
      ),
    );
  }

  void _showAddAppointmentDialog(BuildContext context) {
    final patientController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Appointment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: patientController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
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
              addAppointment({
                'patient': patientController.text,
                'avatar': patientController.text.isNotEmpty
                    ? patientController.text[0]
                    : '?',
                'date': dateController.text,
                'time': timeController.text,
                'reason': reasonController.text,
                'done': false,
              });
              Navigator.pop(context);
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
      'appointments': appointments.where((a) => !a['done']).length,
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
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
              '${summaryData['appointments'].toString()} Upcoming Appointments',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ...appointments.asMap().entries.where((e) => !e.value['done']).map((
              entry,
            ) {
              final appt = entry.value;
              final idx = entry.key;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(child: Text(appt['avatar'] as String)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appt['patient'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(appt['reason'] as String),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appt['date'] as String),
                                    Text(
                                      appt['time'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => markAppointmentDone(idx),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(80, 32),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text('Mark Done'),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => deleteAppointment(idx),
                                      tooltip: 'Delete Appointment',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: (patient['compliance'] as bool)
                            ? Colors.green
                            : Colors.red,
                        child: Text(
                          patient['avatar'] as String,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient['name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Condition: ${patient['condition'] as String}',
                            ),
                            Text('Status: ${patient['status'] as String}'),
                            Text(
                              'Last Record: ${patient['lastRecord'] as String}',
                            ),
                            Row(
                              children: [
                                const Text('Medicine Compliance: '),
                                (patient['compliance'] as bool)
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 18,
                                      )
                                    : const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMedicalRecordPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 32),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('Assign Medicine'),
                      ),
                    ],
                  ),
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
            tooltip: 'Add Appointment',
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
              Icon(icon, size: 32, color: color),
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMedicalRecordPage extends StatefulWidget {
  final String patientId;

  const AddMedicalRecordPage({super.key, required this.patientId});

  @override
  State<AddMedicalRecordPage> createState() => _AddMedicalRecordPageState();
}

class _AddMedicalRecordPageState extends State<AddMedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController diseaseController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController precautionsController = TextEditingController();
  final TextEditingController avoidController = TextEditingController();

  bool notifyFamily = false;
  String? _selectedReport;

  void _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final record = {
        'disease': diseaseController.text.trim(),
        'diagnosisDate': dateController.text.trim(),
        'medicine': medicineController.text.trim(),
        'duration': durationController.text.trim(),
        'hospital': hospitalController.text.trim(),
        'doctor': doctorController.text.trim(),
        'notes': notesController.text.trim(),
        'precautions': precautionsController.text.trim(),
        'avoid': avoidController.text.trim(),
        'report': _selectedReport,
        'timestamp': Timestamp.now(),
      };

      try {
        final patientRef = FirebaseFirestore.instance
            .collection('patients')
            .doc(widget.patientId);

        await patientRef.update({
          'HealthInfo.History': FieldValue.arrayUnion([record]),
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Medical record saved!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medical Record')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: diseaseController,
                decoration: const InputDecoration(
                  labelText: 'Disease/Condition',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a condition' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date of Diagnosis',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: medicineController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Assigned',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a medicine' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Treatment Duration',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: hospitalController,
                decoration: const InputDecoration(labelText: 'Hospital Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: doctorController,
                decoration: const InputDecoration(labelText: 'Doctor\'s Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Extra Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: precautionsController,
                decoration: const InputDecoration(
                  labelText: 'Precautions to Take',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: avoidController,
                decoration: const InputDecoration(
                  labelText: 'Foods/Activities to Avoid',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedReport =
                            'report_${DateTime.now().millisecondsSinceEpoch}.pdf';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected: $_selectedReport')),
                      );
                    },
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Add Report'),
                  ),
                  const SizedBox(width: 16),
                  if (_selectedReport != null)
                    Expanded(
                      child: Text(
                        _selectedReport!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                value: notifyFamily,
                onChanged: (val) => setState(() => notifyFamily = val),
                title: const Text('Notify Family of Diagnosis'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveRecord,
                child: const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

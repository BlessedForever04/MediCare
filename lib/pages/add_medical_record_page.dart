import 'package:flutter/material.dart';

class AddMedicalRecordPage extends StatefulWidget {
  const AddMedicalRecordPage({super.key});

  @override
  State<AddMedicalRecordPage> createState() => _AddMedicalRecordPageState();
}

class _AddMedicalRecordPageState extends State<AddMedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  bool notifyFamily = false;
  String? _selectedReport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medical Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Disease/Condition'),
                validator: (value) => value!.isEmpty ? 'Please enter a condition' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date of Diagnosis'),
                validator: (value) => value!.isEmpty ? 'Please enter a date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Medicine Assigned'),
                validator: (value) => value!.isEmpty ? 'Please enter a medicine' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Treatment Duration'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Hospital Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Doctor\'s Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Extra Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Precautions to Take'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Foods/Activities to Avoid'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedReport = 'new_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
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
                    Expanded(child: Text(_selectedReport!, overflow: TextOverflow.ellipsis)),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Medical record saved!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
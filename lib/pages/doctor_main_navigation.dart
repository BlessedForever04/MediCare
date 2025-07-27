import 'package:flutter/material.dart';
import 'package:temp/pages/doctor_settings_page.dart';
import 'doctor_home_page.dart';
import 'doctor_patients_page.dart';
import 'doctor_profile_page.dart';
import 'doctor_ai_assistant_page.dart';
import 'doctor_drawer.dart';

class DoctorStateContainer extends StatefulWidget {
  const DoctorStateContainer({super.key});

  @override
  State<DoctorStateContainer> createState() => _DoctorStateContainerState();
}

class _DoctorStateContainerState extends State<DoctorStateContainer> {
  List<Map<String, dynamic>> patients = [
    {
      'id': 'p1',
      'name': 'Sahil Wasankar',
      'avatar': 'A',
      'condition': 'Hypertension',
      'status': 'Stable',
      'lastRecord': 'BP: 130/85, Lisinopril 10mg',
      'compliance': true,
      'records': [
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
      ],
    },
    {
      'id': 'p2',
      'name': 'Mayank Agrawal',
      'avatar': 'M',
      'condition': 'Type 2 Diabetes',
      'status': 'Needs Attention',
      'lastRecord': 'Glucose: 180 mg/dL, Metformin 500mg',
      'compliance': false,
      'records': [
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
      ],
    },
  ];

  List<Map<String, dynamic>> appointments = [
    {
      'patient': 'Sahil Wasankar',
      'avatar': 'A',
      'date': '2024-06-10',
      'time': '10:00 AM',
      'reason': 'Follow-up for Hypertension',
      'done': false,
    },
    {
      'patient': 'Naman Singh',
      'avatar': 'M',
      'date': '2024-06-10',
      'time': '11:30 AM',
      'reason': 'New Consultation - Diabetes',
      'done': false,
    },
  ];

  int _currentIndex = 0;

  void addPatient(Map<String, dynamic> patient) {
    setState(() {
      patients.add(patient);
    });
  }

  void addAppointment(Map<String, dynamic> appt) {
    setState(() {
      appointments.add(appt);
    });
  }

  void markAppointmentDone(int index) {
    setState(() {
      appointments[index]['done'] = true;
    });
  }

  void deleteAppointment(int index) {
    setState(() {
      appointments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DoctorHomePage(
        patients: patients,
        appointments: appointments,
        addAppointment: addAppointment,
        markAppointmentDone: markAppointmentDone,
        deleteAppointment: deleteAppointment,
      ),
      DoctorPatientsPage(patients: patients, addPatient: addPatient),
      const DoctorProfilePage(),
      const PatientAIAssistantPage(),
      const doctor_settings(),
    ];
    final List<String> pageTitles = [
      'Doctor Dashboard',
      'My Patients',
      'Doctor Profile',
      'AI Health Assistant',
      'Doctor\'s Setting',
    ];
    return Scaffold(
      appBar: AppBar(title: Text(pageTitles[_currentIndex])),
      drawer: DoctorDrawer(
        selectedIndex: _currentIndex,
        onSelect: (i) {
          setState(() {
            _currentIndex = i;
            print(i);
          });
          Navigator.pop(context);
        },
      ),
      body: pages[_currentIndex],
    );
  }
}

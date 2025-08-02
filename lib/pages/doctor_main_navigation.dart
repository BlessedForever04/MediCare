import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'doctor_home_page.dart';
import 'doctor_patients_page.dart';
import 'doctor_profile_page.dart';
import 'doctor_ai_assistant_page.dart';
import 'doctor_drawer.dart';
import 'doctor_settings_page.dart';

class DoctorStateContainer extends StatefulWidget {
  const DoctorStateContainer({super.key});

  @override
  State<DoctorStateContainer> createState() => _DoctorStateContainerState();
}

class _DoctorStateContainerState extends State<DoctorStateContainer> {
  List<Map<String, dynamic>> patients = [];
  List<Map<String, dynamic>> appointments = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  Future<void> _loadDoctorData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final docRef = FirebaseFirestore.instance.collection('doctors').doc(uid);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      final data = docSnap.data()!;
      final details = data['PatientDetails'] ?? {};

      // Fetch appointments
      final rawAppointments = List<Map<String, dynamic>>.from(
        details['PatientAppointments'] ?? [],
      );
      appointments = rawAppointments;

      // Fetch patient UIDs and get full patient documents
      final patientUIDs = List<String>.from(details['ActivePatients'] ?? []);
      patients = [];

      for (String pid in patientUIDs) {
        final patientDoc = await FirebaseFirestore.instance
            .collection('patients')
            .doc(pid)
            .get();
        if (patientDoc.exists) {
          final patientData = patientDoc.data()!;
          patientData['id'] = pid;
          patientData['userid'] = patientData['userid'] ?? pid;
          patientData['first_name'] = patientData['first_name'] ?? 'Unknown';
          patientData['last_name'] = patientData['last_name'] ?? '';
          patientData['HealthInfo'] ??= {};
          patientData['HealthInfo']['currentHealthStatus'] =
              patientData['HealthInfo']['currentHealthStatus'] ?? 'Unknown';
          patients.add(patientData);
        }
      }

      setState(() {});
    }
  }

  void addAppointment(Map<String, dynamic> newAppointment) async {
    setState(() {
      appointments.add(newAppointment);
    });

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('doctors').doc(uid).update({
        'PatientDetails.PatientAppointments': appointments,
      });
    }
  }

  void deleteAppointment(int index) async {
    final removed = appointments.removeAt(index);
    setState(() {});

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('doctors').doc(uid).update({
        'PatientDetails.PatientAppointments': appointments,
      });
    }
  }

  void markAppointmentDone(int index) async {
    appointments[index]['done'] = true;
    setState(() {});

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('doctors').doc(uid).update({
        'PatientDetails.PatientAppointments': appointments,
      });
    }
  }

  void addPatient(Map<String, dynamic> newPatient) async {
    newPatient['id'] = newPatient['id'] ?? newPatient['userid'] ?? '';
    newPatient['userid'] = newPatient['userid'] ?? newPatient['id'] ?? '';
    patients.add(newPatient);
    setState(() {});

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final updatedUids = patients.map((p) => p['id']).toList();

      await FirebaseFirestore.instance.collection('doctors').doc(uid).update({
        'PatientDetails.ActivePatients': updatedUids,
      });
    }
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
          setState(() => _currentIndex = i);
          Navigator.pop(context);
        },
      ),
      body: pages[_currentIndex],
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:temp/pages/splash.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAq8oueRrcyLrkC3KUikJDiAtI2CladByM",
        authDomain: "hackathonproject-fbf26.firebaseapp.com",
        projectId: "hackathonproject-fbf26",
        storageBucket: "hackathonproject-fbf26.firebasestorage.app",
        messagingSenderId: "189759224181",
        appId: "1:189759224181:web:8acb2a6290b53aa041fb3c",
        measurementId: "G-5VF93NHJZR",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

var Theme_color = const Color.fromARGB(255, 60, 152, 232);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splash(),
    );
  }
}
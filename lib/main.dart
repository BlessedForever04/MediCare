import 'package:flutter/material.dart';
import 'package:temp/pages/login.dart';

void main() {
  runApp(MyApp());
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
    return MaterialApp(debugShowCheckedModeBanner: false, home: login());
  }
}

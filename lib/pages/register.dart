import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp/pages/login.dart';
import 'package:temp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class register_page extends StatefulWidget {
  const register_page({super.key});

  @override
  State<register_page> createState() => _MyAppState();
}

class _MyAppState extends State<register_page> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  TextEditingController registrationNumber = TextEditingController();
  String error = "";
  bool isDoctor = false;
  double elevationP = 0;
  double elevationd = 10;

  Future<void> register() async {
  if (password.text.trim() != confirmpass.text.trim()) {
    setState(() => error = "Passwords do not match");
    return;
  }

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: mail.text.trim(),
      password: password.text.trim(),
    );

    String uid = userCredential.user!.uid;

    // Generate custom user ID
    final countQuery = await FirebaseFirestore.instance
        .collection(isDoctor ? 'doctors' : 'patients')
        .count()
        .get();
    int userId = 101 + (countQuery.count ?? 0);

    if (isDoctor) {
      await FirebaseFirestore.instance.collection('doctors').doc(uid).set({
        'UserInfo': {
          'first_name': firstName.text.trim(),
          'last_name': lastName.text.trim(),
          'email': mail.text.trim(),
          'userid': userId,
          'registration_number': registrationNumber.text.trim(),
        },
        'PatientDetails': {
          'ActivePatients': [],
          'PatientAppointments': [],
        }
      });
    } else {
      await FirebaseFirestore.instance.collection('patients').doc(uid).set({
        'first_name': firstName.text.trim(),
        'last_name': lastName.text.trim(),
        'email': mail.text.trim(),
        'userid': userId,
        'HealthInfo': {
          'currentHealthStatus': '',
          'History': [],
        },
        'FamilyConnections': [],
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User registered successfully!")),
    );
  } on FirebaseAuthException catch (e) {
    setState(() => error = e.message ?? "Something went wrong");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.message}")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme_color, const Color.fromARGB(255, 155, 251, 176)],
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Registration",
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),

            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => login()),
              (Route<dynamic> route) => false,
            );
          },
          child: Icon(CupertinoIcons.back, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              width: 405,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Card(
                  shadowColor: const Color.fromARGB(255, 0, 0, 0),
                  elevation: 5,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme_color,
                                    const Color.fromARGB(255, 155, 251, 176),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "You are -",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: elevationP,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              elevationP = 0;
                                              elevationd = 5;
                                              isDoctor = false;
                                            });
                                          },
                                          child: Text(
                                            "Patient",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: elevationd,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              elevationP = 5;
                                              elevationd = 0;
                                              isDoctor = true;
                                            });
                                          },
                                          child: Text(
                                            "Doctor",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      userInput(firstName, "First name", false),
                      userInput(lastName, "Last name", false),
                      userInput(mail, "Mail", false),
                      if (isDoctor)
                        userInput(
                          registrationNumber,
                          "Registration Number",
                          false,
                        ),

                      userInput(password, "Password", true),
                      userInput(confirmpass, "Confirm Password", true),
                      SizedBox(
                        width: 250,

                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Theme_color,
                                  const Color.fromARGB(255, 155, 251, 176),
                                ],
                              ),
                            ),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              onPressed: () {
                                if (firstName.text.trim().isEmpty ||
                                    lastName.text.trim().isEmpty ||
                                    mail.text.trim().isEmpty ||
                                    password.text.trim().isEmpty ||
                                    confirmpass.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Complete all details"),
                                    ),
                                  );
                                } else {
                                  if (password.text.trim() !=
                                      confirmpass.text.trim()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Password does not match!",
                                        ),
                                      ),
                                    );
                                  } else {
                                    register();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => login(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                }
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget userInput(var userInput, String label, bool isPass) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: TextField(
      controller: userInput,
      cursorColor: Theme_color,
      obscureText: isPass,
      cursorHeight: 20,
      decoration: InputDecoration(
        labelText: label,

        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: const Color.fromARGB(255, 84, 255, 121),
          ),
        ),

        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme_color, width: 3),
        ),
      ),
    ),
  );
}
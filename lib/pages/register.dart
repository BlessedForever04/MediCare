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
  String error = "";

  Future<void> register() async {
    if (password.text.trim() != confirmpass.text.trim()) {
      setState(() => error = "Passwords do not match");
      return;
    }

    try {
      // 1. Create Firebase Auth user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: mail.text.trim(),
            password: password.text.trim(),
          );

      // 2. Save additional details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'first_name': firstName.text.trim(),
            'last_name': lastName.text.trim(),
            'email': mail.text.trim(),
            'created_at': FieldValue.serverTimestamp(),
          });
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? "Something went wrong");
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
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => login()));
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
                                child: Text(
                                  "Registration Details",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      userInput(firstName, "First name", false),
                      userInput(lastName, "Last name", false),
                      userInput(mail, "Mail", false),
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
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
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
                                  register();
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

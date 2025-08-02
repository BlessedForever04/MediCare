import 'package:flutter/material.dart';
import 'package:temp/pages/doctor_main_navigation.dart';
import 'package:temp/pages/patient_main_navigation.dart';
import 'package:temp/pages/register.dart';
import 'package:temp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui' as ui;

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Column(
                  children: [
                    appName(),
                    sloganText(),
                    loginCred(userName, password),
                    forgotPass(),
                    Column(
                      children: [
                        SizedBox(height: 30),
                        signinButton(userName, password),
                        googleButton(),
                        registerButton(context),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget appName() {
  return SizedBox(
    height: 100,
    width: 405,
    child: Center(
      child: Text(
        "MediCare",
        style: TextStyle(
          fontSize: 55,
          foreground: Paint()
            ..shader = ui.Gradient.linear(
              const Offset(0, 0),
              const Offset(600, 100),
              <Color>[Theme_color, const Color.fromARGB(255, 255, 255, 255)],
            ),
        ),
      ),
    ),
  );
}

Widget sloganText() {
  return SizedBox(
    height: 70,
    child: Text(
      "MediCare welcomes you!",
      style: TextStyle(
        color: const Color.fromARGB(255, 93, 93, 93),
        fontSize: 25,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ),
    ),
  );
}

Widget loginCred(var userName, var password) {
  return SizedBox(
    height: 200,
    width: 405,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: TextField(
            cursorHeight: 20,
            cursorColor: Theme_color,
            controller: userName,
            decoration: InputDecoration(
              labelText: "Mail/Phone",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(102, 0, 0, 0),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme_color, width: 3.0),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: TextField(
            cursorHeight: 20,
            obscureText: true,
            cursorColor: Theme_color,
            controller: password,
            decoration: InputDecoration(
              labelText: "Password ",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(102, 0, 0, 0),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme_color, width: 3.0),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget forgotPass() {
  return Padding(
    padding: EdgeInsets.only(right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Forgot password?",
          style: TextStyle(
            fontSize: 19,
            color: const Color.fromARGB(255, 57, 57, 57),
          ),
        ),
      ],
    ),
  );
}

Widget signinButton(var f1, var f2) {
  return SizedBox(
    height: 50,
    child: SizedBox(
      width: 380,
      child: Builder(
        builder: (BuildContext context) {
          return OutlinedButton.icon(
            onPressed: () async {
              String userName = f1.text.trim();
              String password = f2.text.trim();

              if (userName.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Enter all credentials")),
                );
                return;
              }

              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                      email: userName,
                      password: password,
                    );

                String uid = userCredential.user!.uid;

                DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
                    .collection('doctors')
                    .doc(uid)
                    .get();

                if (doctorDoc.exists) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorStateContainer(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                  return;
                }

                DocumentSnapshot patientDoc = await FirebaseFirestore.instance
                    .collection('patients')
                    .doc(uid)
                    .get();

                if (patientDoc.exists) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientMainNavigation(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("User role not found")));
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.message ?? "Login failed")),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            label: Text(
              "Sign in",
              style: TextStyle(fontSize: 24, color: Theme_color),
            ),
            icon: Icon(Icons.login, color: Theme_color),
          );
        },
      ),
    ),
  );
}

Widget googleButton() {
  return Container(
    height: 70,
    padding: EdgeInsets.only(top: 20),
    child: SizedBox(
      width: 380,
      child: OutlinedButton.icon(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 75,
              padding: EdgeInsets.only(left: 35),
              child: Image.asset('assets/googlelogo.png'),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Sign in with Google",
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 59, 59, 59),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget registerButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 40),
    child: Column(
      children: [
        Text(
          "New here?",
          style: TextStyle(
            fontSize: 15,
            color: const Color.fromARGB(255, 55, 55, 55),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const register_page()),
            );
          },
          child: Text(
            "Register",
            style: TextStyle(fontSize: 20, color: Theme_color),
          ),
        ),
      ],
    ),
  );
}

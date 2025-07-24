import 'package:flutter/material.dart';
import 'package:temp/pages/register.dart';
import 'package:temp/main.dart';
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
        // backgroundColor: Color.fromRGBO(254, 254, 254, 100),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                // column container
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Column(
                  // Login page
                  children: [
                    appName(), // name of app
                    sloganText(), // welcome text
                    loginCred(userName, password), // id pass login
                    forgotPass(), // forgot pass button
                    Column(
                      children: [
                        Padding(padding: EdgeInsetsGeometry.only(top: 30)),
                        signinButton(userName, password), // sign in button
                        googleButton(), // sign in with google button
                        registerButton(context), // register button
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
    // App name/logo
    height: 100,
    width: 405,
    // color: const Color.fromARGB(255, 255, 42, 42),
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
    // Slogan text
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
    // color: Colors.red[400],
    width: 405,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(15),
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

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.all(15),
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
    // user id and pass
  );
}

Widget forgotPass() {
  return Container(
    // Forget pass
    width: 450,
    padding: EdgeInsets.only(left: 245),
    height: 40,
    // color: Colors.red[300],
    child: Text(
      "Forgot password?",
      style: TextStyle(
        fontSize: 19,
        color: const Color.fromARGB(255, 57, 57, 57),
      ),
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
            onPressed: () {
              String userName = f1.text.trim();
              String password = f2.text.trim();

              if (userName.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Enter all credentials")),
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
          );
        },
      ),
    ),
  );
}

Widget googleButton() {
  return Container(
    // google sign in button
    // color: Colors.red[200],
    height: 70,
    padding: EdgeInsets.only(top: 20),
    child: SizedBox(
      width: 380,
      child: OutlinedButton.icon(
        onPressed: () {},

        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
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
    // Register button
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

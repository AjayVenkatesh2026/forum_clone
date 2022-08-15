import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forum_clone/screens/login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static String id = "register_screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  String email = "", password = "";
  bool _isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up!"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSigningUp,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Register.",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onChanged: (String newValue) {
                  email = newValue;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                onChanged: (String newValue) {
                  password = newValue;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email);
                  if (_auth.currentUser == null && emailValid) {
                    setState(() {
                      _isSigningUp = true;
                    });
                    try {
                      final newUser = _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser != null) {
                        Navigator.popAndPushNamed(context, HomeScreen.id);
                      }
                    } catch (e) {
                      print("${RegisterScreen.id}: $e");
                    } finally {
                      setState(() {
                        _isSigningUp = false;
                      });
                    }
                    print("$email, $password");
                  }
                },
                child: const Text("Register"),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, LoginScreen.id);
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.solid,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = "login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoggingIn = false;
  String email = "", password = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void checkIfUserSignedIn() {
    final user = _auth.currentUser;
    if (user != null) {
      print("${LoginScreen.id}: User exists");
      Navigator.pushNamed(context, HomeScreen.id);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // checkIfUserSignedIn();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoggingIn,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Log In.",
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
                  setState(() {
                    _isLoggingIn = true;
                  });
                  try {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email);
                    if (emailValid) {
                      final credentials =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                      if (credentials != null) {
                        if (!mounted) return;
                        Navigator.popAndPushNamed(context, HomeScreen.id);
                      }
                    }
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      _isLoggingIn = false;
                    });
                  }
                },
                child: const Text("Login"),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, RegisterScreen.id);
                    },
                    child: const Text(
                      "Sign Up",
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
  }
}

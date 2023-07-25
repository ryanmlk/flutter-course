import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      autocorrect: false,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Password',
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _password,
                    ),
                    TextButton(
                      child: const Text('Register'),
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        createUser(email, password);
                      },
                    ),
                  ],
                ),
              );
            default:
              return const Text('Loading');
          }
        },
      ),
    );
  }

  createUser(email, password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          print("Password not strong enough");
        case 'email-already-in-use':
          print("Email already in use");
        case 'invalid-email':
          print("Invalid email");
      }
    }
  }
}

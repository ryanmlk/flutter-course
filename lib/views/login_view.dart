import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
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
            child: const Text('Login'),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              loginUser(email, password);
            },
          ),
          TextButton(
            child: const Text('Not registered yet? Register now'),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/register/',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  loginUser(email, password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.additionalUserInfo != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/notes/',
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          print('User not found');
          break;
        case 'wrong-password':
          print('Invalid password');
          break;
        default:
          print('Auth Exception: ' + e.code);
      }
    }
  }
}

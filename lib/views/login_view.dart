import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/constants/routes.dart';
import '../utilities/show_error_dialog.dart';

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
                registerRoute,
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (!mounted) return;
      if (user?.emailVerified ?? false) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          notesRoute,
          (route) => false,
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          verifyRoute,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          await showErrorDialog(
            context,
            'User not found',
          );
          break;
        case 'wrong-password':
          await showErrorDialog(
            context,
            'Invalid credentials',
          );
          break;
        default:
          await showErrorDialog(
            context,
            'Authentication Error: ${e.code}',
          );
      }
    } catch (e) {
      await showErrorDialog(
        context,
        'Authentication Error: ${e.toString()}',
      );
    }
  }
}

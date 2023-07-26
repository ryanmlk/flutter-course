import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/constants/routes.dart';
import '../utilities/show_error_dialog.dart';

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
        title: const Text(
          'Register',
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
            child: const Text('Register'),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              createUser(email, password);
            },
          ),
          TextButton(
            child: const Text('Already registered? Login now'),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  createUser(email, password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      user?.sendEmailVerification();
      if (!context.mounted) return;
      Navigator.of(context).pushNamed(verifyRoute);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          await showErrorDialog(
            context,
            'Password not strong enough',
          );
          break;
        case 'email-already-in-use':
          await showErrorDialog(
            context,
            'Email is already in use',
          );
          break;
        case 'invalid-email':
          await showErrorDialog(
            context,
            'Invalid Email',
          );
          break;
        default:
          await showErrorDialog(
            context,
            'Registration Error: ${e.code}',
          );
      }
    } catch (e) {
      await showErrorDialog(
        context,
        'Registration error: ${e.toString()}',
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_course/constants/routes.dart';
import 'package:flutter_course/services/auth/auth_exceptions.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/utilities/dialogs/error_dialog.dart';

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
              createUser(email, password, context);
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

  createUser(email, password, context) async {
    try {
      await AuthService.firebase().createUser(
        email: email,
        password: password,
      );
      AuthService.firebase().sendEmailVerification();
      if (!context.mounted) return;
      Navigator.of(context).pushNamed(verifyRoute);
    } on WeakPasswordAuthException {
      await showErrorDialog(
        context,
        'Password not strong enough',
      );
    } on EmailAlreadyInUseAuthException {
      await showErrorDialog(
        context,
        'Email is already in use',
      );
    } on InvalidEmailAuthException {
      await showErrorDialog(
        context,
        'Invalid Email',
      );
    } on GenericAuthException {
      await showErrorDialog(
        context,
        'Failed to register',
      );
    }
  }
}

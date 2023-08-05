import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/constants/routes.dart';
import 'package:flutter_course/services/auth/auth_exceptions.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/services/auth/bloc/auth_event.dart';
import 'package:flutter_course/services/auth/bloc/auth_state.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
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
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  createUser(email, password, context) async {
    context.read<AuthBloc>().add(
          AuthEventRegister(
            email,
            password,
          ),
        );
  }
}

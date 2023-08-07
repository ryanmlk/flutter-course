import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/extensions/buildcontext/loc.dart';
import 'package:flutter_course/services/auth/auth_exceptions.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/services/auth/bloc/auth_event.dart';
import 'package:flutter_course/services/auth/bloc/auth_state.dart';
import 'package:flutter_course/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.loc.my_title,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Please log into your account in order to interact with and create notes!'),
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
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {},
                child: TextButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    loginUser(email, password);
                  },
                ),
              ),
              TextButton(
                child: const Text('I forgot my password'),
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                },
              ),
              TextButton(
                child: const Text('Not registered yet? Register now'),
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginUser(email, password) async {
    context.read<AuthBloc>().add(
          AuthEventLogIn(
            email,
            password,
          ),
        );
  }
}

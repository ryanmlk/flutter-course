import 'package:flutter/material.dart';
import 'package:flutter_course/constants/routes.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/views/notes/new_note_view.dart';
import 'package:flutter_course/views/notes/notes_view.dart';
import 'package:flutter_course/views/login_view.dart';
import 'package:flutter_course/views/register_view.dart';
import 'package:flutter_course/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  devtools.log('Test');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyRoute: (context) => const VerifyEmailView(),
      notesRoute: (context) => const NotesView(),
      newNoteRoute: (context) => const NewNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

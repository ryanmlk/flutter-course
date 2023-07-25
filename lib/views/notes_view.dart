import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          const Text('You are signed in'),
          TextButton(
            onPressed: () {
              signOutUser();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                (route) => false,
              );
            },
            child: const Text('Sign Out'),
          )
        ],
      ),
    );
  }

  signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}

import 'package:batch10auth/data/auth_repository.dart';
import 'package:batch10auth/features/auth/presentation/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  //final DatabaseRepository db;
  final AuthRepository auth;
  // Konstruktor
  const App(this.auth, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        
        //print(snapshot.data);
        //snapshot.data?.reload();
        final User? currentUser = snapshot.data;
        return MaterialApp(
          key: Key((snapshot.data?.uid ?? 'no_user_id')),
          home: currentUser != null ? Placeholder() : SignupScreen(auth: auth),
        );
      },
    );
  }
}

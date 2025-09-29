import 'package:batch10auth/data/auth_repository.dart';
import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/features/auth/presentation/sign_up_screen.dart';
import 'package:batch10auth/features/restaurant/presentation/restaurant_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  //final DatabaseRepository db;
  final AuthRepository auth;
  final DatabaseRepository db;
  // Konstruktor
  const App(this.auth, {super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        final User? currentUser = snapshot.data;
        return MaterialApp(
          key: Key((snapshot.data?.uid ?? 'no_user_id')),
          home: currentUser != null
              ? RestaurantsPage(db: db)
              : SignupScreen(auth: auth,db: db,),
        );
      },
    );
  }
}

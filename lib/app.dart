import 'package:batch10auth/data/auth_repository.dart';
import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/features/auth/presentation/sign_up_screen.dart';
import 'package:batch10auth/features/restaurant/presentation/restaurant_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  //final DatabaseRepository db;

  // Konstruktor
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    AuthRepository auth = context.read<AuthRepository>();
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        final User? currentUser = snapshot.data;
        return MaterialApp(
          key: Key((snapshot.data?.uid ?? 'no_user_id')),
          home: currentUser != null
              ? RestaurantsPage()
              : SignupScreen(),
        );
      },
    );
  }
}

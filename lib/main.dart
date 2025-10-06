import 'package:batch10auth/app.dart';
import 'package:batch10auth/data/auth_repository.dart';
import 'package:batch10auth/data/database_repository.dart';
import 'package:batch10auth/data/firebase_auth_repository.dart';
import 'package:batch10auth/data/firestore_repository.dart';
import 'package:batch10auth/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final AuthRepository auth = FirebaseAuthRepository();
  final DatabaseRepository db = FirestoreRepository();

  runApp(MultiProvider(providers: [
    Provider(create: (_)=> auth),
    Provider(create: (_)=> db),

  ],
  child: App(),));
}

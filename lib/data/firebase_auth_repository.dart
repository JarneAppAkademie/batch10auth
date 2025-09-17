import 'package:batch10auth/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepository implements AuthRepository {
  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();
    
  }

  @override
  Stream<User?> authStateChanges() {
    
    return FirebaseAuth.instance.authStateChanges();
  }

  @override
  Stream<User?> idtokenChanges() {
    return FirebaseAuth.instance.idTokenChanges();
  }

  @override
  Future<String?> signInWithGoogle() async {
    try {
      // Kann nötig sein wenn Authenticationflow nicht auftaucht, Müsst ihr mal ausprobieren
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      return "Google-Fehler: $e";
    }
    return null;
  }
}

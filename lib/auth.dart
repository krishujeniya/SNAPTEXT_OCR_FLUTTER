// ignore_for_file: file_names, duplicate_ignore
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
        
      );
      User? user = userCredential.user;
      return user;
    } catch (error) {
      // ignore: avoid_print
      print("Error registering user: $error");
      return null;
    }
  }

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user;
    } catch (error) {
      // ignore: avoid_print
      print("Error signing in: $error");
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      // ignore: avoid_print
      print("Error signing out: $error");
    }
  }

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  Future resetPassword(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      // ignore: avoid_print
      print("Error signing out: $error");
    }
  }
 
}
 

final AuthService authService = AuthService();


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthProvider with ChangeNotifier {
  firebase_auth.User? _user;

  firebase_auth.User? get user => _user;

  AuthProvider() {
    firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      _user = firebaseUser;
      notifyListeners();
    });
  }

  Future<void> register({required String email, required String password}) async {
    try {
      final credential = await firebase_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user;
      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final credential = await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user;
      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    await firebase_auth.FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    try {
      await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent to $email');
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to send password reset email.');
    }
  }

  Future<void> signInWithGoogle() async {
    // TODO: Implement actual Google Sign-In logic here using Firebase Auth and Google Sign-In plugin
    debugPrint("Google Sign-In not implemented yet.");
  }

  Future<void> signInWithFacebook() async {
    // TODO: Implement actual Facebook Sign-In logic here using Firebase Auth and Facebook Login plugin
    debugPrint("Facebook Sign-In not implemented yet.");
  }
}

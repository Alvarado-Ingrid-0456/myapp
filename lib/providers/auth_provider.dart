import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Assuming Firebase Auth is used

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
    } else {
      _user = firebaseUser;
      // You might want to fetch additional user data from Firestore here
    }
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    try {
      // Create user with email and password
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user's display name
      await credential.user?.updateDisplayName(name);

      // Refresh user object to get the updated display name
      await credential.user?.reload();
      _user = _firebaseAuth.currentUser;

      // Optional: Store additional user data in Firestore
      // await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
      //   'name': name,
      //   'email': email,
      //   'createdAt': FieldValue.serverTimestamp(),
      // });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth exceptions
      throw Exception(e.message ?? 'Registration failed. Please try again.');
    } catch (e) {
      // Handle other potential errors
      throw Exception('An unexpected error occurred during registration.');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = _firebaseAuth.currentUser;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(
          e.message ?? 'Login failed. Please check your credentials.');
    } catch (e) {
      throw Exception('An unexpected error occurred during login.');
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Logout failed. Please try again.');
    }
  }

  // Method to check if the user is logged in
  bool isAuthenticated() {
    return _user != null;
  }
}

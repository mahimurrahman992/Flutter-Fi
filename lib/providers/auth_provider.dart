import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthProviders with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userRole;  // To store the role of the logged-in user.

  // Getter to access the userRole
  String? get userRole => _userRole;

  // Method to log in a user
  Future<String?> login(String email, String password) async {
    try {
      // Sign in the user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve the user's role from Firestore
      String role = await getUserRole(userCredential.user!.uid);
      _userRole = role;  // Set the user's role

      notifyListeners(); // Notify listeners about the role change
      return role; // Return the role (admin or user)
    } on FirebaseAuthException catch (e) {
      return e.message; // Return the error message for display
    }
  }

  // Fetch user role from Firestore
  Future<String> getUserRole(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc['role'];  // Get role from Firestore
  }

  // Method to log out the user
  Future<void> logout() async {
    await _auth.signOut();
    _userRole = null; // Clear the role on logout
    notifyListeners(); // Notify listeners to update the UI
  }

  // Get current authenticated user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password);
        User? user = result.user;

        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        return user;
      } catch (e) {
        print("Error signing up: $e");
        return null;
      }
    }
  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return result.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> getCurrentUserinstance() async{
    return _auth.currentUser;
  }

}
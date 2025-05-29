import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listify/core/Models/UserModel.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Synchronous getter for current user
  User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      User? user = result.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': username, 
          'createdAt': FieldValue.serverTimestamp(),
          'provider': 'email'
        });

        // Create default "My List" in ListifyLists
        await FirebaseFirestore.instance.collection('ListifyLists').add({
          'name': 'My List',
          'ownerId': user.uid,
          'members': [
            {
              'role': 'owner',
              'userId': user.uid,
            }
          ],
        });

        // Optionally update displayName in FirebaseAuth profile
        await user.updateDisplayName(username);

        // Send email verification
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        // Immediately sign out so user can't access app until verified
        await _auth.signOut();
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
      User? user = result.user;

      // Check if email is verified
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification(); // Optionally resend
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email before signing in.',
        );
      }

      return user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Create user document if not exists
      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          await userDoc.set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'provider': 'google',
          });

          // Create default "My List" in ListifyLists
          await FirebaseFirestore.instance.collection('ListifyLists').add({
            'name': 'My List',
            'ownerId': user.uid,
            'members': [
              {
                'role': 'owner',
                'userId': user.uid,
              }
            ],
          });
        }
      }

      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // Resend email verification
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut(); 
  }

  Future<User?> getCurrentUserinstance() async{
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;
    return {
      'email': data['email'] ?? '',
      'displayName': data['displayName'] ?? '',
      'photoURL': data['photoURL'] ?? '',
    };
  }

  Future<UserModel?> getUserById(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!);
  }

}
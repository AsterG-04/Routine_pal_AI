import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  Future<bool> isNewUser(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return false; // No data, treat as new user

    final data = doc.data();
    // Check for required fields
    if (data == null || data['name'] == null || data['email'] == null) {
      return false; // Missing required data, treat as new user
    }
    return true; // User has data
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error during user creation: $e');
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Error during password reset: $e');
    }
  }

  Future<void> updateProfile(String displayName, String photoURL) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateProfile(displayName: displayName, photoURL: photoURL);
        await user.reload();
      } on FirebaseAuthException catch (e) {
        print('Error during profile update: $e');
      }
    }
  }

  Future<void> deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete();
      } on FirebaseAuthException catch (e) {
        print('Error during user deletion: $e');
      }
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      await googleSignIn.signOut(); // Always show account picker
      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (e is GoogleSignInException &&
          e.code == GoogleSignInExceptionCode.canceled) {
        // User cancelled, show a message or ignore
      } else {
        // Handle other errors
        print('Error during Google sign in: $e');
      }
    }
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

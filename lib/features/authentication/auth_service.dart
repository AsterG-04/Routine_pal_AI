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
    if (data != null) {
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

Future<UserCredential> signInWithGoogle() async {
  final googleSignIn = GoogleSignIn.instance;
  await googleSignIn.initialize();
  try {
    final googleUser = await googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      print('Google sign-in canceled by user.');
    } else {
      print('Google sign-in error: $e');
    }
    rethrow; // Rethrow the exception if not handled
  }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

Future<UserCredential> signInWithEmail(String email, String password) {
  return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
}

Future<UserCredential?> signInWithGoogle() async {
  try {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();
    final googleUser = await googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      print('Google sign-in canceled by user.');
      return null;
    } else {
      print('Google sign-in error: $e');
      return null;
    }
  } catch (e) {
    print('Unexpected error during Google sign-in: $e');
    return null;
  }
}



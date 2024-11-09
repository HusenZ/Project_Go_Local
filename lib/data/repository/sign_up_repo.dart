import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpApi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);

      return true;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addUser({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      final uid = auth.currentUser!.uid;

      await _firestore.collection('Users').doc(uid).set({
        'userId': uid,
        'name': name,
        'email': email,
        'phone': '+91 $phone',
      });

      // Return true to indicate success

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding user: $e');
      }

      // Return false to indicate failure
      return false;
    }
  }

  static Future<bool> addUserEmailPass({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: '1er3t4y5u67');
      if (_auth.currentUser == null) {
        return false;
      } else {
        try {
          final FirebaseAuth auth = FirebaseAuth.instance;

          final uid = auth.currentUser!.uid;

          await _firestore.collection('Users').doc(uid).set({
            'userId': uid,
            'name': name,
            'email': email,
            'phone': '+91 $phone',
          });

          // Return true to indicate success

          return true;
        } catch (e) {
          // Return false to indicate failure
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
    } catch (e) {
      return false;
    }
    return false;
  }
}

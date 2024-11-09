import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationApi {
  static Future<bool> emailExists(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();

    bool exists = querySnapshot.docs.isNotEmpty;
    debugPrint("exists value is $exists");
    debugPrint("email is $email");
    return exists;
  }

  static Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('phone', isEqualTo: phoneNumber)
        .get();

    bool exists = querySnapshot.docs.isNotEmpty;
    debugPrint("exists value is $exists");
    debugPrint("phone no value is $phoneNumber");

    return exists;
  }

  Future<bool> signInWithVerificationCode(
      String verificationId, String smsCode) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }
}

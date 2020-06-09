import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import '../screens/HomeScreen.dart';
import '../screens/AuthScreen.dart';

class FirebaseAuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUpWithEmail(BuildContext context, String email,
      String password, String confirmPassword, Function switchLoading) async {
    switchLoading();
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill up all the fields.");
      switchLoading();
      return;
    }
    if (!EmailValidator.validate(email)) {
      Fluttertoast.showToast(msg: "Please enter a valid email address.");
      switchLoading();
      return;
    }
    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: "Passwords do not match.");
      switchLoading();
      return;
    }
    if (password.length < 6) {
      Fluttertoast.showToast(
          msg: "Password must be atleast 6 characters long.");
      switchLoading();
      return;
    }
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      user.sendEmailVerification();
      print(user.uid);
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } on PlatformException catch (e) {
      switchLoading();
      switchLoading();
      print(e.code);
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          Fluttertoast.showToast(
              msg: "This email is linked to an existing account");
          break;
        default:
          switchLoading();
          Fluttertoast.showToast(msg: "Registration Problem!");
      }
    } catch (e) {
      print(e);
      switchLoading();
    }
    switchLoading();
  }

  Future<void> signInWithEmail(BuildContext context, String email,
      String password, Function switchLoading) async {
    switchLoading();
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill up all the fields.");
      switchLoading();
      return;
    }
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(result.user.email);
      switchLoading();
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } on PlatformException catch (e) {
      print(e.code);
      switchLoading();
      switch (e.code) {
        case 'ERROR_WRONG_PASSWORD':
          Fluttertoast.showToast(msg: "Wrong Password!");
          break;
        case 'ERROR_USER_NOT_FOUND':
          Fluttertoast.showToast(
              msg: "This email is not linked to any account!");
          break;
        default:
          Fluttertoast.showToast(msg: "Authentication Problem!");
      }
    } catch (e) {
      print(e);
      switchLoading();
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AuthScreen.routeName, (_) => false);
  }

  void sendVerificationMail() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      user.sendEmailVerification();
      Fluttertoast.showToast(msg: "Email sent!");
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error sending email! Try later!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_form/screens/biometricAuth/auth_screen.dart';
import 'package:services_form/screens/loginAuth/login.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return FingerprintAuth();
    }
    return LoginAuth();
  }
}

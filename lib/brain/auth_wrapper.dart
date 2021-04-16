import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_form/screens/biometricAuth/auth_screen.dart';
import 'package:services_form/screens/home/home_screen.dart';
import 'package:services_form/screens/loginAuth/login.dart';
import 'package:services_form/brain/setting_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _checkBio = false;

  _checkBioAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkBio = prefs.getBool('passwordStart') ?? true;

    Provider.of<SettingsProvider>(context, listen: false).checkSave();
  }

  @override
  void initState() {
    _checkBioAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return _checkBio ? FingerprintAuth() : HomeScreen();
    }
    return LoginAuth();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services_form/screens/biometricAuth/local_auth_api.dart';
import 'package:services_form/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:services_form/brain/setting_provider.dart';

class FingerprintAuth extends StatefulWidget {
  @override
  _FingerprintAuthState createState() => _FingerprintAuthState();
}

class _FingerprintAuthState extends State<FingerprintAuth> {
  bool _checkAuth;
  bool _biometric;

  checkAuthorise() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkAuth = prefs.getBool('passwordStart') ?? true;
    _biometric = prefs.getBool('biometric') ?? false;
    Provider.of<SettingsProvider>(context, listen: false).checkSave();
    print(_biometric);
    if (_checkAuth == true) {
      _launchFingerPrint();
    } else if (_checkAuth == false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  _launchFingerPrint() async {
    final isAuth = await LocalAuthApi.authenticate();
    if (isAuth) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    checkAuthorise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.blueGrey));
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _launchFingerPrint();
                },
                child: Icon(
                  Icons.fingerprint,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  'Selamat datang tuan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Sila masukkan kata laluan dulu yer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

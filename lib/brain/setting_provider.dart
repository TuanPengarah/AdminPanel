import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool passwordStart;
  bool biometric;

  saveBoolPass(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    passwordStart = prefs.getBool('passwordStart') ?? true;
    passwordStart = value;
    await prefs.setBool('passwordStart', passwordStart);
    notifyListeners();
  }

  saveBoolBio(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    biometric = prefs.getBool('biometric') ?? false;
    biometric = value;
    await prefs.setBool('biometric', biometric);
    notifyListeners();
  }

  checkSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (passwordStart == null)
      passwordStart = prefs.getBool('passwordStart') ?? true;
    if (biometric == null) biometric = prefs.getBool('biometric') ?? false;

    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';

class CheckLock with ChangeNotifier {
  bool setLock = true;
// CheckLock({this.setLock})

  void pressLock(bool isLock) {
    if (isLock == true) {
      setLock = false;
      notifyListeners();
    } else {
      setLock = true;
      notifyListeners();
    }
  }
}

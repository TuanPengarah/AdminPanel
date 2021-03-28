import 'package:flutter/foundation.dart';

class BalanceProvider extends ChangeNotifier {
  int jumlah = 0;

  void tambahJumlah(int tambah) {
    jumlah += tambah;
    notifyListeners();
  }
}

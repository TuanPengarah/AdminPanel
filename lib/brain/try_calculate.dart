import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:services_form/brain/sqlite_services.dart';
import 'balance_provider.dart';

void tryCalculate(BuildContext context) async {
  int _total = 0;
  List priceList;
  Provider.of<BalanceProvider>(context, listen: false).jumlah = 0;
  priceList = await DBProvider.db.calculateTotal();
  priceList.forEach((price) {
    _total = _total + price[DBProvider.columnPrice];
  });
  print(_total);
  Provider.of<BalanceProvider>(context, listen: false).tambahJumlah(_total);
}

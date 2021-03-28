import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:services_form/brain/check_lock.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/widget/bottom_unlock.dart';
import 'package:services_form/widget/cashflow_appbar.dart';
import 'package:services_form/widget/cashflow_bankcard.dart';
import 'package:services_form/widget/cashflow_glance.dart';
import 'package:services_form/widget/cashflow_moreaction.dart';
import 'package:services_form/widget/cashflow_transaction_appbar.dart';
import 'package:services_form/brain/balance_provider.dart';
import 'package:services_form/brain/try_calculate.dart';

class CashFlowHome extends StatefulWidget {
  @override
  _CashFlowHomeState createState() => _CashFlowHomeState();
}

class _CashFlowHomeState extends State<CashFlowHome> with AfterLayoutMixin {
  BalanceProvider _appProvider;
  String upload;

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('database/CashFlow.db')
          .putFile(file);
    } catch (e) {
      print(e);
      // e.g, e.code == 'canceled'
    }
  }

  Future<void> downloadFileExample() async {
    File downloadToFile = File(kcfLocation);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('database/CashFlow.db')
          .writeToFile(downloadToFile);
    } catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  @override
  void initState() {
    super.initState();
    tryCalculate(context);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _appProvider = Provider.of<BalanceProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _appProvider.jumlah = 0;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.blueGrey,
        systemNavigationBarIconBrightness: Brightness.light));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool pLock = Provider.of<CheckLock>(context).setLock;

    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            isDarkMode == true ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            isDarkMode == true ? Brightness.light : Brightness.dark,
        statusBarIconBrightness:
            isDarkMode == true ? Brightness.light : Brightness.dark));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarCashFlow(isDarkMode: isDarkMode),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  print(upload);
                  uploadFile(kcfLocation);
                },
                child: BankCard(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MoreAction(
                    isDarkMode: isDarkMode,
                    icon: Icons.copy,
                    title: 'Salin',
                  ),
                  MoreAction(
                    isDarkMode: isDarkMode,
                    icon: Icons.add,
                    title: 'Transaksi',
                    click: () {
                      downloadFileExample();
                    },
                  ),
                  MoreAction(
                    isDarkMode: isDarkMode,
                    icon: pLock == true
                        ? Icons.lock_outline
                        : Icons.lock_open_outlined,
                    title: pLock == true ? 'Buka Kunci' : 'Kunci Semula',
                    click: () {
                      print(pLock);
                      setState(() {
                        pLock == true
                            ? unlockCode(context)
                            : Provider.of<CheckLock>(context, listen: false)
                                .setLock = true;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TransactionHistoryAppBar(isDarkMode: isDarkMode),
              CashFlowTransactionGlance(isDarkMode: isDarkMode),
            ],
          ),
        ),
      ),
    );
  }
}

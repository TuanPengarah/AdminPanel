import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:services_form/brain/check_lock.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/screens/biometricAuth/local_auth_api.dart';
import 'package:services_form/widget/bottom_unlock.dart';
import 'package:services_form/widget/buttom_add_transaction.dart';
import 'package:services_form/widget/cashflow_bankcard.dart';
import 'package:services_form/widget/cashflow_glance.dart';
import 'package:services_form/widget/cashflow_moreaction.dart';
import 'package:services_form/brain/balance_provider.dart';
import 'package:services_form/brain/try_calculate.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashFlowHome extends StatefulWidget {
  @override
  _CashFlowHomeState createState() => _CashFlowHomeState();
}

class _CashFlowHomeState extends State<CashFlowHome> with AfterLayoutMixin {
  GlobalKey<RefreshIndicatorState> refreshKey;
  BalanceProvider _appProvider;
  String upload;
  bool adaUpdate = false;
  bool _checkBio;

  void _checkBioMetric() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkBio = prefs.getBool('biometric');
  }

  _launchFingerPrint(BuildContext context) async {
    final isAuth = await LocalAuthApi.authenticate();
    if (isAuth) {
      setState(() {
        Provider.of<CheckLock>(context, listen: false).setLock = false;
      });
    }
  }

  @override
  void initState() {
    _checkBioMetric();
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
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

  Future<void> refreshAll() async {
    tryCalculate(context);
    await Future.delayed(Duration(seconds: 1));

    setState(() {});
  }

  void refreshAfterAdd(BuildContext context) async {
    final bool result = await addTransaction(context, adaUpdate);
    print(result);
    if (result == true) {
      setState(() {});
      adaUpdate = false;
    }
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
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: isDarkMode == false ? kCompColor : Colors.white),
        elevation: 0,
        brightness: isDarkMode == false ? Brightness.light : Brightness.dark,
        backgroundColor: isDarkMode == false ? Colors.white : Colors.black,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'C-Flow',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: isDarkMode == false ? kCompColor : Colors.white,
              ),
            ),
            Text(
              'Kajang/Bangi',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: () async {
            await refreshAll();
          },
          child: SingleChildScrollView(
            physics: new BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  // AppBarCashFlow(isDarkMode: isDarkMode),
                  SizedBox(
                    height: 20,
                  ),
                  BankCard(),
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
                        click: () {
                          Share.share(
                              'ASSAFF ENTERPRISE\n562021651202\nMaybank');
                        },
                      ),
                      MoreAction(
                        isDarkMode: isDarkMode,
                        icon: Icons.add,
                        title: 'Transaksi',
                        click: () {
                          refreshAfterAdd(context);
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

                          if (pLock == true) {
                            print(_checkBio);
                            _checkBio == true
                                ? _launchFingerPrint(context)
                                : unlockCode(context);
                          } else if (pLock == false) {
                            setState(() {
                              Provider.of<CheckLock>(context, listen: false)
                                  .setLock = true;
                            });
                          }
                          // setState(() {
                          //   pLock == true
                          //       ? unlockCode(context)
                          //       : Provider.of<CheckLock>(context, listen: false)
                          //           .setLock = true;
                          // });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Transaksi',
                          style: TextStyle(
                            color:
                                isDarkMode == false ? kCompColor : Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, 'alltransaction')
                                  .then((value) {
                                tryCalculate(context);
                                setState(() {});
                              });
                            },
                            child: Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: isDarkMode == false
                                    ? kCompColor
                                    : Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CashFlowTransactionGlance(isDarkMode: isDarkMode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

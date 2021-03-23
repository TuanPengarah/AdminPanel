import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services_form/screens/spareparts/add_sparepart.dart';
import 'package:services_form/screens/customer/all_customer.dart';
import 'package:services_form/screens/home/home_screen.dart';
import 'package:services_form/screens/spareparts/inventory.dart';
import 'package:services_form/screens/jobsheet/job_sheet.dart';
import 'package:services_form/screens/payment/sales_pending_payment.dart';
import 'package:sizer/sizer.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:oktoast/oktoast.dart';
import 'screens/pendingjob/pending_job.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // systemNavigationBarColor:
    //     Colors.blueGrey,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;

  const MyApp({Key key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(
          //return OrientationBuilder
          builder: (context, orientation) {
            SizerUtil().init(constraints, orientation); //initialize SizerUtil
            return AdaptiveTheme(
                light: ThemeData(
                    brightness: Brightness.light,
                    primarySwatch: Colors.blueGrey,
                    accentColor: Colors.blueGrey,
                    colorScheme: ColorScheme.light(primary: Colors.black),
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                        backgroundColor: Colors.blueGrey)),
                dark: ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.blueGrey,
                    accentColor: Colors.blueGrey,
                    colorScheme: ColorScheme.dark(primary: Colors.white),
                    scaffoldBackgroundColor: Colors.black87,
                    appBarTheme: AppBarTheme(color: Colors.blueGrey),
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                        backgroundColor: Colors.blueGrey)),
                initial: savedThemeMode ?? AdaptiveThemeMode.system,
                builder: (theme, darkTheme) => OKToast(
                      child: MaterialApp(
                        theme: theme,
                        darkTheme: darkTheme,
                        debugShowCheckedModeBanner: false,
                        initialRoute: 'homescreen',
                        routes: {
                          'homescreen': (context) => HomeScreen(),
                          'jobsheet': (context) => JobSheet(),
                          'allcustomer': (context) => CustomerDatabase(),
                          'addsparepart': (context) => AddSparepart(),
                          'pendingjob': (context) => PendingJob(),
                          'inventory': (context) => Inventory(),
                          'sales': (context) => SalesPendingPayments(),
                        },
                      ),
                    ));
          },
        );
      },
    );
  }
}

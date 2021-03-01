import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:services_form/screens/add_sparepart.dart';
import 'package:services_form/screens/all_customer.dart';
import 'package:services_form/screens/home_screen.dart';
import 'package:services_form/screens/job_sheet.dart';
import 'package:sizer/sizer.dart';
import 'screens/print.dart';
import 'screens/spareparts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // GestureBinding.instance.resamplingEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(
          //return OrientationBuilder
          builder: (context, orientation) {
            SizerUtil().init(constraints, orientation); //initialize SizerUtil
            return MaterialApp(
              theme: ThemeData(
                  primaryColor: Colors.blueGrey, accentColor: Colors.blueGrey),
              debugShowCheckedModeBanner: false,
              initialRoute: 'homescreen',
              routes: {
                'print': (context) => Print(),
                'homescreen': (context) => HomeScreen(),
                'jobsheet': (context) => JobSheet(),
                'spareparts': (context) => DatabaseSpareparts(),
                'allcustomer': (context) => CustomerDatabase(),
                'addsparepart': (context) => AddSparepart(),
              },
            );
          },
        );
      },
    );
  }
}

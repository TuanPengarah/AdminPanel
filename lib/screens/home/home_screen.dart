import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:services_form/widget/button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:services_form/brain/sqlite_services.dart';

class HomeScreen extends StatelessWidget {
  //generate untuk tarikh baru (Device Time)
  tarikh() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy | hh:mm a');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    CashFlow cashflow;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.blueGrey));
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: EdgeInsets.only(left: 1.0.h, right: 1.0.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 0.1.h, vertical: 5.0.h),
                child: InkWell(
                  onTap: () {
                    if (cashflow == null) {
                      CashFlow cf = CashFlow(
                          dahBayar: 0,
                          price: -15,
                          spareparts: ' LITE',
                          tarikh: tarikh().toString());
                      DBProvider.db.insert(cf).then((id) => {
                            print('tambah '
                                'ke database $id')
                          });
                    }
                  },
                  child: Image.asset(
                    'assets/logo.png',
                    scale: 4.8,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0.h,
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    // Map<String, dynamic> toMap = {
                    //   DBProvider.columnName: 'NOVA 2I',
                    //   DBProvider.columnPrice: 90
                    // };
                    // int i = await DBProvider.db.insert(toMap);
                    // print('the insert id is $i');
                  },
                  child: Lottie.asset('lottie/cc.json', height: 30.0.h),
                ),
              ),
              SizedBox(height: 5.0.h),
              Center(
                child: AutoSizeText(
                  'Af-Fix Admin',
                  wrapWords: false,
                  maxLines: 1,
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 1.0.h,
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 9),
                child: AutoSizeText(
                  'Portal untuk memasukkan segala maklumat ke pangkalan data syarikat. Kegunaan staff Af-fix je!',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0.h,
              ),
              Button()
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:services_form/widget/button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                child: Image.asset(
                  'assets/logo.png',
                  scale: 4.8,
                ),
              ),
              SizedBox(
                height: 5.0.h,
              ),
              Center(
                child: Lottie.asset('lottie/cc.json', height: 30.0.h),
              ),
              SizedBox(height: 5.0.h),
              AutoSizeText(
                '//MyDatabase_',
                wrapWords: false,
                maxLines: 1,
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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

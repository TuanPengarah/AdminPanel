import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services_form/screens/setting/savecloud_confirmation.dart';
import 'package:services_form/widget/button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:services_form/brain/quick_action.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final quickAction = QuickActions();

  void initQuickAction() {
    quickAction.initialize(
      (type) {
        if (type == null) {
          return;
        }
        if (type == ShortcutItems.actionJobsheet.type) {
          Navigator.pushReplacementNamed(context, 'jobsheet');
        }
        if (type == ShortcutItems.actionAllSpareparts.type) {
          Navigator.pushReplacementNamed(context, 'inventory');
        }
        if (type == ShortcutItems.actionPOS.type) {
          Navigator.pushReplacementNamed(context, 'sales');
        }
        if (type == ShortcutItems.actionBackup.type) {
          saveDBToCloud(context);
        }
      },
    );
    quickAction.setShortcutItems(ShortcutItems.items);
  }

  @override
  void initState() {
    initQuickAction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.blueGrey,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 1.0.h, right: 1.0.h),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.1.h, vertical: 2.0.h),
                      child: Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'assets/splash_light.png',
                          scale: 8,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Future.delayed(const Duration(milliseconds: 190), () {
                          Navigator.pushNamed(context, 'setting');
                        });
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0.h,
                ),
                Center(
                  child: Lottie.asset('lottie/cc.json', height: 30.0.h),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services_form/widget/text_bar.dart';

class LoginAuth extends StatefulWidget {
  @override
  _LoginAuthState createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor:
              isDarkMode ? Color(0xff212121) : Colors.white,
          systemNavigationBarIconBrightness:
              isDarkMode == true ? Brightness.light : Brightness.dark,
          statusBarIconBrightness:
              isDarkMode == true ? Brightness.light : Brightness.dark),
    );
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xff212121) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                isDarkMode ? 'assets/logo.png' : 'assets/logoBlack.png',
                scale: 3.5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  TextBar(
                    hintTitle: 'Email',
                    valueChange: (newValue) {},
                    keyType: TextInputType.emailAddress,
                    focus: false,
                  ),
                  TextBar(
                    hintTitle: 'Kata laluan',
                    valueChange: (newValue) {},
                    keyType: TextInputType.emailAddress,
                    focus: false,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('Mari Menuju Kejayaan ->'),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

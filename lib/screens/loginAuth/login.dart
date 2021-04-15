import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:services_form/brain/auth_services.dart';
import 'package:services_form/widget/text_bar.dart';
import 'package:provider/provider.dart';

class LoginAuth extends StatefulWidget {
  @override
  _LoginAuthState createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                    controll: _emailController,
                    hintTitle: 'Email',
                    valueChange: (newValue) {},
                    keyType: TextInputType.emailAddress,
                    focus: false,
                  ),
                  TextBar(
                    controll: _passwordController,
                    hintTitle: 'Kata laluan',
                    valueChange: (newValue) {},
                    keyType: TextInputType.emailAddress,
                    focus: false,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await context.read<AuthenticationService>().signIn(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                          showToast(Provider.of<AuthenticationService>(context,
                                  listen: false)
                              .error);
                        },
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

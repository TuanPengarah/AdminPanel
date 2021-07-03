import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:services_form/brain/auth_services.dart';
import 'package:services_form/widget/text_bar.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginAuth extends StatefulWidget {
  @override
  _LoginAuthState createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obsecureText = false;
  bool _loading = false;

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
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      isDarkMode ? 'assets/logo.png' : 'assets/logoBlack.png',
                      scale: 3.5,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  TextBar(
                    password: false,
                    controll: _emailController,
                    hintTitle: 'Email',
                    valueChange: (newValue) {},
                    keyType: TextInputType.emailAddress,
                    focus: false,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextBar(
                          max: 1,
                          password: _obsecureText,
                          controll: _passwordController,
                          hintTitle: 'Kata laluan',
                          valueChange: (newValue) {},
                          keyType: TextInputType.visiblePassword,
                          focus: false,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(_obsecureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obsecureText = !_obsecureText;
                            });
                            print(_obsecureText);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });
                          await context.read<AuthenticationService>().signIn(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                          showToast(Provider.of<AuthenticationService>(context,
                                  listen: false)
                              .error);

                          setState(() {
                            _loading = false;
                          });
                        },
                        child: Text('Mari Menuju Kejayaan ->'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

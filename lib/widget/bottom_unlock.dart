import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:services_form/brain/check_lock.dart';
import 'package:vibration/vibration.dart';

unlockCode(context) {
  final _pinController = TextEditingController();
  const password = '6421';
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext c) {
      return Wrap(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Buka Kunci',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: PinPut(
                    onSubmit: (String pwd) {
                      if (password == pwd) {
                        Navigator.pop(context);
                        Provider.of<CheckLock>(context, listen: false).setLock =
                            false;
                      } else {
                        _pinController.clear();
                        showToast('Password Salah');
                        Vibration.vibrate(pattern: [100, 30, 100, 30]);
                      }
                    },
                    fieldsCount: 4,
                    controller: _pinController,
                    autofocus: true,
                    submittedFieldDecoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    selectedFieldDecoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    followingFieldDecoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    },
  );
}

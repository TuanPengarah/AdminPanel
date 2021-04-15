import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:services_form/brain/constant.dart';
import 'package:oktoast/oktoast.dart';

Future<void> _download() async {
  File downloadToFile = File(kcfLocation);

  try {
    await firebase_storage.FirebaseStorage.instance
        .ref('database/Af-fix.db')
        .writeToFile(downloadToFile);
  } on firebase_storage.FirebaseException catch (e) {
    print('print $e');
  }
}

downloadDBInCloud(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(
      "Batal",
      style: TextStyle(color: Colors.red),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text('MuatTurun'),
    onPressed: () async {
      await _download();
      showToast('Berjaya di muat turun dari storan awan',
          position: ToastPosition.bottom);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Muat turun dari storan awan'),
    content: Text('AMARAN: Segala data SQlite dalam peranti ini akan di ganti'
        ' daripada storan awan!'),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

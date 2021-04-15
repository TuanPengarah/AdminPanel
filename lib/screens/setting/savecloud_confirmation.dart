import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:services_form/brain/constant.dart';
import 'package:oktoast/oktoast.dart';

Future<void> _uploadFile(String filePath, BuildContext context) async {
  File file = File(kcfLocation);
  try {
    await firebase_storage.FirebaseStorage.instance
        .ref('database/Af-fix.db')
        .putFile(file);
  } on firebase_storage.FirebaseException catch (e) {
    AlertDialog(
      title: Text('Kesalahan telah berlaku!'),
      content: Text('$e'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Okay'))
      ],
    );
  }
}

saveDBToCloud(BuildContext context) {
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
    child: Text('Simpan'),
    onPressed: () async {
      await _uploadFile(kcfLocation, context);
      showToast('Berjaya disimpan ke storan awan',
          position: ToastPosition.bottom);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Simpan ke storan awan'),
    content: Text('Adakah anda ingin simpan segala data SQLite ke '
        'storan awan?'),
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

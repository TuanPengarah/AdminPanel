import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oktoast/oktoast.dart';

class ShowAlert {
  final docid;
  final nama;
  ShowAlert({this.docid, this.nama});

  showAlertDialog(BuildContext context) {
// set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        'Padam',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed: () {
        FirebaseFirestore.instance
            .collection('customer')
            .doc(docid)
            .delete()
            .then((value) => showToast('Customer $nama telah dipadam'))
            .catchError((error) => showToast('Gagal untuk padam: $error'));
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

// set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Adakah anda pasti'),
      content: Text('Segala butiran customer akan dipadam!'),
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
}

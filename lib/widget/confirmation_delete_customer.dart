import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowAlert {
  final docid;
  ShowAlert({this.docid});

  showAlertDialog(BuildContext context) {
// set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        'Padam',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed: () {
        FirebaseFirestore.instance.collection('customer').doc(docid).delete();
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

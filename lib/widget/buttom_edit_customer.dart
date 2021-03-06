import 'package:flutter/material.dart';
import 'package:services_form/widget/text_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oktoast/oktoast.dart';

class Editdb {
  //pass data
  final name;
  final phone;
  final email;
  final docid;
  Editdb({this.name, this.phone, this.email, this.docid});
  //text controller
  final cNama = TextEditingController();
  final cPhone = TextEditingController();
  final cEmail = TextEditingController();

  CollectionReference user = FirebaseFirestore.instance.collection('customer');

  showEditdb(context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Edit Customer',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextBar(
                  focus: false,
                  controll: cNama,
                  hintTitle: 'Masukkan nama baru $name',
                  hintEdit: '$name',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: cPhone,
                  hintTitle: 'Masukkan nombor phone baru $phone',
                  hintEdit: '$phone',
                  keyType: TextInputType.phone,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: cEmail,
                  hintTitle: 'Masukkan email baru $email',
                  hintEdit: '$email',
                  keyType: TextInputType.emailAddress,
                  valueChange: (value) {},
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _editCustConfirmation(context);
                      },
                      child: Text('Kemaskini'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateUser() {
    cNama.text.isEmpty ? cNama.text = name : cNama.text.toString();
    cPhone.text.isEmpty ? cPhone.text = phone : cPhone.text.toString();
    cEmail.text.isEmpty ? cEmail.text = email : cEmail.text.toString();
    List<String> splitList = cNama.text.split(" ");

    List<String> indexList = [];
    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++)
        indexList.add(splitList[i].substring(0, y).toLowerCase());
    }
    print(splitList);
    print('$indexList');
    return user
        .doc(docid)
        .update({
          'Nama': '${cNama.text}',
          'No Phone': '${cPhone.text}',
          'Email': '${cEmail.text}',
          'Search Index': indexList,
        })
        .then((value) => showToast('Kemaskini berjaya'))
        .catchError((error) => showToast('Gagal untuk kemaskini: $error'));
  }

  _editCustConfirmation(BuildContext context) {
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
      child: Text('Pasti'),
      onPressed: () {
        updateUser();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Edit Customer'),
      content: Text('Pastikan segala maklumat customer adalah betul!'),
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

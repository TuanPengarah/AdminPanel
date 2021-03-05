import 'package:flutter/material.dart';
import 'package:services_form/widget/text_bar.dart';

class Editdb {
  //pass data
  final name;
  final phone;
  final email;
  Editdb({this.name, this.phone, this.email});
  //text controller
  final cNama = TextEditingController();
  final cPhone = TextEditingController();
  final cEmail = TextEditingController();

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
                  hintTitle: 'Masukkan nama baru',
                  hintEdit: '$name',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: cPhone,
                  hintTitle: 'Masukkan nombor phone baru',
                  hintEdit: '$phone',
                  keyType: TextInputType.phone,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: cEmail,
                  hintTitle: 'Masukkan email baru',
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
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
}

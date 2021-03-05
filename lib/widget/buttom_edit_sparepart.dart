import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:services_form/brain/quality_suggestion.dart';
import 'package:services_form/brain/smartphone_suggestion.dart';
import 'package:services_form/brain/spareparts_database.dart';
import 'package:services_form/brain/spareparts_suggestion.dart';
import 'package:services_form/widget/text_bar.dart';

class EditSparepart {
  //pass data
  final sparepart;
  final model;
  final supplier;
  final quantity;
  final manufactor;
  final details;
  final userID;
  final tarikh;

  EditSparepart(
      {this.sparepart,
      this.supplier,
      this.quantity,
      this.manufactor,
      this.details,
      this.userID,
      this.tarikh,
      this.model});
  //text controller
  final _csparepart = TextEditingController();
  final _csupplier = TextEditingController();
  final _cmodel = TextEditingController();
  final _quantity = TextEditingController();
  final _manufactor = TextEditingController();
  final _details = TextEditingController();
  BioSpareparts bio;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  List supplierlist = [
    {"name": "MG", "id": "Mobile Gadget Resources"},
    {"name": "G", "id": "Golden Spareparts"},
    {"name": "GM", "id": "GM Communication"},
    {"name": "RnJ", "id": "RnJ Spareparts"},
    {"name": "OR", "id": "Orange Spareparts"},
  ];

  showEditdb(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                    'Edit Spareparts',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextBar(
                  notSuggest: true,
                  onClickSuggestion: (suggestion) {
                    _cmodel.text = suggestion.toString();
                  },
                  callBack: (pattern) {
                    return SmartphoneSuggestion.getSuggestions(pattern);
                  },
                  builder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.phone_android_sharp),
                      title: Text(suggestion),
                    );
                  },
                  focus: false,
                  controll: _cmodel,
                  hintTitle: 'Masukkan nama model baru',
                  hintEdit: '$model',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  notSuggest: true,
                  onClickSuggestion: (suggestion) {
                    _csparepart.text = suggestion.toString();
                  },
                  callBack: (pattern) {
                    return PartsSuggestion.getSuggestions(pattern);
                  },
                  builder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.electrical_services_rounded),
                      title: Text(suggestion),
                      // subtitle: Text('${suggestion['id']}'),
                    );
                  },
                  focus: false,
                  controll: _csparepart,
                  hintTitle: 'Masukkan nama sparepart baru',
                  hintEdit: '$sparepart',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  notSuggest: true,
                  onClickSuggestion: (suggestion) {
                    _csupplier.text = suggestion['name'].toString();
                  },
                  callBack: (pattern) async {
                    return supplierlist;
                  },
                  builder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.business),
                      title: Text('${suggestion['name']}'),
                      subtitle: Text('${suggestion['id']}'),
                    );
                  },
                  focus: false,
                  controll: _csupplier,
                  hintTitle: 'Masukkan supplier baru',
                  hintEdit: '$supplier',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  notSuggest: true,
                  onClickSuggestion: (suggestion) {
                    _manufactor.text = suggestion.toString();
                  },
                  callBack: (pattern) {
                    return ManufactorSuggestion.getSuggestions(pattern);
                  },
                  builder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.electrical_services_rounded),
                      title: Text(suggestion),
                      // subtitle: Text('${suggestion['id']}'),
                    );
                  },
                  focus: false,
                  controll: _manufactor,
                  hintTitle: 'Masukkan kualiti spareparts',
                  hintEdit: '$manufactor',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: _details,
                  hintTitle: 'Masukkan maklumat spareparts',
                  hintEdit: '$details',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: _quantity,
                  hintTitle: 'Masukkan kuantiti baru',
                  hintEdit: '$quantity',
                  keyType: TextInputType.number,
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
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _editConfirmation(context);
                      },
                      child: Text(
                        'Kemaskini',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  void updateUser() async {
    bio = BioSpareparts(
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    );
    databaseReference = database.reference().child('Spareparts');

    bio.date = tarikh;
    _cmodel.text.isEmpty
        ? bio.sparepart = model
        : bio.sparepart = _cmodel.text.toString();
    _csparepart.text.isEmpty
        ? bio.type = sparepart.toString()
        : bio.type = _csparepart.text.toString();
    _csupplier.text.isEmpty
        ? bio.supplier = supplier
        : bio.supplier = _csupplier.text.toString();
    _quantity.text.isEmpty
        ? bio.quantity = quantity
        : bio.quantity = _quantity.text.toString();
    _manufactor.text.isEmpty
        ? bio.manufactor = manufactor
        : bio.manufactor = _manufactor.text.toString();
    _details.text.isEmpty
        ? bio.details = details
        : bio.details = _details.text.toString();
    await databaseReference.child(userID).update(bio.toJson());
  }

  _editConfirmation(BuildContext context) {
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
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Edir Spareparts'),
      content: Text('Pastikan segala maklumat spareparts adalah betul!'),
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

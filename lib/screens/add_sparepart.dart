import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:services_form/brain/quality_suggestion.dart';
import 'package:services_form/brain/spareparts_suggestion.dart';
import 'package:services_form/brain/smartphone_suggestion.dart';
import 'package:services_form/widget/text_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:services_form/brain/spareparts_database.dart';

tarikh() {
  var now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  return formatter.format(now);
}

final FirebaseDatabase database = FirebaseDatabase.instance;
BioSpareparts bio;

DatabaseReference databaseReference;

List<BioSpareparts> bioList;

final GlobalKey<FormState> formkey = GlobalKey<FormState>();
final csparepart = TextEditingController();
final ctype = TextEditingController();
final csupplier = TextEditingController();
final cquantity = TextEditingController();
final cmanufactor = TextEditingController();
final cdetails = TextEditingController();

List supplierlist = [
  {"name": "MG", "id": "Mobile Gadget Resources"},
  {"name": "G", "id": "Golden Spareparts"},
  {"name": "GM", "id": "GM Communication"},
  {"name": "RnJ", "id": "RnJ Spareparts"},
  {"name": "OR", "id": "Orange Spareparts"},
];

class AddSparepart extends StatefulWidget {
  @override
  _AddSparepartState createState() => _AddSparepartState();
}

class _AddSparepartState extends State<AddSparepart> {
  bool _sparepartsmiss = false;
  bool _typemiss = false;
  bool _suppliermiss = false;
  bool _quantitymiss = false;
  bool _manufactor = false;
  bool _details = false;

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bioList = [];
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
    databaseReference.onChildChanged.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  void _onEntryAdded(Event event) async {
    setState(() {
      bioList.add(BioSpareparts.fromSnapshot((event.snapshot)));
    });
  }

  void _onEntryChanged(Event event) async {
    var oldEntry = bioList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      bioList[bioList.indexOf(oldEntry)] =
          BioSpareparts.fromSnapshot((event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.white),
        onPressed: () {
          setState(() {
            csparepart.text.isEmpty
                ? _sparepartsmiss = true
                : _sparepartsmiss = false;
            ctype.text.isEmpty ? _typemiss = true : _typemiss = false;
            csupplier.text.isEmpty
                ? _suppliermiss = true
                : _suppliermiss = false;
            cquantity.text.isEmpty
                ? _quantitymiss = true
                : _quantitymiss = false;
            cmanufactor.text.isEmpty ? _manufactor = true : _manufactor = false;
            cdetails.text.isEmpty ? _details = true : _details = false;
          });
          if (_sparepartsmiss == false &&
              _suppliermiss == false &&
              _typemiss == false &&
              _quantitymiss == false &&
              _manufactor == false &&
              _details == false) {
            _formConfirmation(context);
          }
        },
      ),
      appBar: AppBar(
        title: Text('Add Sparepart'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextBar(
              notSuggest: true,
              onClickSuggestion: (suggestion) {
                csupplier.text = suggestion['name'].toString();
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
              controll: csupplier,
              hintTitle: 'Supplier',
              focus: false,
              valueChange: (vsupplier) {
                if (csupplier.text != vsupplier.toUpperCase())
                  csupplier.value =
                      csupplier.value.copyWith(text: vsupplier.toUpperCase());
              },
              keyType: TextInputType.name,
              err: _suppliermiss ? 'Sila masukkan nama supplier' : null,
            ),
            TextBar(
              notSuggest: true,
              onClickSuggestion: (suggestion) {
                csparepart.text = suggestion.toString();
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
              controll: csparepart,
              hintTitle: 'Model',
              focus: false,
              valueChange: (vmodel) {},
              keyType: TextInputType.name,
              err: _sparepartsmiss ? 'Sila masukkan model smartphone' : null,
            ),
            TextBar(
              notSuggest: true,
              onClickSuggestion: (suggestion) {
                ctype.text = suggestion.toString();
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
              controll: ctype,
              hintTitle: 'Jenis Spareparts',
              focus: false,
              valueChange: (vtype) {},
              keyType: TextInputType.name,
              err: _typemiss ? 'Sila masukkan jenis spareparts' : null,
            ),
            TextBar(
              notSuggest: true,
              onClickSuggestion: (suggestion) {
                cmanufactor.text = suggestion.toString();
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
              controll: cmanufactor,
              hintTitle: 'Kualiti Spareparts',
              focus: false,
              valueChange: (vmanufactor) {},
              keyType: TextInputType.name,
              err:
                  _manufactor ? 'Sila masukkan jenis kualiti spareparts' : null,
            ),
            TextBar(
              controll: cdetails,
              hintTitle: 'Maklumat Sparepart',
              hintEdit: 'cth: Warna, tarikh pengeluar battery, dll..',
              focus: false,
              valueChange: (vmanufactor) {},
              keyType: TextInputType.name,
              err: _details ? 'Sila masukkan makluamat sparepart' : null,
            ),
            TextBar(
              controll: cquantity,
              hintTitle: 'Kuantiti',
              focus: false,
              valueChange: (vquantity) {},
              keyType: TextInputType.number,
              err: _quantitymiss ? 'Sila masukkan kuantiti' : null,
            ),
          ],
        ),
      ),
    );
  }
}

_formConfirmation(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Batal"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text('Pasti'),
    onPressed: () {
      submit();
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Tambah Spareparts'),
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

void submit() {
  String _tarikh = tarikh().toString();
  bio.sparepart = csparepart.text.toString();
  bio.type = ctype.text.toString();
  bio.supplier = csupplier.text.toString();
  bio.quantity = cquantity.text.toString();
  bio.manufactor = cmanufactor.text.toString();
  bio.details = cdetails.text.toString();
  bio.date = _tarikh;
  databaseReference.push().set(bio.toJson());
}

void clear() {
  ctype.clear();
  csupplier.clear();
  csparepart.clear();
  cquantity.clear();
  cmanufactor.clear();
  cdetails.clear();
}

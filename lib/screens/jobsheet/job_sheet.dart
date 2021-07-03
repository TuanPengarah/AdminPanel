import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services_form/brain/smartphone_suggestion.dart';
import 'package:services_form/brain/spareparts_suggestion.dart';
import 'package:services_form/main.dart';
import 'package:services_form/widget/text_bar.dart';
import '../print/print.dart';
import 'dart:math';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Nama id setiap textbar
final nama = TextEditingController();
final phone = TextEditingController();
final model = TextEditingController();
final pass = TextEditingController();
final damage = TextEditingController();
final angg = TextEditingController();
final remarks = TextEditingController();
final email = TextEditingController();
int genUID = 00000;
int midUID = 0000;
//MyRepairID
int uid = 00000;
//Generate MyRepairID
void randomize() {
  uid = Random().nextInt(999999 - 100000);
}

void generateMidUid() {
  midUID = Random().nextInt(9999 - 1000);
}

generateUID() async {
  final QuerySnapshot qSnap =
      await FirebaseFirestore.instance.collection('customer').get();
  final int documents = qSnap.docs.length;
  genUID = documents;
}

//Customer UID
int calc = 000000;

//generate untuk tarikh baru (Device Time)
tarikh() {
  var now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  return formatter.format(now);
}

class JobSheet extends StatefulWidget {
  final bool editCustomer;
  final String passName;
  final String passPhone;
  final String passEmail;
  final String passUID;

  JobSheet(
      {this.editCustomer,
      this.passPhone,
      this.passName,
      this.passEmail,
      this.passUID});

  @override
  _JobSheetState createState() => _JobSheetState();
}

class _JobSheetState extends State<JobSheet> {
  bool namamiss = false;
  bool phonemiss = false;
  bool modelmiss = false;

  final NativeContactPicker _contactPicker = new NativeContactPicker();
  Contact _contact;

  @override
  void initState() {
    randomize();
    widget.editCustomer == false ? reset() : getFromDetails();
    super.initState();
  }

  void reset() {
    nama.clear();
    phone.clear();
    email.clear();
    model.clear();
    pass.clear();
    damage.clear();
    angg.clear();
    remarks.clear();
  }

  void getFromDetails() {
    nama.text = widget.passName;
    phone.text = widget.passPhone;
    email.text = widget.passEmail;
    model.clear();
    pass.clear();
    damage.clear();
    angg.clear();
    remarks.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return DoubleBack(
      message: 'Tekan sekali lagi untuk keluar',
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              nama.text.isEmpty ? namamiss = true : namamiss = false;
              phone.text.isEmpty ? phonemiss = true : phonemiss = false;
              model.text.isEmpty ? modelmiss = true : modelmiss = false;
              if (namamiss == false &&
                  phonemiss == false &&
                  modelmiss == false) {
                generateMidUid();
                generateUID();
                showAlertDialog(context);
              }
            });
          },
          child: Icon(Icons.done, color: Colors.white),
        ),
        backgroundColor:
            isDarkMode == true ? Color(0xFF000000) : Colors.blueGrey,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        tooltip: 'Dapatkan contact',
                        iconSize: 35,
                        onPressed: () async {
                          Contact contact =
                              await _contactPicker.selectContact();
                          setState(() {
                            _contact = contact;
                            try {
                              nama.text = _contact.fullName.toUpperCase();
                              phone.text = _contact.phoneNumber;
                            } catch (e) {
                              print(e);
                            }
                          });
                        },
                        icon: Icon(Icons.contacts_outlined),
                        color: Colors.white,
                        // size: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AutoSizeText(
                        'Job Sheet',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AutoSizeText(
                        'MyStatus Identification: $uid',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //////Sheet\\\\\\
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isDarkMode == true ? Color(0xFF121212) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: ListView(
                    children: [
                      TextBar(
                        password: false,
                        focus: false,
                        controll: nama,
                        err: namamiss ? 'Sila masukkan nama customer' : null,
                        hintTitle: 'Nama Customer',
                        onEnter: TextInputAction.next,
                        valueChange: (namav) {
                          if (nama.text != namav.toUpperCase())
                            nama.value =
                                nama.value.copyWith(text: namav.toUpperCase());
                        },
                        keyType: TextInputType.name,
                      ),
                      TextBar(
                        password: false,
                        focus: false,
                        controll: phone,
                        err: phonemiss
                            ? 'Sila masukkan nombor telefon customer'
                            : null,
                        hintTitle: 'Nombor untuk Dihubungi',
                        onEnter: TextInputAction.next,
                        valueChange: (nofon) {},
                        keyType: TextInputType.phone,
                      ),
                      TextBar(
                        password: false,
                        focus: false,
                        controll: email,
                        hintTitle: 'Email *Optional',
                        valueChange: (emailv) {},
                        onEnter: TextInputAction.next,
                        keyType: TextInputType.emailAddress,
                      ),
                      TextBar(
                        password: false,
                        notSuggest: true,
                        onEnter: TextInputAction.next,
                        onClickSuggestion: (suggestion) {
                          model.text = suggestion.toString().toUpperCase();
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
                        controll: model,
                        err: modelmiss
                            ? 'Sila masukkan model phone customer'
                            : null,
                        hintTitle: 'Model Smartphone',
                        valueChange: (modelv) {
                          if (model.text != modelv.toUpperCase())
                            model.value = model.value
                                .copyWith(text: modelv.toUpperCase());
                        },
                        keyType: TextInputType.text,
                      ),
                      TextBar(
                        password: false,
                        focus: false,
                        controll: pass,
                        hintTitle: 'Password Smartphone',
                        onEnter: TextInputAction.next,
                        valueChange: (passv) {},
                        keyType: TextInputType.text,
                      ),
                      TextBar(
                        password: false,
                        notSuggest: true,
                        onClickSuggestion: (suggestion) {
                          damage.text = suggestion.toString().toUpperCase();
                        },
                        onEnter: TextInputAction.next,
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
                        controll: damage,
                        hintTitle: 'Kerosakkan',
                        max: 3,
                        valueChange: (rosak) {
                          if (damage.text != rosak.toUpperCase())
                            damage.value = damage.value
                                .copyWith(text: rosak.toUpperCase());
                        },
                        keyType: TextInputType.multiline,
                      ),
                      TextBar(
                        password: false,
                        focus: false,
                        controll: angg,
                        hintTitle: 'Anggaran harga',
                        valueChange: (pricev) {},
                        onEnter: TextInputAction.next,
                        keyType: TextInputType.number,
                      ),
                      TextBar(
                        password: false,
                        focus: false,
                        controll: remarks,
                        hintTitle: '*Remarks',
                        max: 5,
                        valueChange: (specific) {},
                        onEnter: TextInputAction.next,
                        keyType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getUserID;
  Future<void> createUser() async {
    try {
      app = Firebase.app('Secondary');
      if (email.text.isEmpty) {
        String _username = nama.text;
        email.text =
            _username.split(" ").join("").toLowerCase() + '@assaff.com';
        print(_username);
        UserCredential auth = await FirebaseAuth.instanceFor(app: app)
            .createUserWithEmailAndPassword(
                email: email.text, password: '123456');

        final User user = auth.user;
        await user.updateProfile(displayName: nama.text);
        _getUserID = user.uid;
      }
    } catch (e) {
      showToast('Error on creating user account: $e',
          position: ToastPosition.bottom);
      app = Firebase.app('Secondary');
    }
  }

////Tambah ke database////
  Future<void> addData() async {
    String _docid;
    widget.editCustomer == false
        ? _docid = _getUserID
        : _docid = widget.passUID;
    pass.text.isEmpty ? pass.text = 'Tiada Password' : pass.text = pass.text;
//convert tarikh dari peranti ke database
    String _tarikh = tarikh().toString();

//repair history berformat JSON
    Map<String, dynamic> repairHistory = {
      'MID': '${uid.toString()}',
      'Model': '${model.text}',
      'Password': '${pass.text}',
      'Kerosakkan': '${damage.text}',
      'Harga': int.parse(angg.text),
      'Remarks': '*${remarks.text}',
      'Tarikh': _tarikh,
      'Tarikh Waranti': _tarikh,
      'isWarranty': false,
      'Technician': 'Akid Fikri Azhar',
      'Status': 'Belum Selesai',
      'timeStamp': FieldValue.serverTimestamp(),
    };
    Map<String, dynamic> myrepairID = {
      'Database UID': _docid,
      'Nama': '${nama.text}',
      'No Phone': '${phone.text}',
      'Percent': 0.0,
      'MID': '${uid.toString()}',
      'Model': '${model.text}',
      'Password': '${pass.text}',
      'Kerosakkan': '${damage.text}',
      'Harga': int.parse(angg.text),
      'Remarks': '*${remarks.text}',
      'Tarikh': _tarikh,
      'Technician': 'Akid Fikri Azhar',
      'Status': 'In Queue',
      'isPayment': false,
      'timeStamp': FieldValue.serverTimestamp(),
    };
//customer bio berformat JSON
    Map<String, dynamic> userData = {
      'Tarikh': _tarikh,
      'Nama': '${nama.text}',
      'No Phone': '${phone.text}',
      'Email': '${email.text}',
      'UID': _docid,
    };
    try {
      //Tambah data collection (Customer Bio) ke database
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('customer');

      await collectionReference
          .doc(_docid)
          .set(userData)
          .then((value) => showToast(
              'Job Sheet berjaya di masukkan ke database',
              position: ToastPosition.bottom))
          .catchError((error) => showToast(
              'Gagal untuk memasuki job sheet ke database: $error',
              position: ToastPosition.bottom));

      //Tambah data sub-collection (Repair History) ke database
      await collectionReference
          .doc(_docid)
          .collection('repair history')
          .doc(uid.toString())
          .set(repairHistory);

      //tambah ke MyrepairID
      FirebaseFirestore.instance
          .collection('MyrepairID')
          .doc(uid.toString())
          .set(myrepairID);
    } catch (e) {
      print(e);
    }

    //tambah point
    if (widget.editCustomer == true) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('customer').doc(_docid);
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snap = await transaction.get(documentReference);

        if (!snap.exists) {
          throw Exception("User does not exist!");
        }

        int newPoints = snap.get('Points');

        transaction.update(documentReference, {'Points': newPoints + 10});
      });
    } else if (widget.editCustomer == false) {
      FirebaseFirestore.instance
          .collection('customer')
          .doc(_docid)
          .update({'Points': 1000});
    }
  }

  showAlertDialog(BuildContext context) {
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
      onPressed: () async {
        if (widget.editCustomer == false) await createUser();
        await addData().then((value) {
          Navigator.pop(context);
          _printConfirmation(context);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Adakah anda pasti'),
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

  _printConfirmation(BuildContext context) {
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
      child: Text('Print'),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Print(
              dataname: nama.text,
              dataphone: phone.text,
              datamodel: model.text,
              datadmg: damage.text,
              dataangg: angg.text,
              dataremarks: remarks.text,
              datauid: uid,
            ),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Print'),
      content: Text('Adakah anda ingin print maklumat JobSheet ini?'),
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

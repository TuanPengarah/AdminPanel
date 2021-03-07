import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services_form/widget/text_bar.dart';
import 'print.dart';
import 'dart:math';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';

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

addData() {
//convert tarikh dari peranti ke database
  String _tarikh = tarikh().toString();

//fungsi search (LOOP Method)
  List<String> splitList = nama.text.split(" ");
  List<String> indexList = [];
  for (int i = 0; i < splitList.length; i++) {
    for (int y = 1; y < splitList[i].length + 1; y++)
      indexList.add(splitList[i].substring(0, y).toLowerCase());
  }
//repair history berformat JSON
  Map<String, dynamic> repairHistory = {
    'MID': '${uid.toString()}',
    'Model': '${model.text}',
    'Password': '${pass.text}',
    'Kerosakkan': '${damage.text}',
    'Harga': 'RM${angg.text}',
    'Remarks': '*${remarks.text}',
  };
//customer bio berformat JSON
  Map<String, dynamic> userData = {
    'Tarikh': '$_tarikh',
    'Nama': '${nama.text}',
    'No Phone': '${phone.text}',
    'Email': '${email.text}',
    'Search Index': indexList,
  };
  try {
    //cantumkan variable nama dengan UID
    String _docid =
        'affix-${midUID.toString()}-${genUID.toString().padLeft(10, '0')}';
    //Tambah data collection (Customer Bio) ke database
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('customer');
    collectionReference
        .doc(_docid)
        .set(userData)
        .then((value) => showToast('Job Sheet berjaya di masukkan ke database'))
        .catchError((error) =>
            showToast('Gagal untuk memasuki job sheet ke database: $error'));

    //Tambah data sub-collection (Repair History) ke database
    FirebaseFirestore.instance
        .collection('customer')
        .doc(_docid)
        .collection('repair history')
        .doc(uid.toString())
        .set(repairHistory);
  } catch (e) {
    print(e);
  }
}

class JobSheet extends StatefulWidget {
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
    nama.text = ('');
    phone.text = ('');
    model.text = ('');
    pass.text = ('');
    damage.text = ('');
    angg.text = ('');
    remarks.text = ('');
    email.text = ('');
    super.initState();
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
                            nama.text = _contact.fullName.toUpperCase();
                            phone.text = _contact.phoneNumber;
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
                        'MyRepair Identification: $uid',
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
                        focus: false,
                        controll: nama,
                        err: namamiss ? 'Sila masukkan nama customer' : null,
                        hintTitle: 'Nama Customer',
                        valueChange: (namav) {
                          if (nama.text != namav.toUpperCase())
                            nama.value =
                                nama.value.copyWith(text: namav.toUpperCase());
                        },
                        keyType: TextInputType.name,
                      ),
                      TextBar(
                        focus: false,
                        controll: phone,
                        err: phonemiss
                            ? 'Sila masukkan nombor telefon customer'
                            : null,
                        hintTitle: 'Nombor untuk Dihubungi',
                        valueChange: (nofon) {},
                        keyType: TextInputType.phone,
                      ),
                      TextBar(
                        focus: false,
                        controll: email,
                        hintTitle: 'Email *Optional',
                        valueChange: (emailv) {},
                        keyType: TextInputType.emailAddress,
                      ),
                      TextBar(
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
                        focus: false,
                        controll: pass,
                        hintTitle: 'Password Smartphone',
                        valueChange: (passv) {},
                        keyType: TextInputType.text,
                      ),
                      TextBar(
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
                        focus: false,
                        controll: angg,
                        hintTitle: 'Anggaran harga',
                        valueChange: (pricev) {},
                        keyType: TextInputType.number,
                      ),
                      TextBar(
                        focus: false,
                        controll: remarks,
                        hintTitle: '*Remarks',
                        max: 5,
                        valueChange: (specific) {},
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
}

showAlertDialog(BuildContext context) {
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
      addData();
      // databaseReference.push().set(bio.toJson());
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Print(
            dataname: nama.text,
            dataphone: phone.text,
            datamodel: model.text,
            datapass: pass.text,
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

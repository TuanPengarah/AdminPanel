import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/brain/sqlite_services.dart';
import 'package:services_form/screens/payment/payment_complete.dart';
import 'package:services_form/widget/repair_log_dialog.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oktoast/oktoast.dart';
import '../spareparts/inventory.dart';

class TransactionSetting extends StatefulWidget {
  final mid;
  final model;
  final nama;
  final uid;
  final price;
  final kerosakkan;
  final noPhone;
  final remarks;
  TransactionSetting(
      {this.mid,
      this.model,
      this.nama,
      this.uid,
      this.price,
      this.kerosakkan,
      this.noPhone,
      this.remarks});
  @override
  _TransactionSettingState createState() => _TransactionSettingState();
}

class _TransactionSettingState extends State<TransactionSetting> {
  final _cCash = TextEditingController();
  String _titleSpareparts = 'Klik Sini...';
  String _uidSpareparts;
  int _hargaSpareparts = 0;
  String _hariWaranti;
  String _hariBulan;
  String _tempohWaranti;
  int _suggestHarga = 0;
  int _hargaAsal = 0;
  int _hargaSupplier = 0;
  String _tarikhSekarang;
  CashFlow cashflow;

  //generate untuk tarikh baru (Device Time)
  tarikh() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  void _localCF() {
    if (cashflow == null) {
      CashFlow cf = CashFlow(
        dahBayar: 1,
        price: int.parse(_cCash.text),
        spareparts: '$_titleSpareparts',
        tarikh: tarikh().toString(),
      );
      DBProvider.db.insert(cf).then((id) => {
            print('tambah '
                'ke database $id')
          });
    }
  }

  _updateDatabase() {
    //BUANG LIST SPAREPART YANG TELAH PAKAI
    if (_uidSpareparts != null) {
      FirebaseDatabase.instance
          .reference()
          .child('Spareparts')
          .child(_uidSpareparts)
          .remove();
    }
    //UPDATE STATUS isPayment PADA MYREPAIR ID
    FirebaseFirestore.instance
        .collection('MyrepairID')
        .doc(widget.mid)
        .update({'isPayment': true});

    //UPDATE STATU PADA REPAIR HISTORY
    Map<String, dynamic> updateRH = {
      'Status': 'Selesai',
      'Harga': int.parse(_cCash.text),
    };
    FirebaseFirestore.instance
        .collection('customer')
        .doc(widget.uid)
        .collection('repair history')
        .doc(widget.mid)
        .update(updateRH);

    // //TAMBAH DOC PADA CASHFLOW
    // Map<String, dynamic> cashFlow = {
    //   'Nama': '${widget.nama}',
    //   'Model': '${widget.model}',
    //   'Repair': '$_titleSpareparts',
    //   'Harga': int.parse(_cCash.text),
    //   'Harga Supplier': _hargaSupplier,
    //   'Waranti': '$_hariWaranti $_hariBulan',
    //   'Waranti Mula': '$_tarikhSekarang',
    //   'Waranti Akhir': '$_tempohWaranti',
    // };

    // FirebaseFirestore.instance
    //     .collection('cashFlow')
    //     .doc(widget.mid)
    //     .set(cashFlow);
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.blueGrey,
        systemNavigationBarIconBrightness: Brightness.light));
    super.dispose();
  }

  void dapatWaranti() {
    if (_hariWaranti == '-' && _hariBulan == 'Tiada') {
      _suggestHarga = 0;
      var jiffy9 = Jiffy()..add(duration: Duration(days: 0));
      _tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
      _suggestionAI();
    } else if (_hariWaranti == '1' && _hariBulan == 'Bulan') {
      _suggestHarga = 0;
      _suggestionAI();
      var jiffy9 = Jiffy()..add(duration: Duration(days: 30));
      _tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
    } else if (_hariWaranti == '2' && _hariBulan == 'Bulan') {
      _suggestHarga = 60;
      _suggestionAI();
      var jiffy9 = Jiffy()..add(duration: Duration(days: 60));
      _tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
    } else if (_hariWaranti == '3' && _hariBulan == 'Bulan') {
      var jiffy9 = Jiffy()..add(duration: Duration(days: 90));
      _suggestHarga = 120;
      _suggestionAI();
      _tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
    } else if (_hariWaranti == '1' && _hariBulan == 'Minggu') {
      _suggestHarga = -60;
      _suggestionAI();
      var jiffy9 = Jiffy()..add(duration: Duration(days: 7));
      _tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
    } else if (_hariWaranti == '2' && _hariBulan == 'Minggu') {
      _suggestHarga = -30;
      _suggestionAI();
      var jiffy9 = Jiffy()..add(duration: Duration(days: 14));
      _tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
    } else if (_hariWaranti == '3' && _hariBulan == 'Minggu') {
      _suggestHarga = 0;
      _suggestionAI();
      var jiffy9 = Jiffy()..add(duration: Duration(days: 21));
      _tempohWaranti = jiffy9.format('dd-MM-yyyy').toString();
    }
  } //perkiraan waranti

  _suggestionAI() {
    int i = _hargaAsal;
    int x = _suggestHarga;
    int z = _hargaSupplier;

    if (_hariWaranti == '-' && _hariBulan == 'Tiada') {
      i = i - 20;
      return _hargaSpareparts = i;
    } else if (i <= 40) {
      i = i;
      print('i+i');
      return _hargaSpareparts = i;
    } else if (i >= 60) {
      i = i + x;
      print('i+x');
      return _hargaSpareparts = i;
    } else if (i < z) {
      i = z + 40;
      print('i+z');
      return _hargaSpareparts = i;
    }
  }

  @override
  void initState() {
    _tarikhSekarang = tarikh();
    print(_tarikhSekarang);
    _hariWaranti = '1';
    _hariBulan = 'Bulan';
    _cCash.text = widget.price.toString();
    setState(() {
      dapatWaranti();
    });
    super.initState();
  }

  void updateSpareparts(String choosing, String partsUID, String hargaParts,
      String defaultPrice, String suppPrice) {
    setState(() {
      _titleSpareparts = choosing;
      _uidSpareparts = partsUID;
      _hargaSpareparts = int.parse(hargaParts);
      _hargaAsal = int.parse(hargaParts);
      _hargaSupplier = int.parse(suppPrice);
    });
    print(partsUID);
    print(hargaParts);
  }

  void chooseSpareparts() async {
    final choosing = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (i) => Inventory(
          choose: true,
        ),
      ),
    );
    if (choosing != null) {
      updateSpareparts(
        choosing[0],
        choosing[1],
        choosing[2],
        choosing[2],
        choosing[3],
      );
    }
  }

  _buyingConfirmation(BuildContext context) {
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
        _updateDatabase();
        _localCF();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentsCompleted(
              mid: widget.mid,
              nama: widget.nama,
              model: widget.model,
              noPhone: widget.noPhone,
              warantiStart: _tarikhSekarang,
              warantiAkhir: _tempohWaranti,
              harga: _cCash.text,
              kerosakkan: widget.kerosakkan,
              tukarParts: _titleSpareparts,
              warantiText: '$_hariWaranti $_hariBulan',
            ),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Adakah anda pasti?'),
      content: Text('Pastikan segala maklumat resit pembayaran adalah betul!'),
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

  _showSparepartOption(context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            isDarkMode == true ? Colors.grey[900] : Colors.white,
        systemNavigationBarIconBrightness:
            isDarkMode == true ? Brightness.light : Brightness.dark));
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (BuildContext c) {
          return Wrap(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Jenis Spareparts',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        chooseSpareparts();
                        _hariWaranti = '1';
                        _hariBulan = 'Bulan';
                        dapatWaranti();
                      },
                      child: Text(
                        'Pilih Spareparts',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _hargaSpareparts = 50;
                          _hargaAsal = 50;
                          _titleSpareparts = 'Software';
                          _hariWaranti = '1';
                          _hariBulan = 'Minggu';
                          dapatWaranti();
                        });

                        Navigator.pop(context);
                      },
                      child: Text(
                        'Berkaitan masalah Software',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _hargaSpareparts = 30;
                          _hargaAsal = 50;
                          _titleSpareparts = 'Upah Pasang/Servis';
                          _hariWaranti = '-';
                          _hariBulan = 'Tiada';
                          dapatWaranti();
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Upah Pasang/Servis',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            )
          ]);
        }).whenComplete(() {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.blueGrey,
          systemNavigationBarIconBrightness: Brightness.light));
    });
  } //bottom spareparts

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      minRadius: 1,
      onDismiss: () {
        Navigator.of(context).pop();
      },
      child: Hero(
        tag: widget.mid,
        child: Scaffold(
            backgroundColor: Colors.blueGrey,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: IconButton(
                          iconSize: 28,
                          icon: Icon(Icons.arrow_back_outlined,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 25.0,
                              bottom: 15,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Resit Pembayaran',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.format_align_left,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[900],
                                            title: Text(
                                              'Repair Log',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            content:
                                                repairLogDialog(widget.mid),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Okay',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Card(
                              elevation: 7,
                              child: Container(
                                width: 400,
                                height: 480,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.model,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ),
                                          Text(
                                            widget.mid,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        widget.kerosakkan,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text('MAKLUMAT PELANGGAN :'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 8.0),
                                        child: Text(
                                          widget.nama,
                                          style: subTitle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, left: 8.0),
                                        child: Text(
                                          widget.noPhone,
                                          style: subTitle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, left: 8.0),
                                        child: Text(
                                          widget.remarks,
                                          style: subTitle,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text('PILIH SPAREPARTS :'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _showSparepartOption(context);
                                        },
                                        child: Text(_titleSpareparts),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Form(
                                              child: DropDownFormField(
                                                titleText: 'Pilih Waranti',
                                                hintText:
                                                    'Pilih tempoh waranti',
                                                value: _hariWaranti,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _hariWaranti = value;
                                                    dapatWaranti();
                                                    dapatWaranti();
                                                    if (value == '-') {
                                                      _hariBulan = 'Tiada';
                                                    } else {
                                                      _hariBulan == 'Tiada'
                                                          ? _hariBulan = 'Bulan'
                                                          : _hariBulan =
                                                              _hariBulan;
                                                    }
                                                  });
                                                },
                                                onSaved: (value) {
                                                  setState(() {
                                                    _hariWaranti = value;
                                                  });
                                                },
                                                dataSource: [
                                                  {
                                                    'display': '1',
                                                    'value': '1',
                                                  },
                                                  {
                                                    'display': '2',
                                                    'value': '2',
                                                  },
                                                  {
                                                    'display': '3',
                                                    'value': '3',
                                                  },
                                                  {
                                                    'display': '-',
                                                    'value': '-',
                                                  },
                                                ],
                                                textField: 'display',
                                                valueField: 'value',
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 2,
                                            child: Form(
                                              child: DropDownFormField(
                                                titleText: 'Pilih Waranti',
                                                hintText:
                                                    'Pilih tempoh waranti',
                                                value: _hariBulan,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _hariBulan = value;
                                                    dapatWaranti();
                                                    dapatWaranti();

                                                    print(_tempohWaranti);

                                                    if (value == 'Tiada') {
                                                      _hariWaranti = '-';
                                                    } else {
                                                      _hariWaranti == '-'
                                                          ? _hariWaranti = '1'
                                                          : _hariWaranti =
                                                              _hariWaranti;
                                                    }
                                                  });
                                                },
                                                onSaved: (value) {
                                                  setState(() {
                                                    _hariBulan = value;
                                                  });
                                                },
                                                dataSource: [
                                                  {
                                                    'display': 'Minggu',
                                                    'value': 'Minggu',
                                                  },
                                                  {
                                                    'display': 'Bulan',
                                                    'value': 'Bulan',
                                                  },
                                                  {
                                                    'display': 'Tiada',
                                                    'value': 'Tiada',
                                                  },
                                                ],
                                                textField: 'display',
                                                valueField: 'value',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Center(
                                          child: Text(
                                            'Tempoh waranti sah sehingga: '
                                            '$_tempohWaranti',
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'RM',
                                                style: TextStyle(fontSize: 26),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: _cCash,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Text(
                                                      _hargaSpareparts != 0
                                                          ? 'Disarankan '
                                                              'RM$_hargaSpareparts'
                                                          : '',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                width: 90,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: SizedBox(
                                          height: 45,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.teal),
                                            child: Text(
                                              'BAYAR',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              _titleSpareparts == 'Klik Sini...'
                                                  ? showToast('Sila masukkan '
                                                      'jenis spareparts')
                                                  : _buyingConfirmation(
                                                      context);
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

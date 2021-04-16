import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:services_form/brain/sqlite_services.dart';
import 'package:services_form/widget/text_bar.dart';

extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

class DialogPriceList {
  final String model;
  final String namaSupplier;
  final String jenisSparepart;
  final String tarikh;
  final int hargaSupplier;
  final int hargaJual;
  final int id;

  DialogPriceList({
    this.model,
    this.namaSupplier,
    this.jenisSparepart,
    this.tarikh,
    this.hargaJual,
    this.hargaSupplier,
    this.id,
  });

  showAlertDialog(BuildContext context) {
    String _hariWaranti = '1';
    String _hariBulan = 'Bulan';
    String _jumlahHarga = '0';
    int _suggestHarga;
    suggestionAI() {
      int i = int.parse(_jumlahHarga);
      int x = _suggestHarga;

      i = hargaSupplier;
      if (_hariWaranti == '-' && _hariBulan == 'Tiada') {
        i = i + 20;
        return _suggestHarga = i;
      } else if (_hariWaranti == '1' && _hariBulan == 'Minggu') {
        i = i + 30;
        return _suggestHarga = i;
      } else if (_hariWaranti == '2' && _hariBulan == 'Minggu') {
        i = i + 35;
        return _suggestHarga = i;
      }
      if (i <= 60) {
        i = i * 2 + x;
        print('i+i');
        return _suggestHarga = i;
      } else if (i >= 60 && i < 200) {
        i = i * 2;
        print('i+x');
        return _suggestHarga = i;
      } else if (i >= 200) {
        i = i + 160;
        print('i+i up');
        return _suggestHarga = i;
      }
    }

    void dapatWaranti() {
      int i = hargaJual;
      if (_hariWaranti == '-' && _hariBulan == 'Tiada') {
        suggestionAI();
      } else if (_hariWaranti == '1' && _hariBulan == 'Bulan') {
        _suggestHarga = 0;
        suggestionAI();
      } else if (_hariWaranti == '2' && _hariBulan == 'Bulan') {
        i <= 40 ? _suggestHarga = 20 : _suggestHarga = 40;
        suggestionAI();
      } else if (_hariWaranti == '3' && _hariBulan == 'Bulan') {
        i <= 40 ? _suggestHarga = 30 : _suggestHarga = 60;
        suggestionAI();
      } else if (_hariWaranti == '1' && _hariBulan == 'Minggu') {
        // i <= 40 ? _suggestHarga = -20 : _suggestHarga = -50;
        suggestionAI();
      } else if (_hariWaranti == '2' && _hariBulan == 'Minggu') {
        // i <= 40 ? _suggestHarga = -10 : _suggestHarga = -30;
        suggestionAI();
      } else if (_hariWaranti == '3' && _hariBulan == 'Minggu') {
        _suggestHarga = 0;
        suggestionAI();
      }
    }

    //perkiraan waranti
// set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Tutup"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        'Kemaskini Harga',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        showAlertUpdate(context);
      },
    );
    Widget deletedbutton = TextButton(
      child: Text(
        'Padam',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed: () {
        showAlertDeleted(context);
      },
    );

// set up the AlertDialog
//     AlertDialog alert =

// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('$model ($jenisSparepart)'),
            content: Container(
              height: 350,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Nombor ID: ',
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: '$id',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Tarikh Kemaskini: ',
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: '$tarikh',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Supplier: ',
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: '$namaSupplier',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Harga Supplier: ',
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: 'RM$hargaSupplier',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Harga Jual: ',
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: 'RM$hargaJual',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Center(
                    child: Text(
                      'Periksa anggaran harga',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Form(
                    child: DropDownFormField(
                      titleText: 'Pilih Hari Waranti',
                      hintText: 'Tempoh hari',
                      value: _hariWaranti,
                      onChanged: (value) {
                        setState(() {
                          _hariWaranti = value;
                          dapatWaranti();

                          if (value == '-') {
                            _hariBulan = 'Tiada';
                          } else {
                            _hariBulan == 'Tiada'
                                ? _hariBulan = 'Bulan'
                                : _hariBulan = _hariBulan;
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
                  Form(
                    child: DropDownFormField(
                      titleText: 'Pilih Bulan Waranti',
                      hintText: 'Tempoh bulan',
                      value: _hariBulan,
                      onChanged: (value) {
                        setState(() {
                          _hariBulan = value;
                          dapatWaranti();
                          if (value == 'Tiada') {
                            _hariWaranti = '-';
                          } else {
                            _hariWaranti == '-'
                                ? _hariWaranti = '1'
                                : _hariWaranti = _hariWaranti;
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
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      _suggestHarga != null
                          ? 'RM$_suggestHarga'
                          : 'RM$hargaJual',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              deletedbutton,
              continueButton,
              cancelButton,
            ],
          );
        });
      },
    );
  }

  showAlertDeleted(BuildContext context) {
    String _modeltitle = model.toLowerCase().capitalizeFirstofEach;
    String _typetitle = jenisSparepart.toLowerCase().capitalizeFirstofEach;
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
        DBProvider.db.deletePL(id);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'allpricelist');
      },
    );

// set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Adakah anda pasti'),
      content:
          Text('Butiran senarai harga untuk model $_modeltitle ($_typetitle)'
              ' akan dipadam!'),
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

  showAlertUpdate(BuildContext context) {
    final String _modeltitle = model.toLowerCase().capitalizeFirstofEach;
    final String _typetitle =
        jenisSparepart.toLowerCase().capitalizeFirstofEach;

    final _cSuppPrice = TextEditingController();
    final _cFinalPrice = TextEditingController();

    bool _missSuppPrice = false;
    bool _missFinalPrice = false;

    _cSuppPrice.text = hargaSupplier.toString();
    _cFinalPrice.text = hargaJual.toString();

// set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Masukkan harga baru untuk $_typetitle $_modeltitle'),
            content: Container(
              height: 280,
              width: 200,
              child: Column(
                children: [
                  TextBar(
                    password: false,
                    err: _missSuppPrice ? 'Sila masukkan harga supplier' : null,
                    controll: _cSuppPrice,
                    hintTitle: 'Masukkan harga supplier',
                    valueChange: (newValue) {},
                    keyType: TextInputType.number,
                    focus: true,
                  ),
                  TextBar(
                    password: false,
                    err: _missFinalPrice ? 'Sila masukkan harga jual' : null,
                    controll: _cFinalPrice,
                    hintTitle: 'Masukkan harga jual',
                    valueChange: (newValue) {},
                    keyType: TextInputType.number,
                    focus: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              'Tak pasti untuk letak harga sparepart? Kira anggaran harga dengan ',
                          style: DefaultTextStyle.of(context).style.copyWith(
                                color: Colors.grey,
                              ),
                          children: [
                            TextSpan(
                              text: 'klik di sini.',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, 'calculate');
                                },
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              cancelButton,
              TextButton(
                child: Text(
                  'Kemaskini Harga',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _cSuppPrice.text.isEmpty
                        ? _missSuppPrice = true
                        : _missSuppPrice = false;
                    _cFinalPrice.text.isEmpty
                        ? _missFinalPrice = true
                        : _missFinalPrice = false;
                  });
                  if (_missSuppPrice == false && _missFinalPrice == false) {
                    Map<String, dynamic> _row = {
                      'hargasupplier': int.parse(_cSuppPrice.text),
                      'price': int.parse(_cFinalPrice.text),
                      'id': id,
                    };
                    await DBProvider.db.updatePL(_row);
                    showToast(
                      'Kemaskini harga selesai',
                      position: ToastPosition.bottom,
                    );
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, 'allpricelist');
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }
}

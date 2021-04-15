import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:services_form/brain/smartphone_suggestion.dart';
import 'package:services_form/brain/spareparts_suggestion.dart';
import 'package:services_form/brain/sqlite_services.dart';
import 'package:services_form/widget/text_bar.dart';

class AddPriceList extends StatefulWidget {
  final int hargaSupplier;

  AddPriceList({this.hargaSupplier});

  @override
  _AddPriceListState createState() => _AddPriceListState();
}

class _AddPriceListState extends State<AddPriceList> {
  int _hargaJual = 0;

  final _cHargaSupplier = TextEditingController();
  final _cModel = TextEditingController();
  final _cSupplier = TextEditingController();
  final _cJenis = TextEditingController();

  bool _hargaSuppliermiss = false;
  bool _modelMiss = false;
  bool _supplierMiss = false;
  bool _jenisMiss = false;

  PriceList priceList;

  List supplierlist = [
    {"name": "MG", "id": "Mobile Gadget Resources"},
    {"name": "G", "id": "Golden Spareparts"},
    {"name": "GM", "id": "GM Communication"},
    {"name": "RnJ", "id": "RnJ Spareparts"},
    {"name": "OR", "id": "Orange Spareparts"},
  ];

  @override
  void initState() {
    if (widget.hargaSupplier != null) {
      _cHargaSupplier.text = widget.hargaSupplier.toString();
    }
    super.initState();
  }

  tarikh() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  void _addToSqlite() {
    if (priceList == null) {
      PriceList pl = PriceList(
        price: _hargaJual,
        supplierPrice: int.parse(_cHargaSupplier.text),
        jenis: _cJenis.text,
        tarikh: tarikh().toString(),
        model: _cModel.text,
        supplier: _cSupplier.text,
      );
      DBProvider.db.insertPL(pl).then(
            (id) => showToast(
                'Item telah '
                'ditambah ke SQLite database (Jumlah item: $id)',
                position: ToastPosition.bottom),
          );
    }
  }

  _priceSet() {
    int i = int.parse(_cHargaSupplier.text);

    if (i <= 60) {
      i = i * 2;
      print('i+i');
      return _hargaJual = i;
    } else if (i >= 60 && i < 200) {
      i = i * 2;
      print('i+x');
      return _hargaJual = i;
    } else if (i >= 200) {
      i = i + 160;
      print('i+i up');
      return _hargaJual = i;
    }
  }

  _formConfirmation(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Batal",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        'Pasti',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        _addToSqlite();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Tambah Item'),
      content: Text('Pastikan segala maklumat item adalah betul!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tambah item senarai harga'),
          centerTitle: true,
          brightness: Brightness.dark,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.done,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _cJenis.text.isEmpty ? _jenisMiss = true : _jenisMiss = false;
              _cModel.text.isEmpty ? _modelMiss = true : _modelMiss = false;
              _cSupplier.text.isEmpty
                  ? _supplierMiss = true
                  : _supplierMiss = false;
              _cHargaSupplier.text.isEmpty
                  ? _hargaSuppliermiss = true
                  : _hargaSuppliermiss = false;
            });
            if (_jenisMiss == false &&
                _modelMiss == false &&
                _supplierMiss == false &&
                _hargaSuppliermiss == false) {
              _priceSet();
              _formConfirmation(context);
            }
          },
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              child: Column(
            children: [
              TextBar(
                notSuggest: true,
                onClickSuggestion: (suggestion) {
                  _cModel.text = suggestion.toString().toUpperCase();
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
                controll: _cModel,
                hintTitle: 'Model',
                valueChange: (newValue) {
                  if (_cModel.text != newValue.toUpperCase())
                    _cModel.value =
                        _cModel.value.copyWith(text: newValue.toUpperCase());
                },
                keyType: TextInputType.name,
                focus: true,
                err: _modelMiss ? 'Sila masukkan model smartphone' : null,
              ),
              TextBar(
                notSuggest: true,
                onClickSuggestion: (suggestion) {
                  _cJenis.text = suggestion.toString().toUpperCase();
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
                controll: _cJenis,
                hintTitle: 'Jenis Spareparts',
                valueChange: (newValue) {
                  if (_cJenis.text != newValue.toUpperCase())
                    _cJenis.value =
                        _cJenis.value.copyWith(text: newValue.toUpperCase());
                },
                keyType: TextInputType.name,
                focus: true,
                err: _jenisMiss ? 'Sila masukkan jenis spareparts' : null,
              ),
              TextBar(
                controll: _cHargaSupplier,
                hintTitle: 'Harga Supplier',
                valueChange: (newValue) {},
                keyType: TextInputType.number,
                focus: true,
                err: _hargaSuppliermiss ? 'Sila masukkan harga supplier' : null,
              ),
              TextBar(
                notSuggest: true,
                onClickSuggestion: (suggestion) {
                  _cSupplier.text = suggestion['name'].toString();
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
                controll: _cSupplier,
                hintTitle: 'Supplier',
                valueChange: (newValue) {
                  if (_cSupplier.text != newValue.toUpperCase())
                    _cSupplier.value =
                        _cSupplier.value.copyWith(text: newValue.toUpperCase());
                },
                keyType: TextInputType.name,
                focus: true,
                err: _supplierMiss ? 'Sila masukkan nama supplier' : null,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'PERINGATAN: Harga akan ditetapkan pada polisi asal iaitu '
                    '1 Bulan Waranti',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:services_form/brain/sqlite_services.dart';
import 'package:services_form/brain/try_calculate.dart';
import 'package:services_form/widget/text_bar.dart';

Future<bool> addTransaction(context, bool isUpdate) async {
  final _cName = TextEditingController();
  final _cPrice = TextEditingController();
  bool _namamiss = false;
  bool _pricemiss = false;
  String _transactionForm;
  CashFlow cashflow;

  tarikh() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy | hh:mm a');
    return formatter.format(now);
  }

  void _localCF() {
    if (cashflow == null) {
      CashFlow cf = CashFlow(
        dahBayar: int.parse(_transactionForm),
        price: _transactionForm == '0'
            ? int.parse(_cPrice.text) -
                int.parse(_cPrice.text) -
                int.parse(_cPrice.text)
            : int.parse(_cPrice.text),
        spareparts: '${_cName.text}',
        tarikh: tarikh().toString(),
      );
      DBProvider.db.insert(cf).then((id) => {
            print('tambah '
                'ke database $id')
          });
    }
  }

  return await showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext c) {
      return Wrap(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Tambah Transaksi',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextBar(
                        password: false,
                        err: _namamiss ? 'Sila masukkan bahagian ini' : null,
                        hintTitle: 'Nama transaksi',
                        valueChange: (newValue) {
                          if (_cName.text != newValue.toUpperCase())
                            _cName.value = _cName.value
                                .copyWith(text: newValue.toUpperCase());
                        },
                        keyType: TextInputType.name,
                        focus: true,
                        controll: _cName,
                      ),
                    ),
                    Expanded(
                      child: TextBar(
                        password: false,
                        err: _pricemiss ? 'Sila masukkan jumlah' : null,
                        hintTitle: 'Jumlah',
                        valueChange: (newValue) {},
                        keyType: TextInputType.number,
                        focus: true,
                        controll: _cPrice,
                      ),
                    ),
                  ],
                ),
                Form(
                  child: DropDownFormField(
                    titleText: 'Jenis Transaksi',
                    hintText: 'Pilih jenis transaksi',
                    value: _transactionForm,
                    onChanged: (value) {
                      _transactionForm = value;
                    },
                    onSaved: (value) {
                      _transactionForm = value;
                    },
                    dataSource: [
                      {
                        'display': 'Duit Keluar',
                        'value': '0',
                      },
                      {
                        'display': 'Duit Masuk',
                        'value': '1',
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        print(isUpdate);
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Tambah',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        _cName.text.isEmpty
                            ? _namamiss = true
                            : _namamiss = false;
                        _cPrice.text.isEmpty
                            ? _pricemiss = true
                            : _pricemiss = false;
                        if (_namamiss == false &&
                            _pricemiss == false &&
                            _transactionForm.isNotEmpty) {
                          _localCF();
                          tryCalculate(context);
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    },
  );
}

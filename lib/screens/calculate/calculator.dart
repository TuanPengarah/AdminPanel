import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:services_form/screens/priceList/add_price_list.dart';
import 'package:services_form/widget/text_bar.dart';

class CalculatorPrice extends StatefulWidget {
  @override
  _CalculatorPriceState createState() => _CalculatorPriceState();
}

class _CalculatorPriceState extends State<CalculatorPrice> {
  String _hariWaranti = '1';
  String _hariBulan = 'Bulan';
  final _cPrice = TextEditingController();
  String _jumlahHarga = '0.00';
  int _suggestHarga;
  bool _pricemiss = false;

  void dapatWaranti() {
    int i = int.parse(_cPrice.text);
    if (_hariWaranti == '-' && _hariBulan == 'Tiada') {
      _suggestionAI();
    } else if (_hariWaranti == '1' && _hariBulan == 'Bulan') {
      _suggestHarga = 0;
      _suggestionAI();
    } else if (_hariWaranti == '2' && _hariBulan == 'Bulan') {
      i <= 40 ? _suggestHarga = 20 : _suggestHarga = 40;
      _suggestionAI();
    } else if (_hariWaranti == '3' && _hariBulan == 'Bulan') {
      i <= 40 ? _suggestHarga = 30 : _suggestHarga = 60;
      _suggestionAI();
    } else if (_hariWaranti == '1' && _hariBulan == 'Minggu') {
      // i <= 40 ? _suggestHarga = -20 : _suggestHarga = -50;
      _suggestionAI();
    } else if (_hariWaranti == '2' && _hariBulan == 'Minggu') {
      // i <= 40 ? _suggestHarga = -10 : _suggestHarga = -30;
      _suggestionAI();
    } else if (_hariWaranti == '3' && _hariBulan == 'Minggu') {
      _suggestHarga = 0;
      _suggestionAI();
    }
  } //perkiraan waranti

  _suggestionAI() {
    int i = int.parse(_cPrice.text);
    int x = _suggestHarga;
    if (_hariWaranti == '-' && _hariBulan == 'Tiada') {
      i = i + 20;
      return _jumlahHarga = i.toString();
    } else if (_hariWaranti == '1' && _hariBulan == 'Minggu') {
      i = i + 30;
      return _jumlahHarga = i.toString();
    } else if (_hariWaranti == '2' && _hariBulan == 'Minggu') {
      i = i + 35;
      return _jumlahHarga = i.toString();
    }
    if (i <= 60) {
      i = i * 2 + x;
      print('i+i');
      return _jumlahHarga = i.toString();
    } else if (i >= 60 && i < 200) {
      i = i * 2 + x;
      print('i+x');
      return _jumlahHarga = i.toString();
    } else if (i >= 200) {
      i = i + 160 + x;
      print('i+i up');
      return _jumlahHarga = i.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengiraan Harga'),
        centerTitle: true,
        brightness: Brightness.dark,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _cPrice.text.isEmpty ? _pricemiss = true : _pricemiss = false;
                if (_pricemiss == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => AddPriceList(
                        hargaSupplier: int.parse(_cPrice.text),
                      ),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBar(
                  err: _pricemiss
                      ? 'Sila masukkan jumlah harga spareparts'
                      : null,
                  controll: _cPrice,
                  hintTitle: 'Harga Supplier',
                  valueChange: (newValue) {},
                  keyType: TextInputType.number,
                  focus: true,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Form(
                        child: DropDownFormField(
                          titleText: 'Pilih Hari Waranti',
                          hintText: 'Tempoh hari',
                          value: _hariWaranti,
                          onChanged: (value) {
                            setState(() {
                              _hariWaranti = value;
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
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 2,
                      child: Form(
                        child: DropDownFormField(
                          titleText: 'Pilih Bulan Waranti',
                          hintText: 'Tempoh bulan',
                          value: _hariBulan,
                          onChanged: (value) {
                            setState(() {
                              _hariBulan = value;
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
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _cPrice.text.isEmpty
                            ? _pricemiss = true
                            : _pricemiss = false;
                        if (_pricemiss == false) {
                          dapatWaranti();
                          print(_jumlahHarga);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.calculate,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Kira Sekarang!',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Jumlah Harga: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'RM$_jumlahHarga',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'AMARAN: Pengiraan harga ini adalah Versi Beta dan '
                    'kemungkinan besar ia adalah kurang tepat!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

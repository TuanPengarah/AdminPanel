import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/widget/repair_log_dialog.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'inventory.dart';

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
  String _uidSpareparts = '';
  String _hargaSpareparts;
  String _tempohWaranty;
  String _pilihWaranty;
  String _hariBulan;

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    super.dispose();
  }

  @override
  void initState() {
    _tempohWaranty = '1';
    _pilihWaranty = '';
    _hariBulan = 'Bulan';
    _cCash.text = widget.price.toString();
    super.initState();
  }

  void updateSpareparts(String choosing, String partsUID, String hargaParts) {
    setState(() {
      _titleSpareparts = choosing;
      _uidSpareparts = partsUID;
      _hargaSpareparts = hargaParts;
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
      updateSpareparts(choosing[0], choosing[1], choosing[2]);
    }
  }

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
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: IconButton(
                          iconSize: 35,
                          icon: Icon(Icons.close, color: Colors.white),
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
                                    }),
                              ],
                            ),
                          ),
                          Center(
                            child: Card(
                              elevation: 7,
                              child: Container(
                                width: 400,
                                height: 500,
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
                                          chooseSpareparts();
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
                                                value: _tempohWaranty,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _tempohWaranty = value;
                                                  });
                                                },
                                                onSaved: (value) {
                                                  setState(() {
                                                    _tempohWaranty = value;
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
                                                ],
                                                textField: 'display',
                                                valueField: 'value',
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Form(
                                              child: DropDownFormField(
                                                titleText: 'Pilih Waranti',
                                                hintText:
                                                    'Pilih tempoh waranti',
                                                value: _hariBulan,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _hariBulan = value;
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
                                            const EdgeInsets.only(top: 15.0),
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
                                                      _hargaSpareparts != null
                                                          ? 'Disarankan '
                                                              'RM$_hargaSpareparts'
                                                          : '',
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
                                            const EdgeInsets.only(top: 45.0),
                                        child: SizedBox(
                                          height: 48,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.teal),
                                            child: Text(
                                              'BAYAR',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {},
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

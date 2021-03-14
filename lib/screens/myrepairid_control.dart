import 'dart:async';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:services_form/brain/myrepairid_update.dart';
import 'package:services_form/brain/repair_log_suggestion.dart';
import 'package:services_form/widget/text_bar.dart';

class EditMyRepairID extends StatefulWidget {
  final mid;
  final nama;
  final model;
  final remarks;
  final status;
  final password;
  final kerosakkan;
  final percent;
  final technician;
  final tarikh;
  final noPhone;
  final uid;

  EditMyRepairID({
    this.mid,
    this.nama,
    this.model,
    this.remarks,
    this.status,
    this.password,
    this.kerosakkan,
    this.percent,
    this.technician,
    this.tarikh,
    this.noPhone,
    this.uid,
  });

  @override
  _EditMyRepairIDState createState() => _EditMyRepairIDState();
}

class _EditMyRepairIDState extends State<EditMyRepairID> {
  final crepairLog = TextEditingController();
  bool errorLine = false;
  int _start = 10;
  double _value = 0.0;
  bool _autoSave = false;
  Timer _timer;

  void stopTimer() {
    _autoSave = false;
    _timer.cancel();
  }

  void startCount() {
    _start = 10;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_start > 0) {
            _autoSave = true;
            _start--;
          } else {
            _autoSave = false;
            _timer.cancel();
            MridUpdate(
                    passID: widget.mid,
                    passPercent: _value,
                    passErrorLog: errorLine,
                    passRepairLog: crepairLog.text,
                    passUID: widget.uid)
                .updateData();
            Future.delayed(const Duration(milliseconds: 200), () {
              Navigator.pop(context);
            });
          }
        });
      },
    );
  }

  void checkLog() {
    if (_value <= 1) {
      crepairLog.text = 'Pesanan diterima';
    } else if (_value <= 10) {
      crepairLog.text = 'Menunggu giliran';
    } else if (_value <= 15) {
      crepairLog.text = 'Memulakan proses diagnosis';
    } else if (_value <= 18) {
      crepairLog.text = 'Proses diagnosis selesai';
    } else if (_value <= 21) {
      crepairLog.text = 'Memulakan proses membaiki';
    } else if (_value <= 50) {
      crepairLog.text = 'Menyelaraskan sparepart baru kepada peranti anda';
    } else if (_value <= 65) {
      crepairLog.text = 'Semua alat sparepart baru berfungsi dengan baik';
    } else if (_value <= 70) {
      crepairLog.text = 'Memasang semula peranti anda';
    } else if (_value <= 80) {
      crepairLog.text = 'Melakukan proses diagnosis buat kali terakhir';
    } else if (_value <= 90) {
      crepairLog.text = 'Proses membaiki selesai';
    } else if (_value <= 95) {
      crepairLog.text = 'Pihak kami cuba untuk menghubungi anda';
    } else if (_value <= 98) {
      crepairLog.text = 'Maklumat telah diberitahu kepada anda';
    } else if (_value <= 100) {
      crepairLog.text = 'Selesai';
    }
  }

  @override
  void initState() {
    _value = widget.percent * 100;

    super.initState();
  }

  @override
  void dispose() {
    _autoSave == true ? _timer.cancel() : _start = 10;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final mySystemTheme = isDarkMode == false
        ? SystemUiOverlayStyle.dark
            .copyWith(systemNavigationBarColor: Colors.blueGrey)
        : SystemUiOverlayStyle.light
            .copyWith(systemNavigationBarColor: Colors.blueGrey);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: mySystemTheme,
      child: DismissiblePage(
        minRadius: 1,
        onDismiss: () {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ));
          Navigator.of(context).pop();
        },
        child: Hero(
          tag: widget.mid,
          child: Scaffold(
            bottomNavigationBar: BottomAppBar(
              color: Colors.blueGrey,
              child: Container(
                height: 60,
                child: InkWell(
                  onTap: () {
                    MridUpdate(
                            passID: widget.mid,
                            passPercent: _value,
                            passErrorLog: errorLine,
                            passRepairLog: crepairLog.text,
                            passUID: widget.uid)
                        .updateData();
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      _autoSave == false ? 'Simpan' : 'Menyimpan dalam $_start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0, left: 15.0, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18),
                    Text(
                      'Kemaskini Status',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.nama} | ${widget.model}'),
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: Text(
                                'Catatan: ',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                                '${widget.remarks} | Password (${widget.password}).'),
                            // StreamBuilder(
                            //   stream: FirebaseFirestore.instance
                            //       .collection('MyrepairID')
                            //       .doc(widget.mid)
                            //       .collection('repair log')
                            //       .orderBy('Waktu')
                            //       .snapshots(),
                            //   builder: (BuildContext context,
                            //       AsyncSnapshot<dynamic> snapshot) {
                            //     if (!snapshot.hasData) {
                            //       return Center(
                            //         child: Text('Loading jap'),
                            //       );
                            //     }
                            //     return Column(children:
                            //         snapshot.data.docs.map((document) {
                            //       return Text(document['Repair Log']);
                            //     }).toList(),);
                            //   },
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Divider(
                                height: 60,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Status MyRepair ID: ',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text(
                                'Repair Log: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextBar(
                              controll: crepairLog,
                              notSuggest: true,
                              onClickSuggestion: (suggestion) {
                                crepairLog.text = suggestion.toString();
                                if (crepairLog.text == '1% Pesanan diterima') {
                                  _value = 1;
                                } else if (crepairLog.text ==
                                    'Menunggu giliran') {
                                  _value = 10;
                                } else if (crepairLog.text ==
                                    'Memulakan proses diagnosis') {
                                  _value = 15;
                                } else if (crepairLog.text ==
                                    'Proses diagnosis selesai') {
                                  _value = 18;
                                } else if (crepairLog.text ==
                                    'Memulakan proses membaiki') {
                                  _value = 21;
                                } else if (crepairLog.text ==
                                    'Menyelaraskan sparepart baru kepada peranti anda') {
                                  _value = 50;
                                } else if (crepairLog.text ==
                                    'Semua alat sparepart baru berfungsi dengan baik') {
                                  _value = 65;
                                } else if (crepairLog.text ==
                                    'Memasang semula peranti anda') {
                                  _value = 70;
                                } else if (crepairLog.text ==
                                    'Melakukan proses diagnosis buat kali terakhir') {
                                  _value = 80;
                                } else if (crepairLog.text ==
                                    'Proses membaiki selesai') {
                                  _value = 90;
                                } else if (crepairLog.text ==
                                    'Pihak kami cuba untuk menghubungi anda') {
                                  _value = 95;
                                } else if (crepairLog.text ==
                                    'Maklumat telah diberitahu kepada anda') {
                                  _value = 98;
                                } else if (crepairLog.text == 'Selesai') {
                                  _value = 100;
                                }
                              },
                              callBack: (pattern) {
                                return RepairLogSuggestion.getSuggestions(
                                    pattern);
                              },
                              builder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion),
                                  // subtitle: Text('${suggestion['id']}'),
                                );
                              },
                              hintTitle: 'Masukkan status Repair Log',
                              valueChange: (value) {},
                              keyType: TextInputType.name,
                              focus: false,
                              max: 2,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    checkColor: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    value: errorLine,
                                    onChanged: (value) {
                                      setState(() {
                                        stopTimer();
                                        errorLine == false
                                            ? errorLine = true
                                            : errorLine = false;
                                      });
                                    }),
                                Text('Error Log'),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Peratus Keseluruhan: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: FluidSlider(
                                onChangeStart: (value) {
                                  _autoSave == true
                                      ? _timer.cancel()
                                      : _start = 10;
                                  _autoSave = false;
                                },
                                onChangeEnd: (value) {
                                  startCount();
                                },
                                valueTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                                sliderColor: Colors.teal,
                                value: _value,
                                onChanged: (double newValue) {
                                  setState(() {
                                    _value = newValue;
                                  });
                                  checkLog();
                                },
                                min: 0,
                                max: 100,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      if (_value <= 0) {
                                        _value = 0;
                                      }
                                      if (_value > 1) {
                                        _autoSave == true
                                            ? stopTimer()
                                            : print(
                                                'Allahumma Solli Alla Muhammad');
                                        setState(() {
                                          _value--;
                                          checkLog();
                                        });
                                      } else {
                                        _value = 0;
                                      }
                                    }),
                                IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    onPressed: () {
                                      if (_value >= 100) {
                                        _value = 100;
                                      }
                                      if (_value < 100) {
                                        _autoSave == true
                                            ? stopTimer()
                                            : print(
                                                'Allahumma Solli Alla Muhammad');
                                        setState(() {
                                          _value++;
                                          checkLog();
                                        });
                                      } else {
                                        _value = 100;
                                      }
                                    })
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

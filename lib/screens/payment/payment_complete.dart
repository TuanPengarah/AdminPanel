import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/screens/print/print_payment_receipt.dart';
import 'package:vibration/vibration.dart';
// import 'package:audioplayers/audio_cache.dart';
import 'package:services_form/pdf/generate.dart';

class PaymentsCompleted extends StatefulWidget {
  final nama;
  final model;
  final noPhone;
  final warantiStart;
  final warantiAkhir;
  final harga;
  final kerosakkan;
  final tukarParts;
  final warantiText;
  final mid;

  PaymentsCompleted(
      {@required this.nama,
      @required this.model,
      @required this.noPhone,
      @required this.warantiStart,
      @required this.warantiAkhir,
      @required this.harga,
      @required this.kerosakkan,
      @required this.tukarParts,
      @required this.mid,
      @required this.warantiText});

  @override
  _PaymentsCompletedState createState() => _PaymentsCompletedState();
}

class _PaymentsCompletedState extends State<PaymentsCompleted>
    with TickerProviderStateMixin {
  AnimationController _controller;

  // void playSound() {
  //   final player = AudioCache();
  //   player.play('apple_pay.mp3');
  // }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      Vibration.vibrate(pattern: [100, 30, 100, 30]);
      // playSound();
    });
    _controller = AnimationController(vsync: this)
      ..value = 0
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 10),
      () {
        _controller.duration = Duration(seconds: 2);
        _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final mySystemTheme = isDarkMode == false
        ? SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark)
        : SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light);
    return AnnotatedRegion(
      value: mySystemTheme,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_outlined),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    Center(
                      child: Lottie.asset(
                        'lottie/money.json',
                        height: 100,
                        controller: _controller,
                        onLoaded: (composition) {
                          setState(
                            () {
                              // _controller.duration = composition.duration;
                            },
                          );
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          'Pembayaran Berjaya!',
                          style: TextStyle(
                            color:
                                isDarkMode == true ? Colors.white : kCompColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'NAMA : ',
                                style: TextStyle(
                                  color: isDarkMode == true
                                      ? Colors.white
                                      : kCompColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  widget.nama,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'NO TELEFON :  ',
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.noPhone,
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'MODEL :  ',
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.model,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDarkMode == true
                                          ? Colors.white
                                          : kCompColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'KEROSAKKAN :  ',
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.kerosakkan,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDarkMode == true
                                          ? Colors.white
                                          : kCompColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'SPAREPARTS:  ',
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.tukarParts.toString().toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isDarkMode == true
                                          ? Colors.white
                                          : kCompColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'WARANTI :  ',
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.warantiText.toString().toUpperCase(),
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TARIKH MULA :  ',
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.warantiStart,
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TARIKH AKHIR :  ',
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.warantiAkhir,
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'JUMLAH HARGA :  ',
                                  style: TextStyle(
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'RM${widget.harga}',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: isDarkMode == true
                                        ? Colors.white
                                        : kCompColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: isDarkMode == true
                              ? Color(0xff27d7e0)
                              : kCompColor,
                        ),
                        onPressed: () {
                          Future.delayed(Duration(milliseconds: 300), () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (b) => PrintPayments(
                                  nama: widget.nama,
                                  model: widget.model,
                                  noPhone: widget.noPhone,
                                  warantiStart: widget.warantiStart,
                                  warantiAkhir: widget.warantiAkhir,
                                  harga: widget.harga,
                                  kerosakkan: widget.kerosakkan,
                                  tukarParts: widget.tukarParts,
                                  warantiText: widget.warantiText,
                                ),
                              ),
                            );
                          });
                        },
                        icon: Icon(Icons.print),
                        label: Text('Print'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary:
                                isDarkMode == true ? Colors.red : Colors.teal,
                          ),
                          onPressed: () {
                            SystemChrome.setSystemUIOverlayStyle(
                                SystemUiOverlayStyle(
                                    systemNavigationBarColor: Colors.black,
                                    systemNavigationBarIconBrightness:
                                        Brightness.light));
                            reportView(
                              context: context,
                              nama: widget.nama,
                              model: widget.model,
                              noPhone: widget.noPhone,
                              warantiStart: widget.warantiStart,
                              warantiAkhir: widget.warantiAkhir,
                              harga: widget.harga,
                              kerosakkan: widget.kerosakkan,
                              tukarParts: widget.tukarParts,
                              warantiText: widget.warantiText,
                              mid: widget.mid,
                            );
                          },
                          label: Text('Simpan dalam PDF'),
                          icon: Icon(Icons.file_copy),
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

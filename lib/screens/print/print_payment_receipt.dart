import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:io' show Platform;
import 'package:image/image.dart';

class PrintPayments extends StatefulWidget {
  final nama;
  final model;
  final noPhone;
  final warantiStart;
  final warantiAkhir;
  final harga;
  final kerosakkan;
  final tukarParts;
  final warantiText;

  PrintPayments(
      {@required this.nama,
      @required this.model,
      @required this.noPhone,
      @required this.warantiStart,
      @required this.warantiAkhir,
      @required this.harga,
      @required this.kerosakkan,
      @required this.tukarParts,
      @required this.warantiText});
  @override
  _PrintPaymentsState createState() => _PrintPaymentsState();
}

class _PrintPaymentsState extends State<PrintPayments> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void initState() {
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) return;
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Bluetooth di tutup!');
        }
      });
    } else {
      initPrinter();
    }

    super.initState();
  }

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 3));
    _printerManager.scanResults.listen((val) {
      print(val);
      if (!mounted) return;
      setState(() => _devices = val);
      if (_devices.isEmpty)
        setState(() => _devicesMsg = 'Tiada peranti berdekatan');
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result =
        await _printerManager.printTicket(await _ticket(PaperSize.mm58));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);

    // Image assets
    final ByteData data = await rootBundle.load('assets/thermal.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = decodeImage(bytes);
    ticket.image(image);
    ticket.text(
      'AF-FIX',
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2),
      // linesAfter: 1,
    );
    ticket.text('Smarthone Repair Specialist',
        styles: PosStyles(align: PosAlign.center));
    ticket.text('Jalan Sentosa, Sungai Ramal Baru, 43000 Kajang',
        styles: PosStyles(align: PosAlign.center));
    ticket.text('Tel: 011-11426421', styles: PosStyles(align: PosAlign.center));
    ticket.text('www.af-fix.cf',
        styles: PosStyles(align: PosAlign.center, underline: true));

    ticket.feed(1);
    ticket.text('RESIT WARANTI',
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.feed(1);
    ticket.text('Maklumat:', styles: PosStyles(align: PosAlign.left));
    ticket.text('Nama: ${widget.nama}',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Nombor tel: ${widget.noPhone}',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Model: ${widget.model}',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Kerosakkan: ${widget.kerosakkan}',
        styles: PosStyles(align: PosAlign.left));
    ticket.feed(1);
    ticket.hr();
    ticket.row([
      PosColumn(text: 'Parts yang ditukar', width: 12),
    ]);
    ticket.feed(1);
    ticket.row([
      PosColumn(text: '${widget.tukarParts}', width: 12),
    ]);
    ticket.row([
      PosColumn(text: '(${widget.warantiText} Waranti)', width: 12),
    ]);
    ticket.hr();
    ticket.row([
      PosColumn(
          text: 'JUMLAH',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: 'RM${widget.harga}',
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
    ]);
    ticket.hr(ch: '=', linesAfter: 1);
    ticket.text(
        'Waranti bermula dari ${widget.warantiStart} sehingga ${widget.warantiAkhir}',
        styles: PosStyles(align: PosAlign.center));
    ticket.text('Simpan resit ini bagi tujuan \nwaranti',
        styles: PosStyles(align: PosAlign.center));
    ticket.feed(1);
    ticket.text('Terima Kasih!',
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.cut();

    return ticket;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Print resit'), brightness: Brightness.dark),
      body: _devices.isEmpty
          ? Center(child: Text(_devicesMsg ?? ''))
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: Icon(Icons.print),
                  title: Text(_devices[i].name),
                  subtitle: Text(_devices[i].address),
                  onTap: () {
                    _startPrint(_devices[i]);
                  },
                );
              },
            ),
    );
  }
}

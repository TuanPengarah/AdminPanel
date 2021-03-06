import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:io' show Platform;
import 'package:image/image.dart';

class Print extends StatefulWidget {
  final dataname;
  final dataphone;
  final datamodel;
  final datapass;
  final datadmg;
  final dataangg;
  final dataremarks;
  final datauid;

  Print(
      {this.dataname,
      this.dataphone,
      this.datamodel,
      this.datapass,
      this.datadmg,
      this.dataangg,
      this.dataremarks,
      this.datauid});

  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void initState() {
    print(widget.datauid);
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

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 4));
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
        await _printerManager.printTicket(await _ticket(PaperSize.mm80));
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
    ticket.text('Resit Drop Off Peranti',
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.text('MyRepair ID: ${widget.datauid}',
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.feed(1);
    ticket.text('Nama: ${widget.dataname}',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Nombor tel:${widget.dataphone}',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Model: ${widget.datamodel}',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Kerosakkan: ${widget.datadmg}',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Anggaran Harga: RM${widget.dataangg}',
        styles: PosStyles(align: PosAlign.left));
    ticket.text('Remarks: *${widget.dataremarks}',
        styles: PosStyles(align: PosAlign.left));

    ticket.feed(2);
    ticket.text('Terima Kasih',
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.cut();

    return ticket;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }
}

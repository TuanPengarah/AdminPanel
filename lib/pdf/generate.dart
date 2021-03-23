import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
import 'pdf_viewer.dart';
import 'package:flutter/services.dart';

reportView({
  context,
  nama,
  model,
  noPhone,
  kerosakkan,
  harga,
  warantiStart,
  warantiAkhir,
  tukarParts,
  warantiText,
  mid,
}) async {
  final Document pdf = Document();
  var assetImage = PdfImage.file(
    pdf.document,
    bytes: (await rootBundle.load('assets/logoBlack.png')).buffer.asUint8List(),
  );
  pdf.addPage(
    MultiPage(
      pageFormat: PdfPageFormat.a5,
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            // margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            // padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: PdfColors.grey,
                ),
              ),
            ),
            child: Text('Resit Waranti',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
        Header(
          level: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Resit Waranti', textScaleFactor: 2),
                Text('Ref id: $mid', style: TextStyle(color: PdfColors.grey))
              ]),
              Image(assetImage, height: 50),
            ],
          ),
        ),
        // Header(level: 3, text: 'Maklumat :'),
        Text('Nama: $nama'),
        SizedBox(height: 5),
        Text('No Telefon: $noPhone'),
        SizedBox(height: 5),
        Text('Model: $model'),
        SizedBox(height: 5),
        Text(
          'Kerosakkan: $kerosakkan',
        ),
        // Header(level: 3, text: 'Parts yang ditukar'),
        Padding(padding: const EdgeInsets.all(10)),
        Table.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>['Parts yang ditukar', 'Harga'],
            <String>[
              '${tukarParts.toString().toUpperCase()} ($warantiText '
                  'Waranti)',
              'RM$harga'
            ],
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'JUMLAH',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'RM$harga',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 150),
        Center(
          child: Text(
            'Waranti bermula dari $warantiStart sehingga '
            '$warantiAkhir. Simpan resit ini bagi tujuan waranti',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),
        Center(
          child: Text(
            'TERIMA KASIH!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    ),
  );
  //save PDF
  String titleName = 'ResitWaranti-${nama.toString()}${mid.toString()}';
  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/$titleName-resit.pdf';
  print(dir);
  final File file = File(path);
  await file.writeAsBytes(pdf.save());
  // await Printing.sharePdf(bytes: await pdf.save(), filename: 'my-document.pdf');
  // await Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => pdf.save());
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PdfViewerPage(
        path: path,
        pdff: pdf,
        title: titleName,
      ),
    ),
  );
}

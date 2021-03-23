import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'dart:io';

class PdfViewerPage extends StatelessWidget {
  final String path;
  final pdff;
  final title;
  const PdfViewerPage({Key key, this.path, this.pdff, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Invois Pelanggan'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final String dir =
                  (await getApplicationDocumentsDirectory()).path;
              final String path = '$dir/report.pdf';
              print(dir);
              final File file = File(path);
              await file.writeAsBytes(pdff.save());
              await Printing.sharePdf(
                  bytes: await pdff.save(), filename: '$title.pdf');
            },
          ),
        ],
      ),
      path: path,
    );
  }
}

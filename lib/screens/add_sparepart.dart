import 'package:flutter/material.dart';
import 'package:services_form/widget/text_bar.dart';

class AddSparepart extends StatefulWidget {
  @override
  _AddSparepartState createState() => _AddSparepartState();
}

class _AddSparepartState extends State<AddSparepart> {
  final sparepart = TextEditingController();
  final type = TextEditingController();
  final supplier = TextEditingController();
  final quantity = TextEditingController();

  bool _sparepartsmiss = false;
  bool _typemiss = false;
  bool _suppliermiss = false;
  bool _quantitymiss = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          setState(() {
            sparepart.text.isEmpty
                ? _sparepartsmiss = true
                : _sparepartsmiss = false;
            type.text.isEmpty ? _typemiss = true : _typemiss = false;
            supplier.text.isEmpty
                ? _suppliermiss = true
                : _suppliermiss = false;
            quantity.text.isEmpty
                ? _quantitymiss = true
                : _quantitymiss = false;
          });
        },
      ),
      appBar: AppBar(
        title: Text('Add Sparepart'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextBar(
              controll: sparepart,
              hintTitle: 'Model',
              focus: true,
              valueChange: (vmodel) {},
              keyType: TextInputType.name,
              err: _sparepartsmiss ? 'Sila masukkan model smartphone' : null,
            ),
            TextBar(
              controll: type,
              hintTitle: 'Jenis Spareparts',
              focus: true,
              valueChange: (vtype) {},
              keyType: TextInputType.name,
              err: _typemiss ? 'Sila masukkan jenis spareparts' : null,
            ),
            TextBar(
              controll: supplier,
              hintTitle: 'Supplier',
              focus: true,
              valueChange: (vsupplier) {},
              keyType: TextInputType.name,
              err: _suppliermiss ? 'Sila masukkan nama supplier' : null,
            ),
            TextBar(
              controll: quantity,
              hintTitle: 'Kuantiti',
              focus: true,
              valueChange: (vquantity) {},
              keyType: TextInputType.number,
              err: _quantitymiss ? 'Sila masukkan kuantiti' : null,
            ),
          ],
        ),
      ),
    );
  }
}

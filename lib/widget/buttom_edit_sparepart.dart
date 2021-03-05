import 'package:flutter/material.dart';
import 'package:services_form/widget/text_bar.dart';

class EditSparepart {
  //pass data
  final sparepart;
  final supplier;
  final quantity;
  final manufactor;
  final details;

  EditSparepart(
      {this.sparepart,
      this.supplier,
      this.quantity,
      this.manufactor,
      this.details});
  //text controller
  final _csparepart = TextEditingController();
  final _csupplier = TextEditingController();
  final _quantity = TextEditingController();
  final _manufactor = TextEditingController();
  final _details = TextEditingController();

  showEditdb(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Edit Spareparts',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextBar(
                  focus: false,
                  controll: _csparepart,
                  hintTitle: 'Masukkan nama sparepart baru',
                  hintEdit: '$sparepart',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: _csupplier,
                  hintTitle: 'Masukkan supplier baru',
                  hintEdit: '$supplier',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: _quantity,
                  hintTitle: 'Masukkan kuantiti baru',
                  hintEdit: '$quantity',
                  keyType: TextInputType.number,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: _manufactor,
                  hintTitle: 'Masukkan kualiti spareparts',
                  hintEdit: '$manufactor',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                TextBar(
                  focus: false,
                  controll: _details,
                  hintTitle: 'Masukkan maklumat spareparts',
                  hintEdit: '$details',
                  keyType: TextInputType.name,
                  valueChange: (value) {},
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Kemaskini'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

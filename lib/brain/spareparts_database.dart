import 'package:firebase_database/firebase_database.dart';

class BioSpareparts {
  String key;
  String sparepart;
  String type;
  String supplier;
  String quantity;
  String manufactor;
  String details;
  String date;

  BioSpareparts(this.sparepart, this.type, this.supplier, this.quantity,
      this.manufactor, this.details, this.date);

  BioSpareparts.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        sparepart = snapshot.value['Model'],
        type = snapshot.value['Jenis Spareparts'],
        supplier = snapshot.value['Supplier'],
        quantity = snapshot.value['Kuantiti'],
        manufactor = snapshot.value['Kualiti'],
        details = snapshot.value['Maklumat Spareparts'],
        date = snapshot.value['Tarikh'];

  toJson() {
    return {
      'Model': sparepart,
      'Jenis Spareparts': type,
      'Supplier': supplier,
      'Kuantiti': quantity,
      'Kualiti': manufactor,
      'Maklumat Spareparts': details,
      'Tarikh': date,
    };
  }
}

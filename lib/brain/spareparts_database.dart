import 'package:firebase_database/firebase_database.dart';

class BioSpareparts {
  String key;
  String sparepart;
  String type;
  String supplier;
  String manufactor;
  String details;
  String date;
  String price;

  BioSpareparts(
    this.sparepart,
    this.type,
    this.supplier,
    this.manufactor,
    this.details,
    this.date,
    this.price,
  );

  BioSpareparts.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        sparepart = snapshot.value['Model'],
        type = snapshot.value['Jenis Spareparts'],
        supplier = snapshot.value['Supplier'],
        manufactor = snapshot.value['Kualiti'],
        details = snapshot.value['Maklumat Spareparts'],
        date = snapshot.value['Tarikh'],
        price = snapshot.value['Harga'];

  toJson() {
    return {
      'Model': sparepart,
      'Jenis Spareparts': type,
      'Supplier': supplier,
      'Kualiti': manufactor,
      'Maklumat Spareparts': details,
      'Tarikh': date,
      'Harga': price,
    };
  }
}

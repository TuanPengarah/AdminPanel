import 'package:firebase_database/firebase_database.dart';

class DatabaseSparepart {
  String key;
  String sparepart;
  String type;
  String supplier;
  String date;

  DatabaseSparepart({
    this.sparepart,
    this.type,
    this.supplier,
    this.date,
  });

  DatabaseSparepart.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        sparepart = snapshot.value['Model Spareparts'],
        type = snapshot.value['Jenis Spareparts'],
        supplier = snapshot.value['Supplier'],
        date = snapshot.value['Tarikh'];

  toJson() {
    return {
      'Spareparts': sparepart,
      'Jenis Spareparts': type,
      'Supplier': supplier,
      'Tarikh': date,
    };
  }
}

import 'package:firebase_database/firebase_database.dart';

class BioDatabase {
  String key;
  String name;
  String num;
  String email;
  String model;
  String pass;
  String dmg;
  String price;
  String remarks;

  BioDatabase(
      {this.name,
      this.num,
      this.email,
      this.model,
      this.pass,
      this.dmg,
      this.price,
      this.remarks});

  //fetch data ke database
  BioDatabase.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        num = snapshot.value['num'],
        email = snapshot.value['email'],
        model = snapshot.value['model'],
        pass = snapshot.value['pass'],
        dmg = snapshot.value['dmg'],
        price = snapshot.value['price'],
        remarks = snapshot.value['remarks'];

  toJson() {
    return {
      'nama': name,
      'nombor untuk dihubungi': num,
      'email': email,
      'model': model,
      'pass': pass,
      'kerosakkan': dmg,
      'anggaran harga': price,
      'remarks': remarks,
    };
  }
}

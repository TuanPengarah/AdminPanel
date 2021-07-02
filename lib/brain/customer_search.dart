import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerSuggestion {
  String title;
  String phoneNumber;
  String uid;

  CustomerSuggestion({this.title});
  CustomerSuggestion.getCustomer(DocumentSnapshot snapshot) {
    title = snapshot['Nama'];
    phoneNumber = snapshot['No Phone'];
    uid = snapshot.id;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:services_form/widget/card_payment.dart';
import 'package:flutter/services.dart';
import 'package:services_form/screens/transaction_setting.dart';
import 'package:dismissible_page/dismissible_page.dart';

class SalesPendingPayments extends StatefulWidget {
  @override
  _SalesPendingPaymentsState createState() => _SalesPendingPaymentsState();
}

class _SalesPendingPaymentsState extends State<SalesPendingPayments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Pending Payments'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
            child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('MyrepairID')
              .where('Percent', isEqualTo: 1)
              .where('isPayment', isEqualTo: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('Loading Jap...'),
                  ),
                ],
              );
            }
            return ListView(
              children: snapshot.data.docs.map(
                (document) {
                  return CardPayments(
                      onPress: () {
                        Future.delayed(const Duration(milliseconds: 200), () {
                          context.pushTransparentRoute(
                            TransactionSetting(
                                noPhone: document['No Phone'],
                                mid: document.id,
                                model: document['Model'],
                                nama: document['Nama'],
                                price: document['Harga'],
                                kerosakkan: document['Kerosakkan'],
                                remarks: document['Remarks']),
                          );
                        });
                        SystemChrome.setSystemUIOverlayStyle(
                            SystemUiOverlayStyle(
                                systemNavigationBarColor: Colors.blueGrey));
                      },
                      price: document['Harga'],
                      mid: document.id,
                      model: document['Model'],
                      noPhone: document['No Phone'],
                      nama: document['Nama'],
                      uid: document['Database UID'],
                      rosak: document['Kerosakkan'],
                      status: document['Status']);
                },
              ).toList(),
            );
          },
        )),
      ),
    );
  }
}

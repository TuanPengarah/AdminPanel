import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:services_form/widget/card_details.dart';

SliverChildListDelegate repairHistory(String passID) {
  return SliverChildListDelegate(
    [
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('customer')
            .doc(passID)
            .collection('repair history')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Loading jap'),
            );
          }
          return Column(
            children: snapshot.data.docs.map((document) {
              return CardDetails(
                model: document['Model'],
                harga: document['Harga'],
                kerosakkan: document['Kerosakkan'],
                mid: document['MID'],
                remarks: document['Remarks'],
                status: document['Status'],
                tarikh: document['Tarikh'],
                technician: document['Technician'],
                timestamp: document['timeStamp'],
                password: document['Password'],
              );
            }).toList(),
          );
        },
      ),
      SizedBox(
        height: 400,
      )
    ],
  );
}

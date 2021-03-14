import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget repairLogDialog(mid) {
  return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MyrepairID')
            .doc(mid)
            .collection('repair log')
            .orderBy('timeStamp', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Loading jap'),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: snapshot.data.docs.map<Widget>(
                (document) {
                  bool errorLine = document['isError'];
                  return Text(
                    '<${document['Waktu']}>  ${document['Repair Log']}',
                    style: TextStyle(
                      color: errorLine == false ? Colors.green : Colors.red,
                    ),
                  );
                },
              ).toList(),
            ),
          );
        },
      ));
}

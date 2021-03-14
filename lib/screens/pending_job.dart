import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:services_form/screens/myrepairid_control.dart';

class PendingJob extends StatefulWidget {
  @override
  _PendingJobState createState() => _PendingJobState();
}

class _PendingJobState extends State<PendingJob> {
  double checkPercent = 0.0;
  @override
  void initState() {
    if (checkPercent > 100) {
      checkPercent = 100;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyRepair ID',
        ),
        brightness: Brightness.dark,
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('MyrepairID')
              .orderBy('timeStamp')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

            return ListView(
                children: snapshot.data.docs.map((document) {
              double progress = document['Percent'];
              checkPercent = progress;
              currentProgressColor() {
                if (progress >= 0.4 && progress < 0.6) {
                  return Colors.yellow[600];
                }
                if (progress >= 0.8) {
                  return Colors.green;
                } else {
                  return Colors.red[300];
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                child: Hero(
                  tag: document.id,
                  child: Card(
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 200), () {
                          context.pushTransparentRoute(EditMyRepairID(
                            mid: document.id,
                            kerosakkan: document['Kerosakkan'],
                            model: document['Model'],
                            nama: document['Nama'],
                            noPhone: document['No Phone'],
                            password: document['Password'],
                            percent: document['Percent'],
                            remarks: document['Remarks'],
                            status: document['Status'],
                            tarikh: document['Tarikh'],
                            technician: document['Technician'],
                            uid: document['UID'],
                          ));
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              //Tajuk, parts dengan MyRepairID
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    document['Model'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      document['Kerosakkan'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      document.id.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                document['Nama'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                document['No Phone'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            LinearPercentIndicator(
                              leading: Icon(Icons.history, color: Colors.grey),
                              trailing: Icon(Icons.done, color: Colors.grey),
                              width: MediaQuery.of(context).size.width - 110,
                              lineHeight: 3.2,
                              percent: checkPercent,
                              progressColor: currentProgressColor(),
                            ),
                            Center(
                              child: Text(
                                'PERATUS UNTUK SIAP:',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                ' ${document['Percent'] * 100.round()}%',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'RM ${document['Harga'].toString()}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    document['Tarikh'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList());
          },
        ),
      ),
    );
  }
}

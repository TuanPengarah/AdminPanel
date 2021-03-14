import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';

class MridUpdate {
  final passRepairLog;
  final double passPercent;
  final bool passErrorLog;
  final passID;
  final passUID;

  MridUpdate(
      {this.passRepairLog,
      this.passErrorLog,
      this.passPercent,
      this.passID,
      this.passUID});

//generate untuk tarikh baru (Device Time)
  waktu() {
    var now = new DateTime.now();
    var formatter = new DateFormat('hh:mm a');
    return formatter.format(now);
  }

  updateData() {
    //convert device calculation ke format database
    var percentConverter = double.parse((passPercent / 100).toStringAsFixed(2));
    percentConverter.round();

    Map<String, dynamic> repairLog = {
      'Repair Log': passRepairLog.toString(),
      'Waktu': waktu(),
      'isError': passErrorLog
    };

    Map<String, dynamic> updateStatus = {
      'Percent': percentConverter,
    };
    if (percentConverter == 1) {
      FirebaseFirestore.instance
          .collection('customer')
          .doc(passUID)
          .collection('repair history')
          .doc(passID)
          .update({'Status': 'Selesai'});
    }
    //Update Percent Status
    FirebaseFirestore.instance
        .collection('MyrepairID')
        .doc(passID)
        .update(updateStatus);
    //Repair Log
    FirebaseFirestore.instance
        .collection('MyrepairID')
        .doc(passID)
        .collection('repair log')
        .add(repairLog)
        .then((value) =>
            showToast('Kemaskini berjaya', position: ToastPosition.bottom))
        .catchError((error) => showToast('Gagal untuk kemaskini: $error',
            position: ToastPosition.bottom));
  }
}

import 'package:flutter/material.dart';
import 'package:services_form/widget/card_customer_details.dart';
import 'package:url_launcher/url_launcher.dart';

SliverChildListDelegate profile({
  String datUID,
  String noFon,
  String email,
  Function addJobsheet,
  String nama,
}) {
  _launchCaller() async {
    final url = "tel:$noFon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchEmail() async {
    final url =
        "mailto:$email?subject=Pemberitahuan daripada Af-fix&body=Salam $nama,";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchSms() async {
    final url = "sms:$noFon";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  return SliverChildListDelegate(
    [
      Container(
        height: 200,
        child: Card(
          child: InkWell(
            onTap: addJobsheet,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Tambah Jobsheet baru untuk customer ini'),
                ),
              ],
            ),
          ),
        ),
      ),
      CardsCustomerDetails(
        icon: Icons.date_range,
        title: 'Database UID',
        subtitle: datUID,
        onPress: () {},
      ),
      CardsCustomerDetails(
        icon: Icons.phone,
        title: 'Nombor Telefon',
        subtitle: noFon,
        onPress: () {
          _launchCaller();
        },
      ),
      CardsCustomerDetails(
        icon: Icons.message,
        title: 'Mesej',
        subtitle: noFon,
        onPress: () {
          _launchSms();
        },
      ),
      CardsCustomerDetails(
        icon: Icons.email,
        title: 'Email',
        subtitle: email,
        onPress: () {
          _launchEmail();
        },
      ),
      SizedBox(
        height: 100,
      )
    ],
  );
}

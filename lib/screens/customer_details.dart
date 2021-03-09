import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_letter/avatar_letter.dart';
import 'package:services_form/screens/job_sheet.dart';
import 'package:services_form/widget/buttom_edit_customer.dart';
import 'package:services_form/widget/confirmation_delete_customer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetails extends StatefulWidget {
  final nama;
  final phone;
  final model;
  final id;
  final email;
  final remarks;
  final uid;
  final password;
  final price;

  CustomerDetails({
    this.nama,
    this.phone,
    this.model,
    this.id,
    this.uid,
    this.email,
    this.remarks,
    this.price,
    this.password,
  });

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  _launchCaller() async {
    final url = "tel:${widget.phone}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchEmail() async {
    final url =
        "mailto:${widget.email}?subject=Pemberitahuan daripada Af-fix&body=Salam ${widget.nama},";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchSms() async {
    final url = "sms:${widget.phone}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        Editdb(
          name: widget.nama,
          phone: widget.phone,
          email: widget.email,
          docid: widget.id,
        ).showEditdb(context);
        break;
      case 'Buang':
        ShowAlert(docid: widget.id, nama: widget.nama).showAlertDialog(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    String passID = widget.id;
    return Scaffold(
      backgroundColor: isDarkMode == true ? Colors.black26 : Colors.blueGrey,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  AutoSizeText(
                    'Customer Details',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  PopupMenuButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      color:
                          isDarkMode == true ? Color(0xFF121212) : Colors.white,
                      onSelected: handleClick,
                      itemBuilder: (BuildContext context) {
                        return {'Edit', 'Buang'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      })
                ],
              ),
              Center(
                child: Text(
                  'Database UID: ${widget.id}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isDarkMode == true ? Color(0xFF121212) : Colors.white,
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Center(
                          child: Hero(
                            tag: widget.id,
                            child: AvatarLetter(
                              size: 280,
                              letterType: LetterType.Circular,
                              text: widget.nama,
                              fontSize: 160,
                              numberLetters: 2,
                              textColor: Colors.white,
                              textColorHex: null,
                              backgroundColor: Colors.grey[400],
                              backgroundColorHex: null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(child: Text('Tekan lama untuk lihat maklumat')),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: isDarkMode == true
                                  ? Colors.white
                                  : Color(0xFF000000),
                            ),
                            onPressed: () {
                              _launchCaller();
                            },
                            tooltip: 'No telefon: ${widget.phone}',
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.message,
                              color: isDarkMode == true
                                  ? Colors.white
                                  : Color(0xFF000000),
                            ),
                            onPressed: () {
                              _launchSms();
                            },
                            tooltip: 'Sms: ${widget.phone}',
                          ),
                          IconButton(
                            hoverColor: Colors.blueGrey,
                            icon: Icon(
                              Icons.email,
                              color: isDarkMode == true
                                  ? Colors.white
                                  : Color(0xFF000000),
                            ),
                            onPressed: () {
                              _launchEmail();
                            },
                            tooltip: 'Email: ${widget.email}',
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: isDarkMode == true
                                  ? Colors.white
                                  : Color(0xFF000000),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobSheet(
                                    editCustomer: true,
                                    passName: widget.nama,
                                    passEmail: widget.email,
                                    passPhone: widget.phone,
                                    passUID: widget.id,
                                  ),
                                ),
                              );
                            },
                            tooltip:
                                'Tambah Jobsheet baru untuk ${widget.nama}',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          widget.nama,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          widget.phone,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          'Regular Customer',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          'Sejarah Pembaikan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('customer')
                            .doc(passID)
                            .collection('repair history')
                            .orderBy('timeStamp', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text('Loading jap'),
                            );
                          }
                          return Column(
                            children: snapshot.data.docs.map((document) {
                              return InkWell(
                                onTap: () {},
                                child: Card(
                                  elevation: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(document['Model'],
                                                style: TextStyle(fontSize: 20)),
                                            Text(document['MID'],
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          document['Kerosakkan'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '${document['Remarks']} (${document['Password']})',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${document['Harga']}',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            document['Status'] ==
                                                    'Belum Selesai'
                                                ? IconButton(
                                                    icon: Icon(Icons.refresh,
                                                        color: Colors.grey),
                                                    onPressed: () {},
                                                    tooltip: 'Belum Selesai')
                                                : IconButton(
                                                    icon: Icon(Icons.done,
                                                        color: Colors.grey),
                                                    onPressed: () {},
                                                    tooltip: 'Selesai'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Di uruskan oleh: ${document['Technician']} pada tarikh ${document['Tarikh']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services_form/screens/job_sheet.dart';
import 'package:services_form/screens/page_customer_profile.dart';
import 'package:services_form/screens/page_repair_history.dart';
import 'package:services_form/widget/buttom_edit_customer.dart';
import 'package:services_form/widget/confirmation_delete_customer.dart';

class NewCustomerDetails extends StatefulWidget {
  final String nama;
  final String databaseUID;
  final String nomborTelefon;
  final String email;

  NewCustomerDetails({
    this.nama,
    this.databaseUID,
    this.nomborTelefon,
    this.email,
  });

  @override
  _NewCustomerDetailsState createState() => _NewCustomerDetailsState();
}

class _NewCustomerDetailsState extends State<NewCustomerDetails> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            Colors.black // navigation bar color // status bar color
        ));
    super.dispose();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        Editdb(
          name: widget.nama,
          phone: widget.nomborTelefon,
          email: widget.email,
          docid: widget.databaseUID,
        ).showEditdb(context);
        break;
      case 'Buang':
        ShowAlert(docid: widget.databaseUID, nama: widget.nama)
            .showAlertDialog(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final _tabs = [
      profile(
        datUID: widget.databaseUID,
        noFon: widget.nomborTelefon,
        email: widget.email,
        addJobsheet: () {
          Future.delayed(const Duration(milliseconds: 190), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobSheet(
                  editCustomer: true,
                  passName: widget.nama,
                  passEmail: widget.email,
                  passPhone: widget.nomborTelefon,
                  passUID: widget.databaseUID,
                ),
              ),
            );
          });
        },
        nama: widget.nama,
      ),
      repairHistory(widget.databaseUID, widget.nama),
    ];
    return Hero(
      tag: widget.databaseUID,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.shifting,
          currentIndex: _index,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                label: 'Maklumat Pelanggan',
                backgroundColor: Colors.blueGrey),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                  color: Colors.white,
                ),
                label: 'Sejarah Baiki',
                backgroundColor: Colors.teal),
          ],
          onTap: (val) {
            setState(() {
              _index = val;
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                systemNavigationBarColor: _index == 0
                    ? Colors.blueGrey
                    : Colors.teal, // navigation bar color // status bar color
              ));
            });
          },
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: _index == 0 ? Colors.blueGrey : Colors.teal,
              actions: [
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
              expandedHeight: 250.0,
              pinned: true,
              brightness: Brightness.dark,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsetsDirectional.only(start: 0, bottom: 16),
                centerTitle: true,
                title: _index == 0 ? Text(widget.nama) : Text('SEJARAH BAIKI'),
              ),
            ),
            SliverList(
              delegate: _tabs[_index],
            )
          ],
        ),
      ),
    );
  }
}

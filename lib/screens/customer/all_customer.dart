import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services_form/brain/customer_search.dart';
import 'package:services_form/screens/jobsheet/job_sheet.dart';
import 'package:services_form/screens/customer/new_customer_details.dart';
import 'package:avatar_letter/avatar_letter.dart';

class CustomerDatabase extends StatefulWidget {
  @override
  _CustomerDatabaseState createState() => _CustomerDatabaseState();
}

class _CustomerDatabaseState extends State<CustomerDatabase> {
  bool searchState = false;
  final _searchController = TextEditingController();
  Future resultsLoaded;
  List _getResult = [];
  List _resultList = [];
  // ignore: unused_field
  Future _resultLoaded;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _resultLoaded = getCustomerSnapshot();
  }

  getCustomerSnapshot() async {
    await FirebaseFirestore.instance
        .collection('customer')
        .get()
        .then((snapshot) {
      setState(() {
        _getResult = snapshot.docs;
      });
      searchResultList();
    });

    return 'Completed';
  }

  searchResultList() {
    var showResult = [];

    if (_searchController.text != '') {
      //search param
      for (var customerSnapshot in _getResult) {
        var title = CustomerSuggestion.getCustomer(customerSnapshot)
            .title
            .toLowerCase();

        var noPhone = CustomerSuggestion.getCustomer(customerSnapshot)
            .phoneNumber
            .toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResult.add(customerSnapshot);
        } else if (noPhone.contains(_searchController.text.toLowerCase())) {
          showResult.add(customerSnapshot);
        }
      }
    } else {
      showResult = List.from(_getResult);
    }
    setState(() {
      _resultList = showResult;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: 'Tambah Jobsheet baru',
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobSheet(
                    editCustomer: false,
                  ),
                ),
              );
            },
          ),
          title: !searchState
              ? Text('All Customer')
              : TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  onChanged: (newInput) {
                    searchResultList();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusColor: Colors.white,
                    fillColor: Colors.white,
                    hoverColor: Colors.white,
                    hintText: 'Cari pelanggan...',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
          centerTitle: true,
          actions: [
            !searchState
                ? IconButton(
                    tooltip: 'Cari customer',
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        searchState = !searchState;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.close_rounded),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        _searchController.text = '';
                        searchResultList();
                        searchState = !searchState;
                      });
                    },
                  ),
            IconButton(
              icon: Icon(Icons.refresh),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (c) => CustomerDatabase(),
                  ),
                );
              },
            ),
          ],
        ),
        body: _resultList.length <= 0
            ? Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text('Loading Jap, sambil2 tu jom berselawat😄'),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _resultList.length,
                    itemBuilder: (BuildContext context, int i) {
                      var document = _resultList[i];
                      return ListTile(
                        leading: Hero(
                          tag: document['UID'],
                          child: AvatarLetter(
                            textColor: Colors.white,
                            numberLetters: 2,
                            fontSize: 15,
                            upperCase: true,
                            letterType: LetterType.Circular,
                            text: document['Nama'],
                            backgroundColor: Colors.blueGrey,
                            backgroundColorHex: null,
                            textColorHex: null,
                          ),
                        ),
                        title: Text(
                            '${document['Nama'].toString().toUpperCase()}'),
                        subtitle: Text('${document['No Phone']}'),
                        onTap: () {
                          SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                                  systemNavigationBarColor: Colors.blueGrey,
                                  systemNavigationBarIconBrightness:
                                      Brightness.light));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewCustomerDetails(
                                nama: document['Nama'].toUpperCase(),
                                databaseUID: document['UID'],
                                nomborTelefon: document['No Phone'],
                                email: document['Email'],
                              ),
                            ),
                          );
                        },
                      );
                    })));
  }
}

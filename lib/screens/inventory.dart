import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:services_form/widget/buttom_edit_sparepart.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

final dbRef = FirebaseDatabase.instance.reference().child("Spareparts");

List<Map<dynamic, dynamic>> lists = [];
// bool _isRefresh = false;

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 12,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, 'addsparepart');
            },
          ),
          appBar: AppBar(
            title: Text('Spareparts'),
            centerTitle: true,
            brightness: Brightness.dark,
            actions: [
              IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => this.widget));
                  })
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  text: 'Semua',
                ),
                Tab(
                  text: 'iPhone',
                ),
                Tab(
                  text: 'Xiaomi',
                ),
                Tab(
                  text: 'Samsung',
                ),
                Tab(
                  text: 'Huawei',
                ),
                Tab(
                  text: 'Oppo',
                ),
                Tab(
                  text: 'Vivo',
                ),
                Tab(
                  text: 'Lenovo',
                ),
                Tab(
                  text: 'HTC',
                ),
                Tab(
                  text: 'Asus',
                ),
                Tab(
                  text: 'Nokia',
                ),
                Tab(
                  text: 'Sony',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SparepartsList(
                isAll: true,
              ),
              SparepartsList(
                isAll: false,
                model: 'iPhone',
              ),
              SparepartsList(
                isAll: false,
                model: 'Xiaomi',
              ),
              SparepartsList(
                isAll: false,
                model: 'Samsung',
              ),
              SparepartsList(
                isAll: false,
                model: 'Huawei',
              ),
              SparepartsList(
                isAll: false,
                model: 'Oppo',
              ),
              SparepartsList(
                isAll: false,
                model: 'Vivo',
              ),
              SparepartsList(
                isAll: false,
                model: 'Lenovo',
              ),
              SparepartsList(
                isAll: false,
                model: 'HTC',
              ),
              SparepartsList(
                isAll: false,
                model: 'Asus',
              ),
              SparepartsList(
                isAll: false,
                model: 'Nokia',
              ),
              SparepartsList(
                isAll: false,
                model: 'Sony',
              ),
            ],
          )),
    );
  }
}

class SparepartsList extends StatefulWidget {
  final String model;
  final bool isAll;
  SparepartsList({this.model, this.isAll});

  @override
  _SparepartsListState createState() => _SparepartsListState();
}

class _SparepartsListState extends State<SparepartsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.isAll == false
            ? dbRef
                .orderByChild('Model')
                .startAt(widget.model.toUpperCase())
                .endAt(widget.model.toUpperCase() + "\uf8ff")
                .once()
            : dbRef.once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            lists.clear();

            Map<dynamic, dynamic> values = snapshot.data.value;
            if (values != null) {
              values.forEach((key, values) {
                lists.add(values);
              });
            } else if (values == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.browser_not_supported_sharp,
                    size: 70,
                    color: Colors.grey,
                  ),
                  Text(
                    'Tiada Spareparts',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            }

            return new ListView.builder(
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (BuildContext context, int index) {
                  String title =
                      '${lists[index]["Jenis Spareparts"]} ${lists[index]["Model"]}';

                  return Slidable(
                    key: Key(index.toString()),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      child: ListTile(
                        onLongPress: () {
                          print(values.keys.toList()[index]);
                        },
                        leading: CircleAvatar(
                          child: Text(
                            lists[index]["Supplier"],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.blueGrey,
                        ),
                        title: Text(
                          '$title (${lists[index]["Kualiti"]})',
                        ),
                        trailing: Text(
                          'x${lists[index]["Kuantiti"]}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        subtitle: Text("""${lists[index]["Maklumat Spareparts"]}
${lists[index]["Tarikh"]}"""),
                        isThreeLine: true,
                      ),
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.grey.shade100,
                        icon: Icons.edit,
                        onTap: () {
                          EditSparepart(
                            tarikh: lists[index]["Tarikh"],
                            userID: values.keys.toList()[index],
                            model: lists[index]["Model"],
                            supplier: lists[index]["Supplier"],
                            sparepart: lists[index]["Jenis Spareparts"],
                            quantity: lists[index]["Kuantiti"],
                            details: lists[index]["Maklumat Spareparts"],
                            manufactor: lists[index]["Kuantiti"],
                          ).showEditdb(context);
                        },
                      ),
                      IconSlideAction(
                        caption: 'Buang',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          _deleteConfirmation(BuildContext context) {
                            // set up the buttons
                            Widget cancelButton = TextButton(
                              child: Text("Batal"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                            Widget continueButton = TextButton(
                              child: Text(
                                'Buang',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  FirebaseDatabase.instance
                                      .reference()
                                      .child('Spareparts')
                                      .child(values.keys.toList()[index])
                                      .remove();
                                });

                                Navigator.pop(context);
                              },
                            );

                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              title: Text('Buang Sparepart'),
                              content: Text(
                                  'Adakah anda pasti untuk membuang item untuk $title?'),
                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }

                          _deleteConfirmation(context);
                        },
                      ),
                    ],
                  );
                });
          }
          return CircularProgressIndicator();
        });
  }
}

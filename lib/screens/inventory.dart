import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:services_form/widget/buttom_edit_sparepart.dart';
import 'package:show_hide_fab/show_hide_fab.dart';
import 'package:oktoast/oktoast.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

final dbRef = FirebaseDatabase.instance.reference().child("Spareparts");

List<Map<dynamic, dynamic>> lists = [];
// bool _isRefresh = false;
ScrollController _controller;
bool show = true;
int _total = 0;

class _InventoryState extends State<Inventory> {
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        show = false;
        showToast('Jumlah semua spareparts: $_total',
            position: ToastPosition.bottom, backgroundColor: Colors.blueGrey);
      });
    }

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        show = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 16,
      child: Scaffold(
          floatingActionButton: ShowHideFAB(
            animationDuration: Duration(milliseconds: 250),
            shouldShow: show,
            fab: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, 'addsparepart');
              },
            ),
          ),
          appBar: AppBar(
            title: Text('SpareParts'),
            centerTitle: true,
            brightness: Brightness.dark,
            actions: [
              IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      show = true;
                    });
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) => this.widget));
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
                  text: 'Redmi',
                ),
                Tab(
                  text: 'Poco',
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
                  text: 'Realme',
                ),
                Tab(
                  text: 'OnePlus',
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
                  text: 'Xperia',
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
                model: 'Redmi',
              ),
              SparepartsList(
                isAll: false,
                model: 'Poco',
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
                model: 'Realme',
              ),
              SparepartsList(
                isAll: false,
                model: 'OnePlus',
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
                    'Takde sparepart tuan',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            }

            return new ListView.builder(
                controller: _controller,
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (BuildContext context, int index) {
                  String title =
                      '${lists[index]["Jenis Spareparts"]} ${lists[index]["Model"]}';

                  int _sales = 0;
                  _total = lists.length;
                  formatHarga() {
                    int i = int.parse(lists[index]['Harga']);
                    if (i <= 20) {
                      i = i + 50;
                      return _sales = i;
                    } else if (i <= 100) {
                      i = i * 2;
                      return _sales = i;
                    } else if (i > 100 && i < 350) {
                      i = i * 2 - 20;
                      return _sales = i;
                    } else if (i > 350) {
                      i = i + 180;
                      return _sales = i;
                    }
                  }

                  formatHarga();
                  return Slidable(
                    key: Key(index.toString()),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      child: ListTile(
                        onTap: () {
                          formatHarga();
                        },
                        onLongPress: () {
                          formatHarga();
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
                          'RM${_sales.toString()}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        subtitle: Text("""${lists[index]["Maklumat Spareparts"]}
${lists[index]["Tarikh"]} | H.Supplier RM${lists[index]["Harga"]}"""),
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
                            quantity: lists[index]["Harga"],
                            details: lists[index]["Maklumat Spareparts"],
                            manufactor: lists[index]["Kualiti"],
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
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text('Loading Jap...'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

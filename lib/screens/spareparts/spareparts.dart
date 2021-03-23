import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:services_form/brain/spareparts_database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:services_form/widget/buttom_edit_sparepart.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;
BioSpareparts bio;
DatabaseReference databaseReference;

List<BioSpareparts> bioList;

class DatabaseSpareparts extends StatefulWidget {
  @override
  _DatabaseSparepartsState createState() => _DatabaseSparepartsState();
}

class _DatabaseSparepartsState extends State<DatabaseSpareparts> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bioList = [];
    bio = BioSpareparts(
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    );
    Query databaseReference = database
        .reference()
        .child('Spareparts')
        .orderByChild('Model')
        .equalTo('iPhone 6');
    databaseReference.onChildChanged.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onEntryAdded(Event event) async {
    setState(() {
      bioList.add(BioSpareparts.fromSnapshot((event.snapshot)));
    });
  }

  void _onEntryChanged(Event event) async {
    var oldEntry = bioList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      bioList[bioList.indexOf(oldEntry)] =
          BioSpareparts.fromSnapshot((event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: Duration(milliseconds: 300),
      data: Theme.of(context),
      child: DefaultTabController(
        length: 11,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            title: Text('Spareparts'),
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
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
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, 'addsparepart');
            },
          ),
          body: new FirebaseAnimatedList(
              shrinkWrap: true,
              query: databaseReference,
              itemBuilder: (
                BuildContext context,
                DataSnapshot snapshot,
                Animation<double> animation,
                int sampah,
              ) {
                if (snapshot.value != null) {
                  String title =
                      '${snapshot.value['Jenis Spareparts']} ${snapshot.value['Model']}';

                  return Column(
                    children: [
                      Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                          child: ListTile(
                            onLongPress: () {},
                            leading: CircleAvatar(
                              child: Text(
                                snapshot.value['Supplier'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.blueGrey,
                            ),
                            title: Text(
                              '$title (${snapshot.value['Kualiti']})',
                            ),
                            trailing: Text(
                              'x${snapshot.value['Kuantiti']}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            subtitle:
                                Text("""${snapshot.value['Maklumat Spareparts']}
${snapshot.value['Tarikh']}"""),
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
                                tarikh: snapshot.value['Tarikh'],
                                userID: snapshot.key,
                                model: snapshot.value['Model'],
                                supplier: snapshot.value['Supplier'],
                                sparepart: snapshot.value['Jenis Spareparts'],
                                quantity: snapshot.value['Kuantiti'],
                                details: snapshot.value['Maklumat Spareparts'],
                                manufactor: snapshot.value['Kualiti'],
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
                                    databaseReference
                                        .child(snapshot.key)
                                        .remove();
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
                      )
                    ],
                  );
                }
                return Center(child: Text('Loading jap..'));
              }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DatabaseSpareparts extends StatefulWidget {
  @override
  _DatabaseSparepartsState createState() => _DatabaseSparepartsState();
}

class _DatabaseSparepartsState extends State<DatabaseSpareparts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spareparts'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, 'addsparepart');
            },
          ),
        ],
      ),
    );
  }
}

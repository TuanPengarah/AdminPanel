import 'package:flutter/material.dart';

class PendingJob extends StatefulWidget {
  @override
  _PendingJobState createState() => _PendingJobState();
}

class _PendingJobState extends State<PendingJob> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Sejarah Pembaikan',
              backgroundColor: Colors.red),
        ],
        onTap: (val) {
          setState(() {
            _index = val;
            print(_index);
          });
        },
      ),
      appBar: AppBar(
        title: Text(
          'Pending Job',
        ),
        brightness: Brightness.dark,
        centerTitle: true,
      ),
    );
  }
}

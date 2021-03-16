import 'package:flutter/material.dart';
import 'package:services_form/screens/print.dart';

class Reprint extends StatefulWidget {
  final nama;
  final noPhone;
  final model;
  final kerosakkan;
  final price;
  final remarks;
  final mid;

  Reprint(
      {this.nama,
      this.noPhone,
      this.model,
      this.kerosakkan,
      this.price,
      this.remarks,
      this.mid});

  @override
  _ReprintState createState() => _ReprintState();
}

class _ReprintState extends State<Reprint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        brightness: Brightness.dark,
        title: Text('Maklumat Resit'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => Print(
                      dataname: widget.nama,
                      dataphone: widget.noPhone,
                      datamodel: widget.model,
                      datadmg: widget.kerosakkan,
                      dataangg: widget.price,
                      dataremarks: widget.remarks,
                      datauid: widget.mid),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image(
                image: AssetImage('assets/thermal.png'),
              ),
            ),
            Center(
              child: Text(
                'AF-FIX',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'Smartphone Repair Specialist',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Text(
                'Jalan Sentosa, Sungai Ramal Baru',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Text(
                '43000 Kajang',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Text(
                'Tel: 011-11426421',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Text(
                'www.af-fix.cf',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Text(
                'Resit Drop Off Peranti',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'MyRepair ID: ${widget.mid}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15),
              child: Text(
                'Nama: ${widget.nama}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15),
              child: Text(
                'Nombor tel: ${widget.noPhone}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15),
              child: Text(
                'Model: ${widget.model}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15),
              child: Text(
                'Kerosakkan: ${widget.kerosakkan}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15),
              child: Text(
                'Anggaran Harga: RM${widget.price.toString()}',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 15),
              child: Text(
                'Catatan: ${widget.remarks}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

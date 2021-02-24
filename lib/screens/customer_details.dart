import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_letter/avatar_letter.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
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
                  IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('customer')
                          .doc(widget.id)
                          .delete();
                      Navigator.pop(context);
                    },
                  ),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Center(
                          child: Hero(
                            tag: widget.nama,
                            child: AvatarLetter(
                                size: 280,
                                letterType: LetterType.Circular,
                                text: widget.nama,
                                fontSize: 160,
                                numberLetters: 2,
                                textColor: Colors.white,
                                textColorHex: null,
                                backgroundColor: null,
                                backgroundColorHex: 'FFD2D2D2'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
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
                          'Regular Customer',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
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

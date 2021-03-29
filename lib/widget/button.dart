import 'package:flutter/material.dart';
import 'buttom_customer.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'buttom_management.dart';

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Future.delayed(const Duration(milliseconds: 190), () {
                  buttomCustomerSheet(context);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: AutoSizeText(
                  'Pelanggan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Material(
          color: Colors.transparent,
          child: Ink(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Future.delayed(
                  const Duration(milliseconds: 190),
                  () {
                    buttomManagement(context);
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'Pengurusan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

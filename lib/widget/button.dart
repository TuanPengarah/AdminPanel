import 'package:flutter/material.dart';
import 'buttom_customer.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () {
            buttomCustomerSheet(context);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
        SizedBox(
          height: 25,
        ),
        InkWell(
          onTap: () {
            Future.delayed(
              const Duration(milliseconds: 190),
              () {
                Navigator.pushNamed(context, 'spareparts');
              },
            );
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                'Inventory',
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
      ],
    );
  }
}

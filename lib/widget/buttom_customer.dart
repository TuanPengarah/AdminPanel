import 'package:flutter/material.dart';

buttomCustomerSheet(context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext c) {
        return Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Customer Database',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'jobsheet');
                  },
                  child: Text(
                    'Reka Jobsheet baru',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'allcustomer');
                  },
                  child: Text(
                    'Semua Customer',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 60,
                )
              ],
            ),
          ],
        );
      });
}

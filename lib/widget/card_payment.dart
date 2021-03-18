import 'package:flutter/material.dart';
import 'package:services_form/brain/constant.dart';

class CardPayments extends StatelessWidget {
  final model;
  final nama;
  final noPhone;
  final mid;
  final price;
  final status;
  final rosak;
  final uid;
  final Function onPress;

  CardPayments({
    @required this.price,
    @required this.mid,
    @required this.model,
    @required this.noPhone,
    @required this.nama,
    @required this.uid,
    @required this.rosak,
    @required this.status,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: mid,
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        model,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 21,
                        ),
                      ),
                    ),
                    Text(
                      mid,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    rosak,
                    style: subTitle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    '$nama ($noPhone)',
                    style: subTitle,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        'RM$price',
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        '$status',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

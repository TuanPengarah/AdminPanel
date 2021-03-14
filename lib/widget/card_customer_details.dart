import 'package:flutter/material.dart';

class CardsCustomerDetails extends StatelessWidget {
  final icon;
  final String title;
  final String subtitle;
  final Function onPress;
  final Function longPress;

  CardsCustomerDetails(
      {this.icon, this.title, this.subtitle, this.onPress, this.longPress});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPress,
        onLongPress: longPress,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

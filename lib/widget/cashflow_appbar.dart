import 'package:flutter/material.dart';
import 'package:services_form/brain/constant.dart';

class AppBarCashFlow extends StatelessWidget {
  const AppBarCashFlow({
    Key key,
    @required this.isDarkMode,
  }) : super(key: key);

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'C-Flow',
            style: TextStyle(
              color: isDarkMode == false ? kCompColor : Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Kajang/Bangi',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

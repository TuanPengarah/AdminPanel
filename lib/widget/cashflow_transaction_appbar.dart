import 'package:flutter/material.dart';
import 'package:services_form/brain/constant.dart';

class TransactionHistoryAppBar extends StatelessWidget {
  const TransactionHistoryAppBar({
    Key key,
    @required this.isDarkMode,
  }) : super(key: key);

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Transaksi',
            style: TextStyle(
              color: isDarkMode == false ? kCompColor : Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          InkWell(
            onTap: () {},
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'alltransaction');
              },
              child: Text(
                'Lihat Semua',
                style: TextStyle(
                  color: isDarkMode == false ? kCompColor : Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_form/brain/balance_provider.dart';
import 'package:services_form/brain/check_lock.dart';

class BankCard extends StatelessWidget {
  const BankCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isLock = Provider.of<CheckLock>(context).setLock;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.brown,
              Colors.teal,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ASSAFF ENTERPRISE',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'MAYBANK',
                    style: TextStyle(
                        color: Colors.white60, fontSize: 10, letterSpacing: 3),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'JUMLAH DUIT SYARIKAT',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 15,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  _isLock == true
                      ? 'STATUS DIKUNCI'
                      : 'RM${Provider.of<BalanceProvider>(context).jumlah.toString()}',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  'NOMBOR AKAUN',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    letterSpacing: 3,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  '5620 2165 1202',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 17,
                    letterSpacing: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

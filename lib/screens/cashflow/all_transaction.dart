import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:services_form/brain/check_lock.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/brain/sqlite_services.dart';
import 'package:services_form/widget/bottom_unlock.dart';

class AllTransaction extends StatefulWidget {
  @override
  _AllTransactionState createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {
  List<CashFlow> cflist;
  int panjang = 0;
  bool checkDark;

  @override
  void initState() {
    panjang = cflist != null ? cflist.length : 0;

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        panjang = cflist != null ? cflist.length : 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness:
            checkDark == false ? Brightness.dark : Brightness.light));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLock = Provider.of<CheckLock>(context).setLock;
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    checkDark = isDarkMode;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Semua Transaksi'),
            Text(
              panjang == 0
                  ? 'Jumlah semua transaksi: Tunggu jap...'
                  : 'Jumlah semua transaksi: $panjang',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLock == true
                    ? unlockCode(context)
                    : Provider.of<CheckLock>(context, listen: false).setLock =
                        true;
              });
            },
            icon: Icon(
              isLock == true ? Icons.lock_outline : Icons.lock_open_outlined,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: DBProvider.db.queryAll('${DBProvider.columnTarikh} DESC'),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            cflist = snapshot.data;
            return ListView.builder(
                itemCount: cflist != null ? cflist.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  CashFlow cf = cflist[index];

                  return Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: Ink(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDarkMode == false
                              ? Color(0xffeceff1)
                              : Colors.grey[900],
                        ),
                        child: InkWell(
                          onLongPress: () {
                            DBProvider.db.delete(cf.id);
                            setState(() {
                              cflist.removeAt(index);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${cf.spareparts}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode == true
                                              ? Colors.white
                                              : kCompColor),
                                    ),
                                    Text(
                                      cf.dahBayar == 0
                                          ? 'Duit Keluar'
                                          : 'Duit '
                                              'Masuk',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      cf.tarikh,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                isLock == false
                                    ? Column(
                                        children: [
                                          Icon(
                                            cf.dahBayar == 0
                                                ? Icons.arrow_drop_down
                                                : Icons.arrow_drop_up,
                                            color: cf.dahBayar == 0
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                          Text(
                                            'RM${cf.price}',
                                            style: TextStyle(
                                                color: isDarkMode == true
                                                    ? Colors.white
                                                    : kCompColor),
                                          ),
                                        ],
                                      )
                                    : Icon(Icons.lock_outline),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Loading jap'),
              ],
            ),
          );
        },
      ),
    );
  }
}

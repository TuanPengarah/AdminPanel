import 'package:flutter/material.dart';
import 'package:services_form/brain/constant.dart';
import 'package:provider/provider.dart';
import 'package:services_form/brain/check_lock.dart';
import 'package:services_form/brain/sqlite_services.dart';

class CashFlowTransactionGlance extends StatelessWidget {
  const CashFlowTransactionGlance({
    Key key,
    @required this.isDarkMode,
  }) : super(key: key);

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    List<CashFlow> cflist;
    bool isLock = Provider.of<CheckLock>(context).setLock;
    return Padding(
      padding: EdgeInsets.all(15),
      child: FutureBuilder(
        future: DBProvider.db.queryAll('${DBProvider.columnTarikh} DESC'),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            cflist = snapshot.data;
            return ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: cflist.length <= 3 ? cflist.length : 3,
                itemBuilder: (BuildContext context, int index) {
                  CashFlow cf = cflist[index];

                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isDarkMode == false
                            ? Color(0xffeceff1)
                            : Colors.grey[900],
                      ),
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

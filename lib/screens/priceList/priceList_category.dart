import 'package:flutter/material.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/brain/sqlite_services.dart';

class PriceListCategory extends StatefulWidget {
  final String model;

  PriceListCategory({this.model});
  @override
  _PriceListCategoryState createState() => _PriceListCategoryState();
}

class _PriceListCategoryState extends State<PriceListCategory> {
  List<PriceList> _pList;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return FutureBuilder(
      future: DBProvider.db.queryAllPL(
        'id DESC',
        widget.model.toUpperCase(),
      ),
      builder: (BuildContext context, snapshot) {
        _pList = snapshot.data;

        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _pList.length,
            itemBuilder: (BuildContext context, int index) {
              PriceList pl = _pList[index];

              return Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 4.0, left: 10, right: 10),
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
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pl.model,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode == true
                                    ? Colors.white
                                    : kCompColor,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              pl.jenis,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
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
    );
  }
}

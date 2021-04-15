import 'package:flutter/material.dart';
import 'package:services_form/brain/constant.dart';
import 'package:services_form/brain/sqlite_services.dart';
import 'package:services_form/screens/priceList/price_list_dialog.dart';

class PriceListCategory extends StatefulWidget {
  final String model;

  PriceListCategory({this.model});
  @override
  _PriceListCategoryState createState() => _PriceListCategoryState();
}

class _PriceListCategoryState extends State<PriceListCategory> {
  List<PriceList> _pList;
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    super.initState();
  }

  Future<void> refreshAll() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await refreshAll();
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: DBProvider.db.queryAllPL(
            'id DESC',
            widget.model.toUpperCase(),
          ),
          builder: (BuildContext context, snapshot) {
            _pList = snapshot.data;

            if (snapshot.hasData) {
              return _pList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.browser_not_supported_sharp,
                            size: 70,
                            color: Colors.grey,
                          ),
                          Text(
                            widget.model == ''
                                ? 'Senarai harga '
                                    'untuk\nsemua model takde tuan'
                                : 'Senarai harga untuk model\n${widget.model} takde tuan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
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
                                onTap: () {
                                  DialogPriceList(
                                    id: pl.id,
                                    model: pl.model,
                                    namaSupplier: pl.supplier,
                                    jenisSparepart: pl.jenis,
                                    hargaSupplier: pl.supplierPrice,
                                    hargaJual: pl.price,
                                    tarikh: pl.tarikh,
                                  ).showAlertDialog(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            pl.jenis,
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'RM${pl.price}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
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
                  SizedBox(
                    height: 15,
                  ),
                  Text('Loading jap'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

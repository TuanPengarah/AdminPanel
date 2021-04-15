import 'package:flutter/material.dart';
import 'package:services_form/screens/priceList/priceList_category.dart';

import 'add_price_list.dart';

class PriceListHome extends StatefulWidget {
  @override
  _PriceListHomeState createState() => _PriceListHomeState();
}

class _PriceListHomeState extends State<PriceListHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 16,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Senarai Harga'),
          centerTitle: true,
          brightness: Brightness.dark,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => AddPriceList(),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            physics: BouncingScrollPhysics(),
            isScrollable: true,
            tabs: [
              Tab(
                text: 'Semua',
              ),
              Tab(
                text: 'iPhone',
              ),
              Tab(
                text: 'Xiaomi',
              ),
              Tab(
                text: 'Redmi',
              ),
              Tab(
                text: 'Poco',
              ),
              Tab(
                text: 'Samsung',
              ),
              Tab(
                text: 'Huawei',
              ),
              Tab(
                text: 'Oppo',
              ),
              Tab(
                text: 'Realme',
              ),
              Tab(
                text: 'OnePlus',
              ),
              Tab(
                text: 'Vivo',
              ),
              Tab(
                text: 'Lenovo',
              ),
              Tab(
                text: 'HTC',
              ),
              Tab(
                text: 'Asus',
              ),
              Tab(
                text: 'Nokia',
              ),
              Tab(
                text: 'Xperia',
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            PriceListCategory(
              model: '',
            ),
            PriceListCategory(
              model: 'iPhone',
            ),
            PriceListCategory(
              model: 'Xiaomi',
            ),
            PriceListCategory(
              model: 'Redmi',
            ),
            PriceListCategory(
              model: 'Poco',
            ),
            PriceListCategory(
              model: 'Samsung',
            ),
            PriceListCategory(
              model: 'Huawei',
            ),
            PriceListCategory(
              model: 'Oppo',
            ),
            PriceListCategory(
              model: 'Realme',
            ),
            PriceListCategory(
              model: 'OnePlus',
            ),
            PriceListCategory(
              model: 'Vivo',
            ),
            PriceListCategory(
              model: 'Lenovo',
            ),
            PriceListCategory(
              model: 'HTC',
            ),
            PriceListCategory(
              model: 'Asus',
            ),
            PriceListCategory(
              model: 'Nokia',
            ),
            PriceListCategory(
              model: 'Xperia',
            ),
          ],
        ),
      ),
    );
  }
}

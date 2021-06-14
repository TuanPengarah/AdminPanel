import 'package:avatar_letter/avatar_letter.dart';
import 'package:flutter/material.dart';

class EwarrantyProfile extends StatefulWidget {
  const EwarrantyProfile({Key key}) : super(key: key);

  @override
  _EwarrantyProfileState createState() => _EwarrantyProfileState();
}

class _EwarrantyProfileState extends State<EwarrantyProfile> {
  int _selectablePage = 0;

  PageController _pageController;

  void _clickPage(int pageNum) {
    setState(() {
      _selectablePage = pageNum;
      _pageController.animateToPage(pageNum,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: userProfile(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabButton(
                  tabName: 'Warranti',
                  pageNumber: 0,
                  selectablePage: _selectablePage,
                  onPressed: () {
                    _clickPage(0);
                  },
                ),
                TabButton(
                  tabName: 'Sejarah baiki',
                  pageNumber: 1,
                  selectablePage: _selectablePage,
                  onPressed: () {
                    _clickPage(1);
                  },
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (int change) {
                    setState(() {
                      _selectablePage = change;
                    });
                  },
                  controller: _pageController,
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              'Waranti yang masih aktif',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            warrantyCard(context, 'POCO X3 NFC', 50),
                            warrantyCard(context, 'IPHONE 5SE', 120),
                            warrantyCard(context, 'XIAOMI NOTE 9S', 80),
                            warrantyCard(context, 'SAMSUNG NOTE 10+', 80),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: SelectableText('Loading...'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget warrantyCard(BuildContext context, String phoneModel, int harga) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          color: Colors.brown[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText(
                    'MySID: 23493',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AvatarLetter(
                        text: phoneModel,
                        textColor: Colors.brown,
                        textColorHex: null,
                        backgroundColor: Colors.white,
                        backgroundColorHex: null,
                        letterType: LetterType.Circular,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            phoneModel ?? 'Model',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          SelectableText(
                            'SOFTWARE',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText(
                    'RM${harga.toString()}',
                    style: TextStyle(color: Colors.white, fontSize: 23),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SelectableText(
                'Waranti sah pada 10/6/2021 sehingga 10/7/2021',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row userProfile() {
    return Row(
      children: [
        AvatarLetter(
          text: 'AKID FIKRI,',
          textColor: Colors.white,
          textColorHex: null,
          backgroundColor: Colors.brown,
          backgroundColorHex: null,
          letterType: LetterType.Circular,
        ),
        SizedBox(width: 18),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              'Assalamualaikum,',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(height: 5),
            SelectableText(
              'Akid Fikri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[900],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final String tabName;
  final int pageNumber;
  final int selectablePage;
  final Function onPressed;
  TabButton(
      {this.tabName, this.pageNumber, this.selectablePage, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
        margin: EdgeInsets.all(pageNumber == selectablePage ? 0 : 10),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: pageNumber == selectablePage
              ? Colors.brown[400]
              : Colors.transparent,
        ),
        child: Text(
          tabName ?? 'Tab Button',
          style: TextStyle(
            color: pageNumber == selectablePage ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

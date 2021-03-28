import 'package:flutter/material.dart';

class MoreAction extends StatelessWidget {
  const MoreAction({
    Key key,
    @required this.isDarkMode,
    @required this.icon,
    @required this.title,
    this.click,
    this.isLock,
  }) : super(key: key);

  final bool isDarkMode;
  final IconData icon;
  final String title;
  final Function click;
  final bool isLock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: Ink(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color:
                    isDarkMode == false ? Color(0xffeceff1) : Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: click,
                child: Icon(icon),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}

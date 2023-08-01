import 'package:flutter/material.dart';
import 'package:tcea_app/config/config.dart';

import 'customText.dart';

class CustomTabBar extends StatefulWidget {
  final Function onClick;
  final String lable;
  final String img;
  final bool isActive;
  const CustomTabBar(
      {Key? key,
      required this.lable,
      required this.img,
      required this.isActive,
      required this.onClick})
      : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => {widget.onClick()},
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: widget.isActive ? Config.theme : Config.bg))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              child: Center(
                child: Image.asset(
                  "${widget.img}",
                  scale: 1,
                ),
              ),
            ),
            CustomText(
              content: "${widget.lable}",
              size: width / 35,
              color: widget.isActive ? Config.theme : Config.lightText,
            )
          ],
        ),
      ),
    );
  }
}

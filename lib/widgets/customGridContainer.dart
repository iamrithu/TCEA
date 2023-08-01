import 'package:flutter/material.dart';

import '../config/config.dart';
import 'customText.dart';

class CustomGridContainer extends StatefulWidget {
  final String? content;
  final String? value;
  final String? img;

  const CustomGridContainer({Key? key, this.content, this.value, this.img})
      : super(key: key);

  @override
  _CustomGridContainerState createState() => _CustomGridContainerState();
}

class _CustomGridContainerState extends State<CustomGridContainer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      color: Config.theme,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   color: Config.white,
            //   width: 30,
            //   height: 30,
            //   child: Center(
            //     child: Image.asset(
            //       "${widget.img}",
            //       scale: 1,
            //     ),
            //   ),
            // ),
            CustomText(
              content: "${widget.content}",
              size: width / 25,
              color: Config.white,
              fWeight: FontWeight.bold,
            ),
            CustomText(
              content: "${widget.value}",
              size: width / 20,
              color: Config.white,
              fWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}

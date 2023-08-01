import 'package:flutter/material.dart';

import '../config/config.dart';
import 'customText.dart';

class CustomSupplierDetailsCard extends StatefulWidget {
  final String lable;
  final String value;
  final bool? alignLeft;
  const CustomSupplierDetailsCard(
      {Key? key, required this.lable, required this.value, this.alignLeft})
      : super(key: key);

  @override
  _CustomSupplierDetailsCardState createState() =>
      _CustomSupplierDetailsCardState();
}

class _CustomSupplierDetailsCardState extends State<CustomSupplierDetailsCard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: height * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            content: "${widget.lable}:",
            size: width / 40,
            color: const Color.fromARGB(255, 90, 88, 88),
            fWeight: FontWeight.bold,
          ),
          CustomText(
            alightLeft: widget.alignLeft != null ? true : null,
            content: "${widget.value}",
            size: width / 30,
            color: Config.black,
            fWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}

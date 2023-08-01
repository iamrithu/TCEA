import 'package:flutter/material.dart';

import '../config/config.dart';
import 'customText.dart';

class CustomCategoryCard extends StatefulWidget {
  final String? img;
  final String? lable;
  final bool? isSmall;
  const CustomCategoryCard({Key? key, this.img, this.lable, this.isSmall})
      : super(key: key);

  @override
  _CustomCategoryCardState createState() => _CustomCategoryCardState();
}

class _CustomCategoryCardState extends State<CustomCategoryCard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: widget.img == null
                      ? Image.asset(
                          width: widget.isSmall == null
                              ? width
                              : widget.isSmall == true
                                  ? width * 0.7
                                  : width,
                          height: widget.isSmall == null
                              ? height * 0.13
                              : widget.isSmall == true
                                  ? height * 0.08
                                  : height * 0.13,
                          "Assets/images/no-image.png",
                          scale: 1,
                          fit: BoxFit.cover,
                        )
                      : widget.img!.startsWith("Asset")
                          ? Image.asset(
                              width: widget.isSmall == null
                                  ? width
                                  : widget.isSmall == true
                                      ? width * 0.7
                                      : width,
                              height: widget.isSmall == null
                                  ? height * 0.13
                                  : widget.isSmall == true
                                      ? height * 0.08
                                      : height * 0.13,
                              "${widget.img}",
                              scale: 1,
                              fit: BoxFit.cover,
                            )
                          : widget.img == ""
                              ? Image.asset(
                                  width: widget.isSmall == null
                                      ? width
                                      : widget.isSmall == true
                                          ? width * 0.7
                                          : width,
                                  height: widget.isSmall == null
                                      ? height * 0.13
                                      : widget.isSmall == true
                                          ? height * 0.08
                                          : height * 0.13,
                                  "Assets/images/no-image.png",
                                  scale: 1,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  width: widget.isSmall == null
                                      ? width
                                      : widget.isSmall == true
                                          ? width * 0.7
                                          : width,
                                  height: widget.isSmall == null
                                      ? height * 0.13
                                      : widget.isSmall == true
                                          ? height * 0.08
                                          : height * 0.13,
                                  widget.img!,
                                  scale: 1,
                                  fit: BoxFit.cover,
                                ),
                ),
              ),
            ),
            CustomText(
              content: "${widget.lable}",
              size: width / 25,
              color: Config.black,
              fWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}

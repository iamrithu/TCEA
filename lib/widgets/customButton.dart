import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomButton extends StatefulWidget {
  final Function onClick;
  final Widget widget;
  final Color? borderColor;
  final Color? bgColor;
  final double? radius;
  final bool isloading;

  const CustomButton(
      {Key? key,
      required this.onClick,
      required this.widget,
      this.borderColor,
      this.bgColor,
      this.radius,
      required this.isloading})
      : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: widget.bgColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 5))),
        onPressed: () => {widget.onClick()},
        child: widget.isloading
            ? Center(
                child: SpinKitRipple(
                  color: Colors.white,
                  size: 30.0,
                ),
              )
            : Center(
                child: widget.widget,
              ));
  }
}

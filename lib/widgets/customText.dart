import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcea_app/config/config.dart';

class CustomText extends StatefulWidget {
  final String? content;
  final Color? color;
  final double? size;
  final bool? alightLeft;
  final FontWeight? fWeight;
  const CustomText(
      {Key? key,
      this.content,
      this.color,
      this.size,
      this.fWeight,
      this.alightLeft})
      : super(key: key);

  @override
  _CustomTextState createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Text(
      "${widget.content}",
      textAlign: widget.alightLeft != null ? TextAlign.left : TextAlign.center,
      style: GoogleFonts.mulish(
        textStyle: TextStyle(
          color: widget.color ?? Config.black,
          fontSize: widget.size ?? width / 26,
          fontWeight: widget.fWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}

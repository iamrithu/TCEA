// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcea_app/widgets/customText.dart';

import '../../../config/config.dart';

class CustomTextForm extends StatefulWidget {
  final TextEditingController? controller;
  final String? lable;
  final bool hide;
  final bool? isTextForm;
  final bool isReadOnly;

  final IconData? icon;
  const CustomTextForm({
    super.key,
    required this.width,
    required this.controller,
    required this.lable,
    required this.hide,
    this.icon,
    this.isTextForm,
    required this.isReadOnly,
  });

  final double width;

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            readOnly: widget.isReadOnly,
            onTapOutside: (value) {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            controller: widget.controller,
            keyboardType: widget.lable == "Password"
                ? TextInputType.visiblePassword
                : widget.lable == "Phone Number of Witness"
                    ? TextInputType.phone
                    : TextInputType.text,
            obscureText: widget.lable == "Password" ? !visible : widget.hide,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: widget.width / 32,
                color: Config.lightText),
            decoration: InputDecoration(
              label: CustomText(
                content: widget.lable,
                color: Config.theme,
              ),
              suffixIcon: widget.icon != null
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      child: Icon(
                        widget.icon,
                        color: Config.theme,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: widget.isReadOnly
                  ? Color.fromARGB(153, 242, 240, 240)
                  : Config.white,
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Config.theme),
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: widget.isReadOnly ? Config.lightText : Config.theme),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            maxLines: widget.isTextForm == null ? 1 : 3)
      ],
    );
  }
}

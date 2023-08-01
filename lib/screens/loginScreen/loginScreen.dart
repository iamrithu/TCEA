import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcea_app/config/config.dart';
import 'package:tcea_app/provider/provider.dart';
import 'package:tcea_app/screens/home/homeScreen.dart';

import '../../api/api.dart';
import '../../widgets/customButton.dart';
import '../../widgets/customText.dart';
import '../../widgets/customeInput.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isOtpEnable = false;
  bool isLoading = false;
  String otpCode = "";
  String phoNo = "";
  bool isChecked = false;
  bool isEmaillogin = true;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Config.theme;
    }
    return Config.theme;
  }

  checkAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('action');
    if (action != null && action != "") {
      Api().getUser(action).then((value) {
        ref.read(userDetails.notifier).update((state) => value.data);
        ref.read(userRole.notifier).update((state) => value.data["role"]);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return Future.delayed(
            Duration(
              seconds: 1,
            ), () {
          return false;
        });
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: width,
            height: height,
            margin: EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width,
                  height: height * 0.2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          content: "Welcome",
                          size: width > 600 ? 40 : 30,
                          fWeight: FontWeight.bold,
                          color: Config.black,
                        ),
                        Container(
                          width: width * 0.8,
                          child: Image.asset(
                            "Assets/images/Logo.png",
                            scale: 1,
                          ),
                        )
                      ]),
                ),
                Container(
                  width: width,
                  height: height * 0.35,
                  child: Column(
                    children: [
                      if (isEmaillogin)
                        Container(
                          width: width * 0.9,
                          child: CustomTextForm(
                            isReadOnly: false,
                            hide: false,
                            width: width,
                            controller: _emailController,
                            lable: "Email",
                          ),
                        ),
                      if (!isEmaillogin)
                        Container(
                          width: width * 0.9,
                          height: height * 0.08,
                          child: IntlPhoneField(
                            decoration: InputDecoration(
                              label: CustomText(
                                content: "Phone Number",
                                color: Config.theme,
                              ),
                              filled: true,
                              fillColor: Config.white,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Config.theme),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Config.theme),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              setState(() {
                                phoNo = phone.number;
                              });
                            },
                          ),
                        ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        width: width,
                        height: isOtpEnable ? height * 0.1 : 0,
                        padding: EdgeInsets.only(top: 3, bottom: 3, left: 6),
                        child: Visibility(
                          visible: isOtpEnable,
                          child: Center(
                            child: OtpTextField(
                              numberOfFields: 5,
                              fieldWidth: width * 0.162,
                              showFieldAsBox: true,
                              onSubmit: (String verificationCode) {
                                setState(() {
                                  otpCode = verificationCode;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isOtpEnable,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isOtpEnable = !isOtpEnable;
                            });
                          },
                          child: CustomText(
                            content: "Cancel",
                            color: Config.theme,
                            fWeight: FontWeight.bold,
                            size: width > 600 ? width / 40 : width / 30,
                          ),
                        ),
                      ),
                      if (isEmaillogin)
                        SizedBox(
                          height: 20,
                        ),
                      Container(
                        width: width * 0.9,
                        margin: EdgeInsets.only(top: 4),
                        height: height * 0.06,
                        child: CustomButton(
                          isloading: isLoading,
                          bgColor: Config.theme,
                          onClick: !isEmaillogin
                              ? () {
                                  print(phoNo);
                                  if (phoNo.length > 9) {
                                  } else {
                                    customAlert(
                                      context: context,
                                      height: height,
                                      width: width,
                                      content: "Invalid Mobile Number",
                                      success: false,
                                    );
                                  }
                                }
                              : isOtpEnable
                                  ? () async {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      setState(() {
                                        isLoading = true;
                                      });
                                      Api()
                                          .otpVerification(
                                              _emailController.text.trim(),
                                              otpCode)
                                          .then((value) async {
                                        if (value.statusCode == 200) {
                                          customAlert(
                                            context: context,
                                            height: height,
                                            width: width,
                                            content:
                                                "Hello ${value.data["name"]}",
                                            success: true,
                                          );
                                          if (isChecked) {
                                            await prefs.setString('action',
                                                "${value.data["id"]}");
                                          } else {
                                            await prefs.setString('action', "");
                                          }

                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(),
                                            ),
                                          );
                                          ref
                                              .watch(userDetails.notifier)
                                              .update((state) => value.data);
                                          ref.watch(userRole.notifier).update(
                                              (state) => value.data["role"]);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(),
                                            ),
                                          );
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          customAlert(
                                            context: context,
                                            height: height,
                                            width: width,
                                            content: "${value.data["message"]}",
                                            success: false,
                                          );
                                        }
                                      });
                                    }
                                  : () {
                                      if (_emailController.text.trim() == "" ||
                                          !_emailController.text
                                              .contains("@")) {
                                        customAlert(
                                          context: context,
                                          height: height,
                                          width: width,
                                          content: "Enter Valid Email",
                                          success: false,
                                        );
                                      } else {
                                        setState(() {
                                          isLoading = !isLoading;
                                        });
                                        Api()
                                            .otpGenerator(
                                                _emailController.text.trim())
                                            .then((value) {
                                          if (value.statusCode == 200) {
                                            customAlert(
                                              context: context,
                                              height: height,
                                              width: width,
                                              content:
                                                  "Otp sent to  @${_emailController.text.trim()}",
                                              success: true,
                                            );
                                            setState(() {
                                              isLoading = false;
                                              isOtpEnable = !isOtpEnable;
                                            });
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            customAlert(
                                              context: context,
                                              height: height,
                                              width: width,
                                              content:
                                                  "${value.data["message"]}",
                                              success: false,
                                            );
                                          }
                                        });
                                      }
                                    },
                          widget: CustomText(
                            content: isOtpEnable ? "Verify" : "Login",
                            color: Config.white,
                            fWeight: FontWeight.bold,
                            size: width > 600 ? 38 : 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            CustomText(
                              content: "Remember Me",
                              color: Config.lightText,
                              fWeight: FontWeight.normal,
                              size: width / 35,
                            ),
                          ],
                        ),
                      )
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: TextButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         isEmaillogin = !isEmaillogin;
                      //       });
                      //     },
                      //     child: isEmaillogin
                      //         ? Row(
                      //             mainAxisAlignment: MainAxisAlignment.end,
                      //             children: [
                      //               CustomText(
                      //                 content: "login with phone-number ",
                      //                 color: Config.lightText,
                      //                 fWeight: FontWeight.normal,
                      //                 size: width / 35,
                      //               ),
                      //               Icon(
                      //                 Icons.phone,
                      //                 color: Config.lightText,
                      //                 size: width / 25,
                      //               ),
                      //             ],
                      //           )
                      //         : Row(
                      //             mainAxisAlignment: MainAxisAlignment.end,
                      //             children: [
                      //               CustomText(
                      //                 content: "login with email ",
                      //                 color: Config.lightText,
                      //                 fWeight: FontWeight.normal,
                      //                 size: width / 35,
                      //               ),
                      //               Icon(
                      //                 Icons.email,
                      //                 color: Config.lightText,
                      //                 size: width / 35,
                      //               ),
                      //             ],
                      //           ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Image.asset(
                      "Assets/images/welcome.png",
                      scale: 1,
                      width: width,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

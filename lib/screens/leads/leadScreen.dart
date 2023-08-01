import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tcea_app/api/api.dart';
import 'package:tcea_app/provider/provider.dart';

import '../../config/config.dart';
import '../../widgets/customButton.dart';
import '../../widgets/customCategoryCard.dart';
import '../../widgets/customSupplierDetailsCard.dart';
import '../../widgets/customText.dart';

class LeadScreen extends ConsumerStatefulWidget {
  const LeadScreen({Key? key}) : super(key: key);

  @override
  _LeadScreenState createState() => _LeadScreenState();
}

class _LeadScreenState extends ConsumerState<LeadScreen> {
  Map<String, dynamic> user = {};
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    user = ref.read(userDetails);

    Api().getUser(user["id"]).then((value) {
      setState(() {
        ref.read(userDetails.notifier).update((state) => value.data);
        user = value.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: width,
            height: height * 0.3,
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'Assets/images/supplier/leads_supplier.png',
                  height: height * 0.3,
                ),
              ),
              const Positioned(
                  left: 15.0,
                  bottom: 30.0,
                  child: Text(
                    'Leads',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
            ]),
          ),
          Flexible(
            child: Container(
                child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1), () {
                  Api().getUser(user["id"]).then((value) {
                    setState(() {
                      user = value.data;
                    });
                  });

                  print(user["suppliers"]);
                });
              },
              child: CustomScrollView(
                primary: false,
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid.count(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                        if (user["suppliers"]["leads"].length < 1)
                          CustomText(
                            content: "No Leads Found",
                            size: width / 35,
                            color: Config.lightText,
                          ),
                        if (user["suppliers"]["leads"].length > 0)
                          for (var i = 0;
                              i < user["suppliers"]["leads"].length;
                              i++)
                            // Text(
                            //     "${user["suppliers"]["leads"][i]["inquiry"]["member"]}")
                            if (user["suppliers"]["leads"][i]["inquiry"]
                                    ["member"] !=
                                null)
                              InkWell(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        true, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        elevation: 10,
                                        backgroundColor: Config.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        title: Row(children: []),
                                        content: Container(
                                          color: Config.white,
                                          width: width,
                                          height: height * 0.5,
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListBody(
                                                children: [
                                                  if (user["suppliers"]["leads"]
                                                              [i]["inquiry"]
                                                          ["member"]["user"] ==
                                                      null)
                                                    Center(
                                                      child: SpinKitRipple(
                                                        color: Config.theme,
                                                        size: 30.0,
                                                      ),
                                                    ),
                                                  if (user["suppliers"]["leads"]
                                                              [i]["inquiry"]
                                                          ["member"]["user"] !=
                                                      null)
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 10),
                                                      width: width,
                                                      height: height * 0.07,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          // border: Border.all(color: Config.theme),
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              255, 252, 250)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                              child: CustomText(
                                                            content:
                                                                "Lead Details",
                                                            size: width / 30,
                                                            fWeight:
                                                                FontWeight.bold,
                                                            color: Config.theme,
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  CustomSupplierDetailsCard(
                                                    lable: "Lead Name",
                                                    value:
                                                        "${user["suppliers"]["leads"][i]["inquiry"]["member"]["name"]}",
                                                  ),
                                                  CustomSupplierDetailsCard(
                                                    lable: "Lead Email",
                                                    value:
                                                        "${user["suppliers"]["leads"][i]["inquiry"]["member"]["email"]}",
                                                  ),
                                                  CustomSupplierDetailsCard(
                                                    lable: "Lead Number",
                                                    value:
                                                        "${user["suppliers"]["leads"][i]["inquiry"]["member"]["user"]["mobile"]}",
                                                  ),
                                                  CustomSupplierDetailsCard(
                                                    lable: "Category",
                                                    value:
                                                        "${user["suppliers"]["leads"][i]["inquiry"]["categoryName"]}",
                                                  ),
                                                  CustomSupplierDetailsCard(
                                                    lable: "Description",
                                                    value:
                                                        "${user["suppliers"]["leads"][i]["inquiry"]["description"]}",
                                                  ),
                                                  Container(
                                                    width: width * 0.9,
                                                    margin:
                                                        EdgeInsets.only(top: 4),
                                                    height: height * 0.06,
                                                    child: CustomButton(
                                                      isloading: false,
                                                      bgColor: user["suppliers"]
                                                                      [
                                                                      "leads"][i]
                                                                  ["status"] ==
                                                              "pending"
                                                          ? Color.fromARGB(255,
                                                              217, 215, 213)
                                                          : const Color
                                                                  .fromARGB(255,
                                                              228, 248, 232),
                                                      onClick: () {
                                                        Api()
                                                            .changeStatus(
                                                                user["suppliers"]
                                                                        [
                                                                        "leads"]
                                                                    [i]["id"],
                                                                user["suppliers"]["leads"][i]
                                                                            [
                                                                            "status"] ==
                                                                        "pending"
                                                                    ? "completed"
                                                                    : "pending")
                                                            .then((value) {
                                                          if (value
                                                                  .statusCode ==
                                                              200) {
                                                            setState(() {
                                                              user = value.data;
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        });
                                                      },
                                                      widget: CustomText(
                                                        content:
                                                            user["suppliers"]
                                                                    ["leads"][i]
                                                                ["status"],
                                                        color: user["suppliers"]
                                                                        ["leads"][i]
                                                                    [
                                                                    "status"] ==
                                                                "pending"
                                                            ? Color.fromARGB(
                                                                255, 2, 2, 2)
                                                            : Color.fromARGB(
                                                                255,
                                                                23,
                                                                139,
                                                                47),
                                                        fWeight:
                                                            FontWeight.bold,
                                                        size: width / 30,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: CustomCategoryCard(
                                  img: user["suppliers"]["leads"][i]["inquiry"]
                                          ["member"]["image"] ??
                                      null,
                                  lable:
                                      "${user["suppliers"]["leads"][i]["inquiry"]["member"]["name"]}",
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
}

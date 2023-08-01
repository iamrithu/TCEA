import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tcea_app/config/config.dart';

import '../../provider/provider.dart';
import '../../widgets/customCategoryCard.dart';
import '../../widgets/customText.dart';

class EnquiryScreen extends ConsumerStatefulWidget {
  const EnquiryScreen({Key? key}) : super(key: key);

  @override
  _EnquiryScreenState createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends ConsumerState<EnquiryScreen> {
  int SNO = 0;

  String demo() {
    setState(() {
      SNO += 1;
    });
    return SNO.toString();
  }

  Map<String, dynamic> user = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      SNO = 0;
      user = ref.read(userDetails);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      SNO = 0;
    });
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
                width: width,
                height: height * 0.3,
                child: Image.asset('Assets/images/enquiry-banner.jpg'),
              ),
              Positioned(
                  left: 15.0,
                  bottom: 30.0,
                  child: Text(
                    " Enquiries",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
            ]),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.all(5),
              child: ListView(
                children: [
                  Container(
                    width: width,
                    constraints: BoxConstraints(minHeight: height * 0.05),
                    color: Config.bg,
                    child: Row(
                      children: [
                        Container(
                          width: width * 0.1,
                          constraints: BoxConstraints(minHeight: height * 0.05),
                          child: Center(
                            child: CustomText(
                              content: "S.No",
                              size: width / 34,
                              color: Config.black,
                              fWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            constraints:
                                BoxConstraints(minHeight: height * 0.05),
                            child: Center(
                              child: CustomText(
                                content: "Shop Name",
                                size: width / 34,
                                color: Config.black,
                                fWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.2,
                          constraints: BoxConstraints(minHeight: height * 0.05),
                          child: Center(
                            child: CustomText(
                              content: "Category",
                              size: width / 34,
                              color: Config.black,
                              fWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.2,
                          constraints: BoxConstraints(minHeight: height * 0.05),
                          child: Center(
                            child: CustomText(
                              content: "Status",
                              size: width / 34,
                              color: Config.black,
                              fWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (user["member"]["Inquiry"].length < 1)
                    CustomText(
                      content: "No Enquires Found",
                      size: width / 34,
                      color: Config.black,
                      fWeight: FontWeight.bold,
                    ),
                  if (user["member"]["Inquiry"].length > 0)
                    for (var i = 0; i < user["member"]["Inquiry"].length; i++)
                      for (var j = 0;
                          j < user["member"]["Inquiry"][i]["leads"].length;
                          j++)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          width: width,
                          constraints: BoxConstraints(minHeight: height * 0.05),
                          color: Config.white,
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.1,
                                constraints:
                                    BoxConstraints(minHeight: height * 0.05),
                                child: Center(
                                  child: CustomText(
                                    content: demo(),
                                    size: width / 34,
                                    color: Config.black,
                                    fWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  constraints:
                                      BoxConstraints(minHeight: height * 0.05),
                                  child: Center(
                                    child: CustomText(
                                      content: user["member"]["Inquiry"][i]
                                                  ["leads"][j]["suppliers"] ==
                                              null
                                          ? "--"
                                          : "${user["member"]["Inquiry"][i]["leads"][j]["suppliers"]["companyName"]}",
                                      size: width / 34,
                                      color: Config.black,
                                      fWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.2,
                                constraints:
                                    BoxConstraints(minHeight: height * 0.05),
                                child: Center(
                                  child: CustomText(
                                    content: user["member"]["Inquiry"][i]
                                            ["categoryName"] ??
                                        "--",
                                    size: width / 34,
                                    color: Config.black,
                                    fWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: width * 0.2,
                                constraints:
                                    BoxConstraints(minHeight: height * 0.05),
                                child: Center(
                                  child: Card(
                                    elevation: 5,
                                    color: user["member"]["Inquiry"][i]["leads"]
                                                [j]["status"] ==
                                            "pending"
                                        ? const Color.fromARGB(
                                            255, 221, 219, 219)
                                        : const Color.fromARGB(
                                            255, 227, 254, 232),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CustomText(
                                        content:
                                            "${user["member"]["Inquiry"][i]["leads"][j]["status"]}",
                                        size: width / 36,
                                        color: user["member"]["Inquiry"][i]
                                                    ["leads"][j]["status"] ==
                                                "pending"
                                            ? Colors.grey[900]
                                            : Config.bgSuc,
                                        fWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                ],
              ),
              // child: CustomScrollView(
              //   primary: false,
              //   slivers: <Widget>[
              //     SliverPadding(
              //       padding: const EdgeInsets.all(20),
              //       sliver: SliverGrid.count(
              //         crossAxisSpacing: 10,
              //         mainAxisSpacing: 10,
              //         crossAxisCount: 1,
              //         children: <Widget>[
              //           Text("${user}")
              //           // for (var i = 0; i < ref.watch(categoryList).length; i++)
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ),
          )
        ],
      ),
    );
  }
}

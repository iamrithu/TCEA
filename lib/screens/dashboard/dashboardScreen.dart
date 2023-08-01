import 'package:card_swiper/card_swiper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcea_app/config/config.dart';
import 'package:tcea_app/provider/provider.dart';

import '../../api/api.dart';
import '../../widgets/customGridContainer.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final List<String> supplier = [
    'Assets/images/supplier/image1.jpg',
    'Assets/images/supplier/image2.jpg',
    'Assets/images/supplier/image3.jpg',
  ];
  final List<String> member = [
    'Assets/images/image1.jpg',
    'Assets/images/image2.jpg',
    'Assets/images/image3.jpg',
  ];
  final SwiperController _swiperController = SwiperController();
  int _currentIndex = 0;
  Map<String, dynamic> user = {};
  List<dynamic> suppliers = [];
  List<dynamic> categories = [];
  List<dynamic> completedLead = [];
  List<dynamic> pendingLead = [];
  List<dynamic> completedEnquiry = [];
  List<dynamic> pendingEnquiry = [];
  int SNO = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api().getAllSuppliers().then((value) {
      setState(() {
        suppliers = value.data;
      });
      ref.read(supplierList.notifier).update((state) => suppliers);
    });
    Api().getAllCategory().then((value) {
      setState(() {
        categories = value.data;
      });
      ref.read(categoryList.notifier).update((state) => categories);
    });

    setState(() {
      user = ref.read(userDetails);
      suppliers = ref.read(supplierList);
      categories = ref.read(categoryList);
    });
    Api().getUser(user["id"]).then((value) {
      setState(() {
        user = value.data;
      });

      if (ref.read(userRole) == "supplier")
        for (var i = 0; i < user["suppliers"]["leads"].length; i++) {
          if (user["suppliers"]["leads"][i]["status"] == "completed") {
            completedLead.add(user["suppliers"]["leads"][i]);
          } else {
            pendingLead.add(user["suppliers"]["leads"][i]);
          }
        }
    });
    if (ref.read(userRole) == "member")
      for (var i = 0; i < user["member"]["Inquiry"].length; i++)
        for (var j = 0; j < user["member"]["Inquiry"][i]["leads"].length; j++) {
          setState(() {
            SNO += 1;
          });
          if (user["member"]["Inquiry"][i]["leads"][j]["status"] == "pending") {
            pendingEnquiry.add(user["member"]["Inquiry"][i]["leads"][j]);
          } else {
            completedEnquiry.add(user["member"]["Inquiry"][i]["leads"][j]);
          }
        }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                SizedBox(
                  height: height *
                      0.3, // Adjust the height according to your requirements
                  child: Swiper(
                    itemCount: ref.watch(userRole) == "memebr"
                        ? member.length
                        : supplier.length,
                    controller: _swiperController,
                    autoplay: false,
                    onIndexChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        ref.watch(userRole) == "member"
                            ? member[index]
                            : supplier[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                    right: 100,
                    bottom: 25,
                    child: RawMaterialButton(
                      onPressed: () {
                        _swiperController.previous();
                      },
                      elevation: 2.0,
                      fillColor: const Color(0xffcb6718),
                      padding: const EdgeInsets.all(10.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 15.0,
                        color: Colors.white,
                      ),
                    )),
                Positioned(
                    right: 10,
                    bottom: 25,
                    child: RawMaterialButton(
                      onPressed: () {
                        _swiperController.next();
                      },
                      elevation: 2.0,
                      fillColor: const Color(0xffcb6718),
                      padding: const EdgeInsets.all(10.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15.0,
                        color: Colors.white,
                      ),
                    )),
                Positioned(
                  left: 10.0,
                  bottom: 25.0,
                  child: DotsIndicator(
                    dotsCount: ref.watch(userRole) == "memebr"
                        ? member.length
                        : supplier.length,
                    position: _currentIndex,
                    decorator: DotsDecorator(
                      color: Colors.white,
                      activeColor: const Color(0xffcb6718),
                      size: const Size.square(8.0),
                      activeSize: const Size(12.0, 12.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 120.0,
                  left: 15.0,
                  child: Text(
                    'WELCOME TO TIRUPUR CIVIL ENGINEERS\nASSOCIATION',
                    style: GoogleFonts.aBeeZee(
                        color: Config.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
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
                      if (ref.watch(userRole) == "member")
                        CustomGridContainer(
                          img: "Assets/images/category.png",
                          content: "CATEGORIES",
                          value: "${ref.watch(categoryList).length}",
                        ),
                      if (ref.watch(userRole) == "member")
                        CustomGridContainer(
                          img: "Assets/images/supplier.png",
                          content: "SUPPLIERS",
                          value: "${ref.watch(supplierList).length}",
                        ),
                      if (ref.watch(userRole) == "member")
                        CustomGridContainer(
                          img: "Assets/images/enquiry.png",
                          content: "ENQUIRIES",
                          value: "${SNO}",
                        ),
                      if (ref.watch(userRole) == "member")
                        CustomGridContainer(
                          img: "Assets/images/enquiry.png",
                          content: "COMPLETED ENQUIRIES",
                          value: "${completedEnquiry.length}",
                        ),
                      if (ref.watch(userRole) == "member")
                        CustomGridContainer(
                          img: "Assets/images/enquiry.png",
                          content: "PENDING ENQUIRIES",
                          value: "${pendingEnquiry.length}",
                        ),
                      if (ref.watch(userRole) == "supplier")
                        CustomGridContainer(
                          img: "Assets/images/enquiry.png",
                          content: "TOTAL LEADS",
                          value: "${user["suppliers"]["leads"].length}",
                        ),
                      if (ref.watch(userRole) == "supplier")
                        CustomGridContainer(
                          img: "Assets/images/enquiry.png",
                          content: "COMPLETED LEADS",
                          value: "${completedLead.length}",
                        ),
                      if (ref.watch(userRole) == "supplier")
                        CustomGridContainer(
                          img: "Assets/images/enquiry.png",
                          content: "PENDING LEADS",
                          value: "${pendingLead.length}",
                        ),
                      // if (ref.watch(userRole) == "supplier")
                      //   CustomGridContainer(
                      //     img: "Assets/images/enquiry.png",
                      //     content: "PROFILE",
                      //     value: "${user["suppliers"]["leads"].length}",
                      //   ),
                    ],
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcea_app/config/config.dart';
import 'package:tcea_app/provider/provider.dart';
import 'package:tcea_app/screens/category/categoryScreen.dart';
import 'package:tcea_app/screens/dashboard/dashboardScreen.dart';
import 'package:tcea_app/screens/enquiry/enquiryScreen.dart';
import 'package:tcea_app/screens/leads/leadScreen.dart';
import 'package:tcea_app/screens/loginScreen/loginScreen.dart';
import 'package:tcea_app/screens/logout/logoutScreen.dart';
import 'package:tcea_app/screens/suppliers/suppliersScreen.dart';
import 'package:tcea_app/widgets/customButton.dart';
import 'package:tcea_app/widgets/customText.dart';

import '../profile/profileScreen.dart';
import '../../widgets/customTabBar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentTab = 2;

  pageRedirect(int val) {
    setState(() {
      currentTab = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screen = [
      ref.watch(userRole) == "member" ? CategoryScreen() : LeadScreen(),
      EnquiryScreen(),
      DashboardScreen(),
      SuppliersScreen(),
      LogoutScreen(),
    ];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.bg,
        title: CustomText(
          content: "TCEA",
          size: width / 20,
          color: Config.black,
          fWeight: FontWeight.bold,
        ),
        leading: Center(
          child: Image.asset(
            "Assets/images/LogoIcon.png",
            scale: 1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                )
              },
              child: Icon(
                Icons.person,
                color: Config.theme,
              ),
            ),
          ),
        ],
      ),
      body: screen[currentTab],
      bottomNavigationBar: Container(
        width: width,
        height: 70,
        color: Config.bg,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.35,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ref.watch(userRole) == "member"
                      ? CustomTabBar(
                          lable: "Category",
                          img: "Assets/images/category.png",
                          isActive: currentTab == 0,
                          onClick: () => {pageRedirect(0)},
                        )
                      : CustomTabBar(
                          lable: "Leads",
                          img: "Assets/images/supplier/leads.png",
                          isActive: currentTab == 0,
                          onClick: () => {pageRedirect(0)},
                        ),
                  if (ref.watch(userRole) == "member")
                    CustomTabBar(
                      lable: "Enquiry",
                      img: "Assets/images/enquiry.png",
                      isActive: currentTab == 1,
                      onClick: () => {pageRedirect(1)},
                    )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              width: width * 0.2,
              child: Center(
                child: CustomText(
                  content: "Dashboard",
                  size: width / 30,
                  color: currentTab == 2 ? Config.theme : Config.lightText,
                ),
              ),
              height: 60,
            ),
            Container(
              width: width * 0.35,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (ref.watch(userRole) == "member")
                    CustomTabBar(
                      lable: "Suppliers",
                      img: "Assets/images/supplier.png",
                      isActive: currentTab == 3,
                      onClick: () => {pageRedirect(3)},
                    ),
                  CustomTabBar(
                    lable: "Logout",
                    img: "Assets/images/logout.png",
                    isActive: currentTab == 4,
                    onClick: () => {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 10,
                            backgroundColor: Config.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Row(children: []),
                            content: Container(
                              color: Config.white,
                              width: width,
                              height: height * 0.1,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListBody(
                                    children: [
                                      CustomText(
                                        content: "Are you sure to logout",
                                        fWeight: FontWeight.bold,
                                        size: width / 25,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CustomButton(
                                            bgColor: Config.white,
                                            borderColor: Config.black,
                                            onClick: () {
                                              Navigator.pop(context);
                                            },
                                            widget: CustomText(
                                              content: "Cancel",
                                              fWeight: FontWeight.bold,
                                              size: width / 25,
                                            ),
                                            isloading: false,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CustomButton(
                                              bgColor: Config.theme,
                                              borderColor: Config.black,
                                              onClick: () async {
                                                final SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await prefs.setString(
                                                    'action', "");
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen(),
                                                  ),
                                                );
                                                pageRedirect(4);
                                              },
                                              widget: CustomText(
                                                color: Config.white,
                                                content: "Logout",
                                                fWeight: FontWeight.bold,
                                                size: width / 25,
                                              ),
                                              isloading: false,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config.white,
        onPressed: () {
          pageRedirect(2);
        },
        child: Icon(
          Icons.dashboard_outlined,
          color: currentTab == 2 ? Config.theme : Config.lightText,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

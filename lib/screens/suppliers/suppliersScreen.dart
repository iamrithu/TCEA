import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api.dart';
import '../../config/config.dart';
import '../../provider/provider.dart';
import '../../widgets/customButton.dart';
import '../../widgets/customCategoryCard.dart';
import '../../widgets/customSupplierDetailsCard.dart';
import '../../widgets/customText.dart';
import '../../widgets/customeInput.dart';

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({Key? key}) : super(key: key);

  @override
  _SuppliersScreenState createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  final TextEditingController categories = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> suppliers = [];
  List<dynamic> fillterdSuppliers = [];
  List<dynamic> selectedSuppliers = [];
  List<String> selectedSuppliersId = [];
  List<String> fillterdAllSuppliersId = [];
  bool isLoading = false;

  String catLable = "All";
  String catId = "";

  String getCat(String val) {
    return ref
        .read(categoryList)
        .firstWhere((element) => element["id"] == val)["name"];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fillterdSuppliers = ref.read(supplierList);
    });
    Api().getAllSuppliers().then((value) {
      setState(() {
        suppliers = value.data;
        fillterdSuppliers = value.data;
        for (var i = 0; i < suppliers.length; i++) {
          fillterdAllSuppliersId.add(suppliers[i]["id"]);
        }
      });
      ref.read(supplierList.notifier).update((state) => suppliers);
    });
  }

  @override
  Widget build(BuildContext context) {
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

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: width,
            height: height * 0.2,
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'Assets/images/supplier_bg.png',
                  height: height * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                  left: 15.0,
                  bottom: 30.0,
                  child: Text(
                    'Suppliers',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
            ]),
          ),
          Container(
            width: width,
            padding: EdgeInsets.all(5),
            height: height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Filter By',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(Icons.filter_alt),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          elevation: 1,
                          backgroundColor: Config.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Row(children: []),
                          content: Container(
                            color: Config.white,
                            width: width,
                            height: height,
                            child: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  CustomText(
                                    content: "Categories",
                                    size: width / 30,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fWeight: FontWeight.bold,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        catId = "";
                                        catLable = "All";
                                        selectedSuppliers = [];
                                        selectedSuppliersId = [];
                                        fillterdSuppliers = suppliers;
                                      });
                                      fillterdAllSuppliersId = [];
                                      for (var i = 0;
                                          i < suppliers.length;
                                          i++) {
                                        fillterdAllSuppliersId
                                            .add(suppliers[i]["id"]);
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: width,
                                      height: height * 0.05,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Config.theme),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: CustomText(
                                          content: "All",
                                          size: width / 30,
                                          color: const Color.fromARGB(
                                              255, 90, 88, 88),
                                          fWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  for (var i = 0;
                                      i < ref.watch(categoryList).length;
                                      i++)
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          fillterdSuppliers = [];
                                          selectedSuppliers = [];
                                          selectedSuppliersId = [];
                                          fillterdAllSuppliersId = [];
                                          catId =
                                              ref.watch(categoryList)[i]["id"];
                                          catLable = ref.watch(categoryList)[i]
                                              ["name"];
                                        });

                                        for (var i = 0;
                                            i < suppliers.length;
                                            i++) {
                                          if (suppliers[i]["categories"]
                                              .contains(catId)) {
                                            fillterdSuppliers.add(suppliers[i]);
                                            selectedSuppliers.add(suppliers[i]);
                                            fillterdAllSuppliersId
                                                .add(suppliers[i]["id"]);
                                          }
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: catLable ==
                                                        ref.watch(
                                                                categoryList)[i]
                                                            ["name"]
                                                    ? Config.bgSuc
                                                    : Config.white),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: CustomCategoryCard(
                                          img: ref.watch(categoryList)[i]
                                                  ["image"] ??
                                              null,
                                          lable:
                                              "${ref.watch(categoryList)[i]["name"]}",
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: height * 0.07,
                      width: width * 0.4,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Config.bg,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category,
                            color: Config.theme,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CustomText(
                            content: "${catLable}",
                            size: width / 30,
                            color: const Color.fromARGB(255, 90, 88, 88),
                            fWeight: FontWeight.bold,
                          ),
                        ],
                      )),
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
                      for (var i = 0; i < fillterdSuppliers.length; i++)
                        InkWell(
                          onTap: () {
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
                                    height: height,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            ref.watch(supplierList)[i]
                                                        ["user"] ==
                                                    null
                                                ? ListBody(
                                                    children: [],
                                                  )
                                                : ListBody(
                                                    children: <Widget>[
                                                      CustomText(
                                                        content:
                                                            "Supplier Details",
                                                        size: width / 30,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      Container(
                                                        width: width,
                                                        height: height * 0.15,
                                                        child: Center(
                                                          child: Card(
                                                            elevation: 10,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child: fillterdSuppliers[i]
                                                                              [
                                                                              "user"]
                                                                          [
                                                                          "image"] ==
                                                                      ""
                                                                  ? Image.asset(
                                                                      width:
                                                                          width *
                                                                              0.3,
                                                                      height:
                                                                          width *
                                                                              0.3,
                                                                      scale: 1,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      "Assets/images/no-image.png",
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      width:
                                                                          width *
                                                                              0.3,
                                                                      height:
                                                                          width *
                                                                              0.3,
                                                                      "${fillterdSuppliers[i]["user"]["image"]}",
                                                                      scale: 1,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      CustomSupplierDetailsCard(
                                                        lable: "Name",
                                                        value:
                                                            "${fillterdSuppliers[i]["user"]["name"]}",
                                                      ),
                                                      CustomSupplierDetailsCard(
                                                        lable: "Email",
                                                        value:
                                                            "${fillterdSuppliers[i]["user"]["email"]}",
                                                      ),
                                                      CustomSupplierDetailsCard(
                                                        lable: "Mobile",
                                                        value:
                                                            "${fillterdSuppliers[i]["user"]["mobile"]}",
                                                      ),
                                                      Divider(),
                                                      CustomText(
                                                        content: "Shop Details",
                                                        size: width / 30,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      Container(
                                                        width: width,
                                                        height: height * 0.15,
                                                        child: Center(
                                                          child: Card(
                                                            elevation: 10,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child: fillterdSuppliers[i]
                                                                              [
                                                                              "user"]
                                                                          [
                                                                          "image"] ==
                                                                      ""
                                                                  ? Image.asset(
                                                                      width:
                                                                          width *
                                                                              0.3,
                                                                      height:
                                                                          width *
                                                                              0.3,
                                                                      scale: 1,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      "Assets/images/no-image.png",
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      width:
                                                                          width *
                                                                              0.3,
                                                                      height:
                                                                          width *
                                                                              0.3,
                                                                      "${fillterdSuppliers[i]["user"]["image"]}",
                                                                      scale: 1,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      CustomSupplierDetailsCard(
                                                        lable: "Shop Name",
                                                        value:
                                                            "${fillterdSuppliers[i]["companyName"]}",
                                                      ),
                                                      CustomSupplierDetailsCard(
                                                        lable: "Mobile",
                                                        value:
                                                            "${fillterdSuppliers[i]["user"]["mobile"]}",
                                                      ),
                                                      CustomSupplierDetailsCard(
                                                        lable: "Description",
                                                        value:
                                                            "${fillterdSuppliers[i]["companyDesc"]}",
                                                      ),
                                                      CustomSupplierDetailsCard(
                                                        alignLeft: true,
                                                        lable: "Address",
                                                        value:
                                                            "${fillterdSuppliers[i]["address"]}",
                                                      ),
                                                      Divider(),
                                                      CustomText(
                                                        content: "Categories:",
                                                        size: width / 30,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      Container(
                                                        width: width,
                                                        height: height * 0.5,
                                                        child: CustomScrollView(
                                                          primary: false,
                                                          slivers: <Widget>[
                                                            SliverPadding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              sliver: SliverGrid
                                                                  .count(
                                                                crossAxisSpacing:
                                                                    10,
                                                                mainAxisSpacing:
                                                                    10,
                                                                crossAxisCount:
                                                                    2,
                                                                children: <Widget>[
                                                                  for (var j =
                                                                          0;
                                                                      j <
                                                                          fillterdSuppliers[i]["categories"]
                                                                              .length;
                                                                      j++)
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          border:
                                                                              Border.all(color: Config.theme)),
                                                                      width:
                                                                          width,
                                                                      height:
                                                                          height,
                                                                      child: Center(
                                                                          child: CustomText(
                                                                        fWeight:
                                                                            FontWeight.bold,
                                                                        size: width /
                                                                            35,
                                                                        content:
                                                                            getCat(fillterdSuppliers[i]["categories"][j]),
                                                                      )),
                                                                    )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  CustomCategoryCard(
                                    img: "${fillterdSuppliers[i]["image"]}",
                                    lable:
                                        "${fillterdSuppliers[i]["companyName"]}",
                                  ),
                                ],
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: selectedSuppliersId
                                    .contains(fillterdSuppliers[i]["id"]),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (selectedSuppliersId.length < 1) {
                                      selectedSuppliersId
                                          .add(fillterdSuppliers[i]["id"]);
                                    } else {
                                      if (selectedSuppliersId.contains(
                                          fillterdSuppliers[i]["id"])) {
                                        selectedSuppliersId
                                            .remove(fillterdSuppliers[i]["id"]);
                                      } else {
                                        selectedSuppliersId
                                            .add(fillterdSuppliers[i]["id"]);
                                      }
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )),
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: catLable != "All",
        child: FloatingActionButton(
          backgroundColor: catLable == "All" ? Colors.grey : Config.theme,
          onPressed: catLable == "All"
              ? null
              : () {
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
                          height: height * 0.5,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListBody(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: width,
                                    height: height * 0.07,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        // border: Border.all(color: Config.theme),
                                        color: Config.bg),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.category,
                                          color: Config.theme,
                                        ),
                                        Center(
                                            child: CustomText(
                                          content: "${catLable}",
                                          size: width / 25,
                                          color: Config.theme,
                                        )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: width,
                                    height: height * 0.07,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        // border: Border.all(color: Config.theme),
                                        color: Config.bg),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          content: "Suppliers",
                                          size: width / 25,
                                          color: Config.theme,
                                        ),
                                        CustomText(
                                          content:
                                              "(${selectedSuppliersId.length < 1 ? fillterdAllSuppliersId.length : selectedSuppliersId.length})",
                                          size: width / 25,
                                          color: Config.theme,
                                        ),
                                      ],
                                    )),
                                  ),
                                  CustomTextForm(
                                    isReadOnly: false,
                                    icon: Icons.text_snippet,
                                    hide: false,
                                    width: width,
                                    isTextForm: true,
                                    controller: _descriptionController,
                                    lable: "Description",
                                  ),
                                  Container(
                                    width: width * 0.9,
                                    margin: EdgeInsets.only(top: 4),
                                    height: height * 0.06,
                                    child: CustomButton(
                                      isloading: false,
                                      bgColor: Config.theme,
                                      onClick: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        Api()
                                            .generateEnquiry(
                                                catId,
                                                ref.watch(userDetails)["member"]
                                                    ["id"],
                                                selectedSuppliersId.isEmpty
                                                    ? fillterdAllSuppliersId
                                                    : selectedSuppliersId,
                                                _descriptionController.text,
                                                catLable,
                                                "")
                                            .then((value) {
                                          if (value.statusCode == 200) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            customAlert(
                                              context: context,
                                              height: height,
                                              width: width,
                                              content: "Enquiries Generated",
                                              success: true,
                                            );
                                            ref
                                                .watch(userDetails.notifier)
                                                .update((state) => value.data);

                                            Navigator.pop(context);
                                          }
                                        });
                                      },
                                      widget: CustomText(
                                        content: "Send",
                                        color: Config.white,
                                        fWeight: FontWeight.bold,
                                        size: width > 600 ? 38 : 18,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.mail,
                color: Config.white,
              ),
              CustomText(
                content:
                    "${selectedSuppliersId.length < 1 ? fillterdAllSuppliersId.length : selectedSuppliersId.length}",
                size: width / 30,
                color: Color.fromARGB(255, 255, 255, 255),
                fWeight: FontWeight.bold,
              ),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

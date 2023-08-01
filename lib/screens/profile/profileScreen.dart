import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcea_app/widgets/customButton.dart';

import '../../../config/config.dart';
import '../../../provider/provider.dart';
import '../../../widgets/customText.dart';
import '../../../widgets/customeInput.dart';
import '../../api/api.dart';
import '../../widgets/customTabBar.dart';
import '../loginScreen/loginScreen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postController = TextEditingController();

  Map<String, dynamic> user = {};
  List<dynamic> cat = [];
  String cldUser = "";
  String cldShop = "";
  bool isLoading = false;

  List category = [];
  File userImages = File("");
  final cloudinary = Cloudinary.signedConfig(
    apiKey: "354791567965261",
    apiSecret: "gI_KDNAXWc9EHvtpySVHjMbq-jc",
    cloudName: "dxjmi08tr",
  );

  bool isEditable = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      user = ref.read(userDetails);
      _emailController.text = user["email"];
      _nameController.text = user["name"];
      _mobileController.text = user["mobile"];

      if (user["member"] != null) {
        _addressController.text = "--";
        _companyController.text = user["member"]["companyName"];
        _descriptionController.text = user["member"]["companyDesc"];
        _postController.text = user["member"]["post"];
      }
      if (user["suppliers"] != null) {
        _addressController.text = user["suppliers"]["address"];
        _companyController.text = user["suppliers"]["companyName"];
        _descriptionController.text = user["suppliers"]["companyDesc"];
      }
    });
    if (ref.read(userRole) != "member")
      setState(() {
        cat = user["suppliers"]["categories"];
      });
    if (ref.read(userRole) != "member")
      for (var i = 0; i < cat.length; i++) {
        setState(() {
          category.add(cat[i]);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String getCat(String val) {
      return ref
          .read(categoryList)
          .firstWhere((element) => element["id"] == val)["name"];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.bg,
        title: CustomText(
          content: "Profile",
          size: width / 20,
          color: Config.black,
          fWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Config.theme,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CustomTabBar(
              isActive: false,
              lable: "",
              img: "Assets/images/logout.png",
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
                                          await prefs.setString('action', "");
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen(),
                                            ),
                                          );
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
            ),
          ),
          if (isEditable)
            Container(
              height: height * 0.05,
              width: width * 0.15,
              margin: EdgeInsets.only(right: 5),
              child: CustomButton(
                  bgColor: Config.white,
                  onClick: () {
                    setState(() {
                      user = ref.read(userDetails);
                      _emailController.text = user["email"];
                      _nameController.text = user["name"];
                      _mobileController.text = user["mobile"];

                      if (user["member"] != null) {
                        _addressController.text = "--";
                        _companyController.text = user["member"]["companyName"];
                        _descriptionController.text =
                            user["member"]["companyDesc"];
                        _postController.text = user["member"]["post"];
                      }
                      if (user["suppliers"] != null) {
                        _addressController.text = user["suppliers"]["address"];
                        _companyController.text =
                            user["suppliers"]["companyName"];
                        _descriptionController.text =
                            user["suppliers"]["companyDesc"];
                      }
                    });

                    setState(() {
                      isEditable = !isEditable;
                      // cat = category;
                    });
                  },
                  widget: Icon(
                    Icons.cancel,
                    color: Config.bgFail,
                  ),
                  isloading: false),
            )
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(5),
              child: ListView(
                children: [
                  InkWell(
                    onTap: !isEditable
                        ? () {}
                        : () async {
                            setState(() {
                              isLoading = true;
                            });
                            final ImagePicker picker = ImagePicker();

                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              userImages = File(image.path);
                              final response = await cloudinary.upload(
                                  file: userImages.path,
                                  fileBytes: userImages.readAsBytesSync(),
                                  resourceType: CloudinaryResourceType.image,
                                  folder: "TCEA",
                                  fileName: 'some-name');

                              setState(() {
                                cldUser = response.secureUrl!;

                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                    child: Container(
                      width: width,
                      height: height * 0.15,
                      child: Center(
                        // child: Text("${"${user}"}"),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: cldUser != ""
                                ? Image.network(
                                    width: width * 0.3,
                                    height: width * 0.3,
                                    "${cldUser}",
                                    scale: 1,
                                    fit: BoxFit.cover,
                                  )
                                : user["image"] == ""
                                    ? Image.asset(
                                        width: width * 0.3,
                                        height: width * 0.3,
                                        "Assets/images/no-image.png",
                                        scale: 1,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        width: width * 0.3,
                                        height: width * 0.3,
                                        "${user["image"]}",
                                        scale: 1,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomTextForm(
                    isReadOnly: !isEditable,
                    icon: Icons.person,
                    hide: false,
                    width: width,
                    controller: _nameController,
                    lable: "Name",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    isReadOnly: !isEditable,
                    icon: Icons.email,
                    hide: false,
                    width: width,
                    controller: _emailController,
                    lable: "Email",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    isReadOnly: !isEditable,
                    icon: Icons.mobile_screen_share_rounded,
                    hide: false,
                    width: width,
                    controller: _mobileController,
                    lable: "Mobile Number",
                  ),
                  if (ref.watch(userRole) != "member")
                    CustomText(
                      content: "Shop Details",
                      size: width / 25,
                      color: Config.black,
                      fWeight: FontWeight.bold,
                    ),
                  if (ref.watch(userRole) != "member")
                    InkWell(
                      onTap: !isEditable
                          ? () {}
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              final ImagePicker picker = ImagePicker();

                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                userImages = File(image.path);
                                final response = await cloudinary.upload(
                                    file: userImages.path,
                                    fileBytes: userImages.readAsBytesSync(),
                                    resourceType: CloudinaryResourceType.image,
                                    folder: "TCEA",
                                    fileName: 'shop-images');

                                setState(() {
                                  cldShop = response.secureUrl!;
                                  isLoading = false;
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                      child: Container(
                        width: width,
                        height: height * 0.15,
                        child: Center(
                          // child: Text("${"${user}"}"),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              // child: Text(
                              //   "${user["suppliers"]["shopImage"]}",
                              // ),
                              child: cldShop != ""
                                  ? Image.network(
                                      width: width * 0.3,
                                      height: width * 0.3,
                                      "${cldShop}",
                                      scale: 1,
                                      fit: BoxFit.cover,
                                    )
                                  : user["suppliers"]["shopImage"] == ""
                                      ? Image.asset(
                                          width: width * 0.3,
                                          height: width * 0.3,
                                          "Assets/images/no-image.png",
                                          scale: 1,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          width: width * 0.3,
                                          height: width * 0.3,
                                          "${user["suppliers"]["shopImage"]}",
                                          scale: 1,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (ref.watch(userRole) == "member")
                    SizedBox(
                      height: 10,
                    ),
                  if (ref.watch(userRole) == "member")
                    CustomTextForm(
                      isReadOnly: true,
                      icon: Icons.roller_shades,
                      hide: false,
                      width: width,
                      controller: _postController,
                      lable: "Post",
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    isReadOnly: !isEditable,
                    icon: Icons.construction,
                    hide: false,
                    width: width,
                    controller: _companyController,
                    lable: ref.watch(userRole) == "member"
                        ? "Company Name"
                        : "Shop Name",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    isReadOnly: !isEditable,
                    icon: Icons.text_snippet,
                    hide: false,
                    width: width,
                    isTextForm: true,
                    controller: _descriptionController,
                    lable: "Description",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    isReadOnly: !isEditable,
                    icon: Icons.route,
                    hide: false,
                    width: width,
                    isTextForm: true,
                    controller: _addressController,
                    lable: "Address",
                  ),
                  if (ref.read(userRole) != "member")
                    CustomText(
                      content: "Categories",
                      size: width / 25,
                      color: Config.black,
                      fWeight: FontWeight.bold,
                    ),
                  if (!isEditable)
                    if (ref.read(userRole) != "member")
                      cat.length < 1
                          ? Text("")
                          : Card(
                              child: Container(
                                width: width,
                                height: height * 0.5,
                                child: CustomScrollView(
                                  primary: false,
                                  slivers: <Widget>[
                                    SliverPadding(
                                      padding: const EdgeInsets.all(20),
                                      sliver: SliverGrid.count(
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        crossAxisCount: 4,
                                        children: <Widget>[
                                          for (var j = 0; j < cat.length; j++)
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Config.theme)),
                                              width: width,
                                              height: height,
                                              child: Center(
                                                  child: CustomText(
                                                fWeight: FontWeight.bold,
                                                size: width / 35,
                                                content: getCat(
                                                    user["suppliers"]
                                                        ["categories"][j]),
                                              )),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  if (isEditable)
                    if (ref.read(userRole) != "member")
                      Card(
                        child: Container(
                          width: width,
                          height: height * 0.5,
                          child: CustomScrollView(
                            primary: false,
                            slivers: <Widget>[
                              SliverPadding(
                                padding: const EdgeInsets.all(20),
                                sliver: SliverGrid.count(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 4,
                                  children: <Widget>[
                                    for (var j = 0;
                                        j < ref.watch(categoryList).length;
                                        j++)
                                      InkWell(
                                        onTap: () {
                                          if (cat.contains(ref
                                              .watch(categoryList)[j]["id"])) {
                                            setState(() {
                                              cat.remove(
                                                  ref.watch(categoryList)[j]
                                                      ["id"]);
                                            });
                                          } else {
                                            setState(() {
                                              cat.add(ref.watch(categoryList)[j]
                                                  ["id"]);
                                            });
                                          }
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Config.theme),
                                                color: cat.contains(ref.watch(
                                                        categoryList)[j]["id"])
                                                    ? Config.theme
                                                    : Config.white),
                                            width: width,
                                            height: height,
                                            child: Center(
                                              child: CustomText(
                                                  color: cat.contains(ref.watch(
                                                              categoryList)[j]
                                                          ["id"])
                                                      ? Config.white
                                                      : Config.theme,
                                                  fWeight: FontWeight.bold,
                                                  size: width / 35,
                                                  content:
                                                      ref.watch(categoryList)[j]
                                                          ["name"]),
                                            )),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                ],
              ),
            ),
          ),
          // Container(
          //   color: Config.bg,
          //   width: width,
          //   height: height * 0.1,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       if (!isEditable)
          //         Container(
          //           width: width * 0.3,
          //           height: height * 0.05,
          //           child: CustomButton(
          //               bgColor: Config.theme,
          //               onClick: () {
          //                 setState(() {
          //                   isEditable = !isEditable;
          //                 });
          //               },
          //               widget: CustomText(
          //                 content: "Edit",
          //                 color: Config.white,
          //                 fWeight: FontWeight.bold,
          //                 size: width > 600 ? 38 : 18,
          //               ),
          //               isloading: false),
          //         ),
          //       if (isEditable)
          //         Container(
          //           height: height * 0.05,
          //           child: CustomButton(
          //               bgColor: Config.lightText,
          //               onClick: () {
          //                 setState(() {
          //                   user = ref.read(userDetails);
          //                   _emailController.text = user["email"];
          //                   _nameController.text = user["name"];
          //                   _mobileController.text = user["mobile"];

          //                   if (user["member"] != null) {
          //                     _addressController.text = "--";
          //                     _companyController.text =
          //                         user["member"]["companyName"];
          //                     _descriptionController.text =
          //                         user["member"]["companyDesc"];
          //                     _postController.text = user["member"]["post"];
          //                   }
          //                   if (user["suppliers"] != null) {
          //                     _addressController.text =
          //                         user["suppliers"]["address"];
          //                     _companyController.text =
          //                         user["suppliers"]["companyName"];
          //                     _descriptionController.text =
          //                         user["suppliers"]["companyDesc"];
          //                   }
          //                 });

          //                 setState(() {
          //                   isEditable = !isEditable;
          //                   // cat = category;
          //                 });
          //               },
          //               widget: CustomText(
          //                 content: "Cancel",
          //                 color: Config.white,
          //                 fWeight: FontWeight.bold,
          //                 size: width > 600 ? 38 : 18,
          //               ),
          //               isloading: false),
          //         ),
          //     ],
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config.theme,
        onPressed: !isEditable
            ? () {
                setState(() {
                  isEditable = !isEditable;
                });
              }
            : () {
                setState(() {
                  isLoading = true;
                });
                if (ref.watch(userRole) == "member") {
                  Api()
                      .updateProfile(
                    user["id"],
                    _emailController.text.trim(),
                    _nameController.text.trim(),
                    ref.watch(userRole),
                    _mobileController.text.trim(),
                    _companyController.text.trim(),
                    _descriptionController.text.trim(),
                    cldUser == "" ? user["image"] : cldUser,
                    _postController.text.trim(),
                  )
                      .then((value) {
                    if (value.statusCode == 200) {
                      ref
                          .read(userDetails.notifier)
                          .update((state) => value.data);
                      setState(() {
                        isLoading = false;
                      });
                      customAlert(
                        context: context,
                        height: height,
                        width: width,
                        content: "User Updated",
                        success: true,
                      );
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      customAlert(
                        context: context,
                        height: height,
                        width: width,
                        content: "something Went Wrong",
                        success: false,
                      );
                    }
                  });
                } else {
                  Api()
                      .updateSupplierProfile(
                          user["id"],
                          _emailController.text.trim(),
                          _nameController.text.trim(),
                          ref.watch(userRole),
                          _mobileController.text.trim(),
                          _companyController.text.trim(),
                          _descriptionController.text.trim(),
                          cldShop == ""
                              ? user["suppliers"]["shopImage"] ?? ""
                              : cldShop,
                          cat,
                          cldUser == "" ? user["image"] : cldUser,
                          _addressController.text.trim())
                      .then((value) {
                    print(value);
                    if (value.statusCode == 200) {
                      ref
                          .read(userDetails.notifier)
                          .update((state) => value.data);
                      setState(() {
                        isLoading = false;
                      });
                      customAlert(
                        context: context,
                        height: height,
                        width: width,
                        content: "User Updated",
                        success: true,
                      );
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      customAlert(
                        context: context,
                        height: height,
                        width: width,
                        content: "something Went Wrong",
                        success: false,
                      );
                    }
                  });
                }
                setState(() {
                  isEditable = !isEditable;
                });
              },
        child: isLoading == true
            ? Center(
                child: SpinKitRipple(
                  color: Colors.white,
                  size: 30.0,
                ),
              )
            : Icon(
                !isEditable ? Icons.edit : Icons.check,
                color: Config.white,
              ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}

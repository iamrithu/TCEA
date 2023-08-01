import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcea_app/screens/loginScreen/loginScreen.dart';

import '../../api/api.dart';
import '../../config/config.dart';
import '../../provider/provider.dart';
import '../home/homeScreen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isAnimated = false;
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
    } else {
      Future.delayed(Duration(milliseconds: 2500), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        isAnimated = true;
      });
    });
    checkAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Config.bg,
        body: Container(
          color: Config.white,
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 2,
                shadowColor: Config.theme,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  // side: const BorderSide(color: Config.theme),
                ),
                child: AnimatedContainer(
                  width: isAnimated ? width * 0.4 : 0,
                  height: isAnimated ? width * 0.4 : 0,
                  duration: const Duration(seconds: 1),
                  child: Center(
                    child: Image.asset(
                      "Assets/images/LogoIcon.png",
                      scale: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

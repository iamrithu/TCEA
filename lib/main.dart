import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/splashScreen/splashScreen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF97315)),
      //   useMaterial3: true,
      // ),
      home: SplashScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

  
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

 

//   @override
//   Widget build(BuildContext context) {
   
//     return SafeArea(
//       child: Scaffold(
        
//         body:   InAppWebView(
//            initialUrlRequest: URLRequest(url:Uri.parse("http://www.tcea.co.in/"))),
    
          
//        // This trailing comma makes auto-formatting nicer for build methods.
//       ),
//     );
//   }
// }

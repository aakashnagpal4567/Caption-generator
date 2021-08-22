import 'package:caption_generator/splashScreen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caption_generator',
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}



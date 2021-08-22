import 'package:caption_generator/homeScreen.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:splashscreen/splashscreen.dart";
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 8,
      navigateAfterSeconds: HomeScreen(),
      photoSize: 150,
      imageBackground: Image.asset("assets/ml.jpg").image,
    );
  }
}

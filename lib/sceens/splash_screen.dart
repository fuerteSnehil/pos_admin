import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_admin/sceens/adminDashboard.dart';
import 'package:pos_admin/appbar.dart';
import 'package:pos_admin/appname.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/inception.dart';
import 'package:pos_admin/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const KEYLOGIN = 'isLoggedIn';

  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () async {
      print('Testing Splash');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLogged = prefs.getBool('isLogged') ?? false;
      String myPhone = prefs.getString('myPhone') ?? '';

      if (isLogged) {
        // User is already logged in, navigate to HomeScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AdminDashboard(
              Uid: myPhone,
            ),
          ),
        );
      } else {
        // User is not logged in, navigate to LoginScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Inception(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      backgroundColor: white,
      appBar: const ZeroAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appName(),
          Lottie.asset(
            "$lottiePath/splashScreenAnimation.json",
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            width: Screen(context).width * 0.9,
            frameRate: FrameRate(90),
          ),
          SizedBox(
            height: 80 * s.customWidth,
          ),
          Column(
            children: [
              Image.asset("$imagesPath/bbblogo.png", height: 50),
              const Text(
                "Streamlining Success, One Bill at a Time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

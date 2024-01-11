import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_admin/sceens/adminDashboard.dart';
import 'package:pos_admin/appbar.dart';
import 'package:pos_admin/appname.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/inception.dart';
import 'package:pos_admin/sceens/mainadmindashboard.dart';
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

    Timer(Duration(seconds: 2), () async {
      print('Testing Splash');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLogged = prefs.getBool('isLogged') ?? false;
      String myPhone = prefs.getString('myPhone') ?? '';

      print("myphone number is$myPhone");

      if (isLogged) {
        try {
          await FirebaseFirestore.instance
              .collection('MainAdmin')
              .doc(myPhone)
              .get()
              .then((value) {
            if (value.exists) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MainAdminDashboard(),
                ),
                (route) => false,
              );
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => AdminDashboard(
                    Uid: myPhone,
                  ),
                ),
                (route) => false,
              );
            }
          });
        } catch (e) {
          print(e);
        }
      } else {
        // ignore: use_build_context_synchronously
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Screen s = Screen(context);
    return Scaffold(
        backgroundColor: white,
        appBar: const ZeroAppBar(),
        body: MediaQuery.of(context).size.width < 600
            ? Column(
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
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color(0XFFac3749),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [
                      0.1,
                      0.3,
                      0.6,
                      0.9,
                    ],
                    colors: [
                      Color.fromARGB(255, 227, 81, 103),
                      Color.fromARGB(255, 151, 45, 61),
                      Color.fromARGB(255, 113, 17, 31),
                      Color.fromARGB(255, 55, 8, 15),
                    ],
                  ),
                  // image: DecorationImage(
                  //     image: NetworkImage(
                  //         'https://www.pngmart.com/files/22/World-Map-High-Resolution-Flag-PNG-Isolated-HD.png'))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: 500,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Pos Admin Pannel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 29)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 41),
                                child: Text(
                                    "Its basically designed for bigger restaurant management system for the ease of managers,owners as well as employees for better judgement of system and the better environment for customers for their best experience with shopping with us....",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13)),
                              ),
                              Container(
                                height: 40,
                                width: 130,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    color: Colors.white),
                                child: const Center(
                                  child: Text("Read More",
                                      style: TextStyle(
                                          color: Color(0XFFac3749),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ));
  }
}

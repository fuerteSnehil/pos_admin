import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_admin/backend/auth/phone_authentication.dart';
import 'package:pos_admin/backend/provider/login_provider.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/inception_component.dart';
import 'package:pos_admin/sceens/inception.dart';
import 'package:pos_admin/navigation.dart';
import 'package:pos_admin/screen.dart';
import 'package:pos_admin/text_styles.dart';
import 'package:pos_admin/webScreen.dart';
import 'package:pos_admin/widgets/snack_bar.dart';

import 'package:provider/provider.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  late Navigation nav;

  @override
  void initState() {
    nav = Navigation(context);
    super.initState();
  }

  goBack() {
    if (mounted) {
      nav.pushAndRemoveUntil(const Inception());
      Provider.of<LoginProvider>(context, listen: false).reset();
    }
  }

  MyTextStyle ts = MyTextStyle();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Screen s = Screen(context);
    WebScreen w = WebScreen(context);
    return Scaffold(
      backgroundColor: white,
      appBar: width < 600
          ? AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: white,
              iconTheme: const IconThemeData(color: black),
              leading: IconButton(
                onPressed: () => goBack(),
                icon: Icon(MdiIcons.arrowLeft),
              ),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: white,
                statusBarIconBrightness: Brightness.dark,
              ),
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Consumer<LoginProvider>(
            builder: (context, lp, _) => Padding(
              padding: EdgeInsets.all(20 * s.customWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verify OTP",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12 * s.customWidth),
                  Text(
                    "We have sent the verification code to your mobile number",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          height: 1.25,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10 * s.customWidth),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lp.phone,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        GestureDetector(
                          onTap: () => goBack(),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10 * s.customWidth),
                            child: Icon(
                              MdiIcons.pencilCircle,
                              color: black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10 * s.customWidth),
                  Row(
                    children: [
                      otpBox(
                        lp.controllers[0],
                        focusNode: lp.firstFocusNode,
                      ),
                      otpBox(lp.controllers[1]),
                      otpBox(lp.controllers[2]),
                      otpBox(lp.controllers[3]),
                      otpBox(lp.controllers[4]),
                      otpBox(
                        lp.controllers[5],
                        isLast: true,
                        focusNode: lp.lastFocusNode,
                      ),
                    ],
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      for (TextEditingController controller in lp.controllers) {
                        controller.clear();
                      }
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(lp.firstFocusNode);
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Clear",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: black),
                      ),
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    isLoading: lp.isProcessing,
                    label: "Verify OTP",
                    // backgroundColor: theme,
                    backgroundColor: black,
                    borderRadius: 10,
                    onTap: () async {
                      String result = await PhoneAuthentication(
                        context: context,
                        mounted: mounted,
                        lp: lp,
                      ).verifyPhoneOTP();

                      if (mounted) {
                        CustomSnackBar(context).build(result);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Consumer<LoginProvider>(
            builder: (context, lp, _) => Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
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
                  Color.fromARGB(255, 15, 59, 94),
                  Color.fromARGB(255, 18, 102, 171),
                  Color.fromARGB(255, 146, 195, 235),
                  Color.fromARGB(255, 82, 150, 206),
                ],
              )),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: height / 1.3,
                      width: width / 1.1,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.8), //New
                              blurRadius: 3.0,
                              spreadRadius: 1)
                        ],
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: height / 1.3,
                            width: width / 2.4,
                            color: Colors.white,
                            child: ListView(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, top: 20),
                                      child: Container(
                                        height: 110,
                                        width: 200,
                                        //color: Colors.blue,
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    'https://99designs-blog.imgix.net/blog/wp-content/uploads/2016/09/intel-logo-600x600.jpg?auto=format&q=60&fit=max&w=930'))),
                                        // child: Image.asset(
                                        //   'assets/vendor.jpg',
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 11,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'OTP',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 10 * w.customWebWidth),
                                    Row(
                                      children: [
                                        otpBox(
                                          lp.controllers[0],
                                          focusNode: lp.firstFocusNode,
                                        ),
                                        otpBox(lp.controllers[1]),
                                        otpBox(lp.controllers[2]),
                                        otpBox(lp.controllers[3]),
                                        otpBox(lp.controllers[4]),
                                        otpBox(
                                          lp.controllers[5],
                                          isLast: true,
                                          focusNode: lp.lastFocusNode,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        for (TextEditingController controller
                                            in lp.controllers) {
                                          controller.clear();
                                        }
                                        FocusScope.of(context).unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(lp.firstFocusNode);
                                      },
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.all(20),
                                        child: Text(
                                          "Clear",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(color: black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: width < 1000
                                      ? const EdgeInsets.only(left: 20, top: 30)
                                      : const EdgeInsets.only(
                                          left: 50, top: 30),
                                  child: Row(
                                    children: [
                                      Text(
                                        "can't login?",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      width < 1100
                                          ? const SizedBox(
                                              width: 70,
                                            )
                                          : const SizedBox(
                                              width: 106,
                                            ),
                                      MaterialButton(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        elevation: 5.0,
                                        minWidth: 120,
                                        height: 45,
                                        hoverColor: Colors.blue,
                                        color: const Color.fromARGB(
                                            255, 15, 59, 94),
                                        child: const Text('Login',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15.0,
                                                color: Colors.white)),
                                        onPressed: () async {
                                          String result =
                                              await PhoneAuthentication(
                                            context: context,
                                            mounted: mounted,
                                            lp: lp,
                                          ).verifyPhoneOTP();

                                          if (mounted) {
                                            CustomSnackBar(context)
                                                .build(result);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: SizedBox(
                                    width: 270,
                                    child: Text(
                                      'If you are not register than yoy are not admin,stay away from this pannel',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                height: height / 1.3,
                                width: width / 2.2,
                                //color: Colors.orange.withOpacity(0.7),
                                decoration: const BoxDecoration(
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
                                    Color.fromARGB(255, 146, 195, 235),
                                    Color.fromARGB(255, 82, 150, 206),
                                    Color.fromARGB(255, 18, 102, 171),
                                    Color.fromARGB(255, 15, 59, 94)
                                  ],
                                )),
                                child: Padding(
                                  padding: width < 1300
                                      ? const EdgeInsets.only(left: 40)
                                      : const EdgeInsets.only(left: 100),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        //mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Welcome to ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            'Pos Admin Pannel',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Login to acess your admin pannel',
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -70,
                                top: -70,
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 2, 39, 69),
                                      borderRadius: BorderRadius.circular(100)),
                                ),
                              ),
                              Positioned(
                                left: -100,
                                bottom: -100,
                                child: Container(
                                  height: 300,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 13, 77, 130),
                                      borderRadius: BorderRadius.circular(150)),
                                ),
                              ),
                              Positioned(
                                right: width < 1300 ? 100 : 150,
                                bottom: width < 1300 ? 120 : 150,
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 2, 39, 69),
                                      borderRadius: BorderRadius.circular(60)),
                                ),
                              ),
                              Positioned(
                                left: -40,
                                top: 60,
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 13, 77, 130),
                                      borderRadius: BorderRadius.circular(60)),
                                ),
                              ),
                              Positioned(
                                right: -100,
                                bottom: -100,
                                child: Container(
                                  height: 220,
                                  width: 220,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 2, 39, 69),
                                      borderRadius: BorderRadius.circular(100)),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  //  return Expanded(
  //           child: Container(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //               color: webColor,
  //               height: double.infinity,
  //               width: MediaQuery.of(context).size.width / 2.7,
  //               child: Lottie.asset(
  //                 "$lottiePath/loginWeb.json",
  //                 fit: BoxFit.fitWidth,
  //                 alignment: Alignment.center,
  //                 width: Screen(context).width * 0.9,
  //                 frameRate: FrameRate(90),
  //               ),
  //             ),
  //             Expanded(
  //               child: Consumer<LoginProvider>(
  //                 builder: (context, lp, _) => Padding(
  //                   padding: EdgeInsets.all(20 * w.customWebWidth),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Verify OTP",
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .headlineLarge!
  //                             .copyWith(
  //                                 color: black, fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(height: 12 * w.customWebWidth),
  //                       Text(
  //                         "We have sent the verification code to your mobile number",
  //                         style:
  //                             Theme.of(context).textTheme.titleLarge!.copyWith(
  //                                   height: 1.25,
  //                                 ),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(
  //                             vertical: 10 * w.customWebWidth),
  //                         child: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Text(
  //                               lp.phone,
  //                               style: Theme.of(context).textTheme.titleMedium,
  //                             ),
  //                             GestureDetector(
  //                               onTap: () => goBack(),
  //                               child: Padding(
  //                                 padding: EdgeInsets.only(
  //                                     left: 10 * w.customWebWidth),
  //                                 child: Icon(
  //                                   MdiIcons.pencilCircle,
  //                                   color: black,
  //                                 ),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                       SizedBox(height: 10 * w.customWebWidth),
  //                       Row(
  //                         children: [
  //                           otpBox(
  //                             lp.controllers[0],
  //                             focusNode: lp.firstFocusNode,
  //                           ),
  //                           otpBox(lp.controllers[1]),
  //                           otpBox(lp.controllers[2]),
  //                           otpBox(lp.controllers[3]),
  //                           otpBox(lp.controllers[4]),
  //                           otpBox(
  //                             lp.controllers[5],
  //                             isLast: true,
  //                             focusNode: lp.lastFocusNode,
  //                           ),
  //                         ],
  //                       ),
  //                       GestureDetector(
  //                         behavior: HitTestBehavior.opaque,
  //                         onTap: () {
  //                           for (TextEditingController controller
  //                               in lp.controllers) {
  //                             controller.clear();
  //                           }
  //                           FocusScope.of(context).unfocus();
  //                           FocusScope.of(context)
  //                               .requestFocus(lp.firstFocusNode);
  //                         },
  //                         child: Container(
  //                           alignment: Alignment.centerRight,
  //                           padding: const EdgeInsets.all(20),
  //                           child: Text(
  //                             "Clear",
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .titleSmall!
  //                                 .copyWith(color: black),
  //                           ),
  //                         ),
  //                       ),
  //               const Spacer(),
  //               CustomWebButton(
  //                 isLoading: lp.isProcessing,
  //                 label: "Verify OTP",
  //                 // backgroundColor: theme,
  //                 backgroundColor: black,
  //                 borderRadius: 10,
  //                 onTap: () async {
  //                   String result = await PhoneAuthentication(
  //                     context: context,
  //                     mounted: mounted,
  //                     lp: lp,
  //                   ).verifyPhoneOTP();

  //                   if (mounted) {
  //                     CustomSnackBar(context).build(result);
  //                   }
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     )
  //   ],
  // ),
  //       ));

  Expanded otpBox(
    TextEditingController controller, {
    bool? isLast,
    FocusNode? focusNode,
  }) {
    Screen s = Screen(context);
    return Expanded(
      child: TextField(
        focusNode: focusNode,
        autofocus: true,
        autofillHints: const [
          AutofillHints.oneTimeCode,
        ],
        style: Theme.of(context).textTheme.headlineSmall,
        controller: controller,
        cursorColor: black,
        onChanged: (value) {
          if (value.isNotEmpty) {
            controller.text = value[value.length - 1];
            if (!(isLast ?? false)) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          }
        },
        onTap: () {
          controller.clear();
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          // LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10 * s.customWidth),
          border: border(),
          enabledBorder: border(),
          focusedBorder: border(color: black),
        ),
      ),
    );
  }

  OutlineInputBorder border({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: color ?? grey,
        width: color == null ? 1 : 2,
      ),
    );
  }
}

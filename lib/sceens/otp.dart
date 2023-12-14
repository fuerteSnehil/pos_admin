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
    Screen s = Screen(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
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
      ),
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
          return Expanded(
              child: Container(
            color: white,
            child: Row(
              children: [
                Container(
                  color: webColor,
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width / 2.7,
                  child: Lottie.asset(
                    "$lottiePath/loginWeb.json",
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center,
                    width: Screen(context).width * 0.9,
                    frameRate: FrameRate(90),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const BeOnTimeAnimatedText(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 8,
                            ),
                            Text(
                              "Verify OTP",
                              style: TextStyle(
                                  fontFamily: 'tabfont', fontSize: 20),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 50,
                            ),
                            Text(
                              'We have sent the verification code to your mobile number',
                              style: TextStyle(fontFamily: 'fontmain'),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4,
                              child: TextField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: black,
                                    fontWeight: FontWeight.bold),
                                cursorColor: webColor,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.message),
                                  hintText: 'Enter OTP',
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.w400),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide:
                                        const BorderSide(color: Colors.black38),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide:
                                        const BorderSide(color: webColor),
                                  ),
                                  focusColor: webColor,
                                  hoverColor: webColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 20,
                            ),
                            Consumer<LoginProvider>(
                              builder: (context, value, _) => SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                height: MediaQuery.of(context).size.height / 13,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: webColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Verify OTP',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: black,
                                            fontFamily: 'tabfont'),
                                      ),
                                      Icon(
                                        MdiIcons.send,
                                        color: black,
                                      )
                                    ],
                                  ),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OTP()));
                                    // if (phone.text.length == 10) {
                                    //   if (!(await permissions.checkSms())) {
                                    //     await permissions.requestSms();
                                    //   }
                                    //   value.setPhone = "+91${phone.text}";
                                    //   if (mounted) {
                                    //     String result =
                                    //         await PhoneAuthentication(
                                    //       context: context,
                                    //       mounted: mounted,
                                    //       lp: value,
                                    //     ).sendPhoneOtp();
                                    //     if (mounted) {
                                    //       CustomSnackBar(context)
                                    //           .build(result);
                                    //     }
                                    //   }
                                    //   Future.delayed(
                                    //     const Duration(milliseconds: 1000),
                                    //     () => nav.push(const OTP()),
                                    //   );
                                    // } else {
                                    //   CustomSnackBar(context).build(
                                    //     "Incomplete phone number.",
                                    //   );
                                    // }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
        }
      }),
    );
  }

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

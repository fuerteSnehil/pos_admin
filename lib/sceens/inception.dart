import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_admin/appbar.dart';
import 'package:pos_admin/backend/auth/phone_authentication.dart';
import 'package:pos_admin/backend/permission.dart';
import 'package:pos_admin/backend/provider/login_provider.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/constants/strings.dart';
import 'package:pos_admin/inception_component.dart';
import 'package:pos_admin/sceens/otp.dart';
import 'package:pos_admin/navigation.dart';
import 'package:pos_admin/screen.dart';
import 'package:pos_admin/textformfields.dart';
import 'package:pos_admin/webScreen.dart';
import 'package:pos_admin/widgets/snack_bar.dart';
import 'package:pos_admin/widgets/textFieldWeb.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Inception extends StatefulWidget {
  const Inception({super.key});

  @override
  State<Inception> createState() => _InceptionState();
}

class _InceptionState extends State<Inception> {
  TextEditingController phone = TextEditingController();
  TextEditingController otp = TextEditingController();
  late Navigation nav;
  Permissions permissions = Permissions();

  @override
  void initState() {
    nav = Navigation(context);
    super.initState();
  }

  Future<bool> willPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    WebScreen w = WebScreen(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    print(width);
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: white,
        appBar: ZeroAppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            // statusBarColor: theme,
            statusBarColor: Colors.blueGrey.shade300,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Stack(
              children: [
                Shape(s),
                SizedBox.expand(
                  child: Padding(
                    padding: EdgeInsets.all(40 * s.customWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const BeOnTimeAnimatedText(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 30 * s.customWidth),
                          child: phoneField(s),
                        ),
                        Consumer<LoginProvider>(
                          builder: (context, value, _) => CustomButton(
                            label: "Send OTP",
                            isLoading: value.isProcessing,
                            onTap: () async {
                              print('SEND OTP TAPPED ${phone}');
                              if (phone.text.length == 10) {
                                if (!(await permissions.checkSms())) {
                                  await permissions.requestSms();
                                }
                                value.setPhone = "+91${phone.text}";
                                if (mounted) {
                                  String result = await PhoneAuthentication(
                                    context: context,
                                    mounted: mounted,
                                    lp: value,
                                  ).sendPhoneOtp();
                                  if (mounted) {
                                    CustomSnackBar(context).build(result);
                                  }
                                }
                                Future.delayed(
                                  const Duration(milliseconds: 1000),
                                  () => nav.push(const OTP()),
                                );
                              } else {
                                CustomSnackBar(context).build(
                                  "Incomplete phone number.",
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 25 * s.customWidth,
                            bottom: 30 * s.customWidth,
                          ),
                          child: termsAndConditions(s),
                        ),
                        // or(s),
                        // SocialIcon(
                        //   "assets/icons/googleLogo.png",
                        //   onTap: () async {
                        //     String response = await GoogleAuthentication(
                        //       context,
                        //       mounted,
                        //     ).signInViaGoogle();
                        //     if (response.isNotEmpty && mounted) {
                        //       CustomSnackBar(context).build(response);
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            );
          } else {
            return Container(
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
                  mainAxisAlignment: width < 900
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    width < 900
                        ? const SizedBox(
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: width < 1100 ? 300 : 500,
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 41),
                                      child: Text(
                                          "Its basically designed for bigger restaurant management system for the ease of managers,owners as well as employees for better judgement of system and the better environment for customers for their best experience with shopping with us....",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13)),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 130,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(26),
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
                          ),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        width: 500,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            color: Colors.white),
                        child: ListView(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 21,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color(0XFFac3749)),
                                  child: const Center(
                                      child: Image(
                                    image: AssetImage(
                                      'assets/images/rocket.png',
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(41.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Welcome",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 21)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 310,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 0.4,
                                            blurRadius: 0.4)
                                      ],
                                      borderRadius: BorderRadius.circular(21)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 21),
                                        child: SizedBox(
                                          width: 160,
                                          child: TextField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            controller: phone,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Phone Number",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        ),
                                      ),
                                      Consumer<LoginProvider>(
                                        builder: (context, value, _) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 11),
                                          child: InkWell(
                                            onTap: () async {
                                              print('SEND OTP TAPPED ${phone}');
                                              if (phone.text.length == 10) {
                                                value.setPhone =
                                                    "+91${phone.text}";
                                                if (mounted) {
                                                  String result =
                                                      await PhoneAuthentication(
                                                    context: context,
                                                    mounted: mounted,
                                                    lp: value,
                                                  ).sendPhoneOtp();
                                                  if (mounted) {
                                                    CustomSnackBar(context)
                                                        .build(result);
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             OTP()));
                                                  }
                                                }
                                              } else {
                                                CustomSnackBar(context).build(
                                                  "Incomplete phone number.",
                                                );
                                              }
                                            },
                                            child: Container(
                                              height: 36,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(26),
                                                  color:
                                                      const Color(0XFFac3749)),
                                              child: const Center(
                                                child: Text("Get OTP",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Consumer<LoginProvider>(
                              builder: (context, lp, _) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 31),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              ),
                            ),
                           SizedBox(height: 25,),
                            Consumer<LoginProvider>(
                              builder: (context, lp, _) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
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
                                    child: Container(
                                      height: 40,
                                      width: 180,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(26),
                                          color: const Color(0XFFac3749)),
                                      child: const Center(
                                        child: Text("Verify OTP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                             const SizedBox(
                              height: 21,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't get OTP? Resend Code",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                              ],
                            ),
                            const SizedBox(
                              height: 11,
                            )
                          ],
                        ))
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget otpBox(
    TextEditingController controller, {
    bool? isLast,
    FocusNode? focusNode,
  }) {
    //Screen s = Screen(context);
    return Padding(
      padding: const EdgeInsets.only(right: 5.5),
      child: Container(
        height: 60,
        width: 45,
        child: TextField(
          focusNode: focusNode,
          //autofocus: true,
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
            //contentPadding: EdgeInsets.all(10 * s.customWidth),
            border: border(),
            enabledBorder: border(),
            focusedBorder: border(color: black),
          ),
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

  Row or(Screen s) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            endIndent: 20 * s.customWidth,
            indent: 20 * s.customWidth,
          ),
        ),
        Text(
          'OR',
          style: TextStyle(
            color: theme,
            fontWeight: FontWeight.w900,
            fontSize: 16 * s.customWidth,
          ),
        ),
        Expanded(
          child: Divider(
            indent: 20 * s.customWidth,
            endIndent: 20 * s.customWidth,
          ),
        ),
      ],
    );
  }

  Padding termsAndConditions(Screen s) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30 * s.customWidth,
        vertical: 15 * s.customWidth,
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(height: 1.5),
          children: [
            TextSpan(
              text: "By continuing, you agree to the ",
              style: TextStyle(
                color: grey,
                fontSize: 13 * s.customWidth,
              ),
            ),
            TextSpan(
              text: "Terms & Conditions ",
              style: TextStyle(
                // color: theme,
                color: black,
                fontSize: 13 * s.customWidth,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrlString(
                      AppStrings.themePrivacyPolicy,
                    ),
            ),
            TextSpan(
              text: "and ",
              style: TextStyle(
                color: grey,
                fontSize: 13 * s.customWidth,
              ),
            ),
            TextSpan(
              text: "Privacy Policy ",
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrlString(
                      AppStrings.themePrivacyPolicy,
                    ),
              style: TextStyle(
                // color: theme,
                color: black,
                fontSize: 13 * s.customWidth,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: "of Invoice Pro.",
              style: TextStyle(
                color: grey,
                fontSize: 13 * s.customWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomTextFormField phoneField(Screen s) {
    return CustomTextFormField(
      controller: phone,
      hintText: "Enter your mobile number",
      prefixIcon: PrefixIcon91(s),
      autoFillHints: const [
        AutofillHints.telephoneNumberNational,
      ],
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
    );
  }

  CustomTextFormFieldWeb phoneFieldWeb(WebScreen w) {
    return CustomTextFormFieldWeb(
      controller: phone,
      hintText: "Enter your mobile number",
      prefixIcon: PrefixIconWeb(w),
      autoFillHints: const [
        AutofillHints.telephoneNumberNational,
      ],
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
    );
  }
}

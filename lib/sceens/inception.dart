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
import 'package:pos_admin/widgets/snack_bar.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Inception extends StatefulWidget {
  const Inception({super.key});

  @override
  State<Inception> createState() => _InceptionState();
}

class _InceptionState extends State<Inception> {
  TextEditingController phone = TextEditingController(),
      otp = TextEditingController();
  late Navigation nav;
  Permissions permissions = Permissions();

  @override
  void initState() {
    nav = Navigation(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 30 * s.customWidth),
                        child: phoneField(s),
                      ),
                      Consumer<LoginProvider>(
                        builder: (context, value, _) => CustomButton(
                          label: "Send OTP",
                          isLoading: value.isProcessing,
                          onTap: () async {
                            Text('Send OTP TAPPED ${phone}');
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
                              "Enter your Phone Number",
                              style: TextStyle(
                                  fontFamily: 'tabfont', fontSize: 20),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 50,
                            ),
                            Text(
                              'We will send you a 6 digit verification code',
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
                                controller: phone,
                                cursorColor: webColor,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  hintText: 'Enter Mobile No',
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
                                        'Send OTP',
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
                                    print('Testing Phone ${phone}');
                                    
                                    if (phone.text.length == 10) {
                                      if (!(await permissions.checkSms())) {
                                        await permissions.requestSms();
                                      }
                                      value.setPhone = "+91${phone.text}";
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
}

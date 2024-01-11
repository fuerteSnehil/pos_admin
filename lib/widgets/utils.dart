import 'package:flutter/material.dart';
import 'package:pos_admin/constants/colors.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
     // padding: EdgeInsets.all(12),
     duration: Duration(seconds: 2),
      content: Text(
        content,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0XFFac3749),
      showCloseIcon: true,
      closeIconColor: Colors.white,
    ),
  );
}
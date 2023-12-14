import 'package:flutter/material.dart';
import 'package:pos_admin/constants/colors.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: primaryColor,
      showCloseIcon: true,
      closeIconColor: Colors.white,
    ),
  );
}
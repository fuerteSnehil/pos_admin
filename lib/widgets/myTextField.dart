import 'package:flutter/material.dart';
import 'package:pos_admin/constants/colors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String cstmLable;
  final TextInputType keyboardType;

  MyTextField({
    required this.controller,
    required this.hintText,
    required this.cstmLable,
    this.keyboardType = TextInputType.text, // Make keyboardType optional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 8, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cstmLable,
            style: TextStyle(
                letterSpacing: 1.3,
                fontSize: 14,
                fontFamily: 'fontmain',
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 180,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 16,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              keyboardType: keyboardType,
              style: TextStyle(
                  fontSize: 17, letterSpacing: 1, fontWeight: FontWeight.w500),
              controller: controller,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w300, color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: dead_code

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_flutter_fi/const/colors.dart';


myStyle(double? size, Color? clr, [FontWeight? fw]) {
  return GoogleFonts.nunito(
    fontSize: size,
    color: clr,
    fontWeight: fw,
  );
}

showInToast(String title) {
  bool isDark = true;

  Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isDark?Colors.black:lightBackgroundColor,
      textColor: isDark?darkBtnTextColor:lightprimarybtnColor,
      fontSize: 16.0);
}

//Light theme

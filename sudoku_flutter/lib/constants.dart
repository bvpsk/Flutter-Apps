import 'package:flutter/material.dart';

const double kOuterBorderWidth = 1.5;
const double kOuterBorderRadius = 5.0;
const double kCustomButtonWidth = 1.3;

const bool darkTheme = true;

const Color kOuterBorderColor =
    darkTheme ? Color(0xFF30b843) : Color(0xFF8f9bb1);
const Color kBlockBorderColor =
    darkTheme ? Color(0xFF329842) : Color(0xFF7f8ca4);
const Color kCellBorderColor =
    darkTheme ? Color(0xFF2a5c40) : Color(0xFFcacfd5);
const Color kFunctionalButtonColor =
    darkTheme ? Color(0xaa8f9bb1) : Color(0xFFa3afc6);
const Color kDefaultCellBorderColor = darkTheme ? Colors.black : Colors.white;
const Color kBackGroundColor = darkTheme ? Color(0x10000000) : Colors.white;
const Color kBlockContainerColor =
    darkTheme ? Color(0x10f3f4f9) : Color(0xFFf3f4f9); //0xcc2b2b2b
const Color kCustomButtonColor =
    darkTheme ? Colors.yellowAccent : Color(0xFFcdd2d9);
const Color kErrorBoxColor = darkTheme ? Color(0xccffd2d3) : Color(0xFFffd2d3);
const Color kErrorTextColor = darkTheme ? Color(0xFFf14c4a) : Color(0xFFf14b4a);
const Color kHintTextColor = darkTheme ? Colors.blueAccent : Colors.greenAccent;
const Color kHintBoxColor = darkTheme ? Color(0xccfdff00) : Colors.yellowAccent;
const Color kTempTextColor = darkTheme ? Colors.greenAccent : Color(0xFF070068);
const Color kPlainTextColor =
    darkTheme ? Colors.blueAccent : Color(0xFFadb1b1); //0xFF6897bb
const Color kCustomButtonTextColor =
    darkTheme ? Color(0xFF4a9c55) : Color(0xFF060771);
const Color kCellBoxDecorationColor =
    darkTheme ? Colors.white70 : Color(0xFFe0e3f2);
const Color kIconColor = darkTheme ? Color(0xFFffc66d) : Color(0xFFffc66d);

const TextStyle kCustomButtonTextStyleClear =
    TextStyle(color: kIconColor, fontWeight: FontWeight.w400, fontSize: 25);
const TextStyle kCellTextStyle1 = TextStyle(
  color: kPlainTextColor,
  fontSize: 20,
  fontWeight: FontWeight.w500,
);

const TextStyle kCustomButtonTextStyle = TextStyle(
  color: kCustomButtonTextColor,
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

BoxDecoration kCellBoxDecoration1 = BoxDecoration(
  color: kCellBoxDecorationColor,
  borderRadius: BorderRadius.circular(3),
);

BoxDecoration kCellBoxDecoration2 = BoxDecoration(
  color: kBackGroundColor,
);

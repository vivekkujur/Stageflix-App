import 'package:flutter/material.dart';



Color primary = const Color(0xff2cf19e);



class AppStyles{

  static Color primaryColor = primary;
  static Color secondary = const Color(0xff112432);
  static Color tertiary = const Color(0xffFF7754);

  static Color gray = const Color(0xff83829A);
  static Color gray2 = const Color(0xffC1C0C8);
  static Color gray3 = const Color(0x60C1C0C8);

  static Color offwhite = const Color(0xffF3F4F8);
  static Color white = const Color(0xffFFFFFF);
  static Color black = const Color(0xff000000);
  static Color red = const Color(0xffe81e4d);
  static Color green = const Color(0xff00C135);
  static Color lightWhite = const Color(0xffFAFAFC);
  static Color backgroundBlack = const Color(0xff202122);
  static Color red_main = const Color(0xffe53935);


  static TextStyle headerTextStyle1=  TextStyle(
    color:secondary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static TextStyle textStyleGreyH3=  TextStyle(
    color:gray,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textStyleGreyH2=  TextStyle(
    color:gray,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
}
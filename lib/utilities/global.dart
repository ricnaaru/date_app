import 'dart:convert';

import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String loremIpsum =
    "You think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder. After the avalanche, it took us a week to climb out. Now, I don't know exactly when we turned on each other, but I know that seven of us survived the slide... and only five made it out. Now we took an oath, that I'm breaking now. We said we'd say it was the snow that killed the other two, but it wasn't. Nature is lethal but it doesn't hold a candle to man.";

class CompanyColors {
  const CompanyColors._();

  const CompanyColors(); // this basically makes it so you can instantiate this class

  static const int _accentPrimaryValue = 0xffC7FCFC;
  static const Map<int, Color> accentColorList = const <int, Color>{
    50: const Color(0xffFBFFFF),
    100: const Color(0xffEEFEFE),
    200: const Color(0xffE1FEFE),
    300: const Color(0xffD4FDFD),
    400: const Color(_accentPrimaryValue),
    500: const Color(0xffBDF2F2),
    600: const Color(0xffB3E8E8),
    700: const Color(0xffA9DDDD),
    800: const Color(0xff9FD3D3),
    900: const Color(0xff95C9C9)
  };
//  static const Map<int, Color> primaryColorList = const <int, Color>{
//    50: const Color(0xffFFE997),
//    100: const Color(0xffFDDD8B),
//    200: const Color(0xffFBD07F),
//    300: const Color(0xffF9C473),
//    400: const Color(_primaryPrimaryValue),
//    500: const Color(0xffECAD5E),
//    600: const Color(0xffE1A455),
//    700: const Color(0xffD79A4B),
//    800: const Color(0xffCC9142),
//    900: const Color(0xffC18739)
//  };

  static const int _primaryPrimaryValue = 0xff4CAF50;
  static const Map<int, Color> primaryColorList = const <int, Color>{
    50: const Color(0xff92DB90),
    100: const Color(0xff81D080),
    200: const Color(0xff6FC570),
    300: const Color(0xff5EBA60),
    400: const Color(_primaryPrimaryValue),
    500: const Color(0xff3EA547),
    600: const Color(0xff319C3E),
    700: const Color(0xff239235),
    800: const Color(0xff16892C),
    900: const Color(0xff087F23)
  };
//  static const Map<int, Color> accentColorList = const <int, Color>{
//    50: const Color(0xffFFFFEA),
//    100: const Color(0xffFEFFDD),
//    200: const Color(0xffFDFFD1),
//    300: const Color(0xffFCFFC4),
//    400: const Color(_accentPrimaryValue),
//    500: const Color(0xffF1F5AD),
//    600: const Color(0xffE6EBA4),
//    700: const Color(0xffDCE09A),
//    800: const Color(0xffD1D691),
//    900: const Color(0xffC7CC87)
//  };

  static const MaterialColor primary = MaterialColor(
    _primaryPrimaryValue,
    primaryColorList,
  );

  static const MaterialColor accent = MaterialColor(
    _accentPrimaryValue,
    accentColorList,
  );
}

//Colors
Color systemPrimaryColor = CompanyColors.primary[500];
Color systemAccentColor = CompanyColors.accent[500];
Color systemPrimaryTextColor = Color(0xff232323);
Color systemSecondaryTextColor = Color(0xff545454);

const Color systemRedColor = Color(0xffE54A52);
const Color systemBlueColor = Color(0xff98dbf5);
const Color systemYellowColor = Color(0xfff3f7a6);
const Color systemGreenColor = Color(0xffa6eab0);
const Color systemGreyColor = Color(0xffcbccce);
const Color systemDarkerGreyColor = Color(0xffA3A4A5);
const Color systemDarkestGreyColor = Color(0xff7B7C7C);

//Shared Preference Values
String tokenRefresher = "token_refresher";
String accessToken = "access_token";
String userId = "user_id";
String name = "name";
String email = "email";
String appImage = "app_image";
String phoneNumber = "phone_number";
String locale = "locale";
String settingOptions1 = 'setting1';
String settingOptions2 = 'setting2';
String settingOptions3 = 'setting3';
String typePhone = 'Phone';
String typeMaps = 'Maps';
String typeEmail = 'Email';
bool pushNotificationSettingDefault = true;
bool marketingSettingDefault = true;
bool emailSmsSettingDefault = true;
String localeDefault = "en";
String dot = '\u2022';

//Global Functions
void showSnackBar(BuildContext context, String message, {int displayTime}) {
  displayTime ??= 5000;

  final snackBar = SnackBar(
    content: new Text(message),
    duration: new Duration(milliseconds: displayTime),
    action: SnackBarAction(
      label: 'Close',
      onPressed: () {},
    ),
  );

  try {
    Scaffold.of(context).showSnackBar(snackBar);
  } catch (e) {
    print("showSnackBar error ${e}");
  }
}

String dateFormat(date) {
//  DateTime dateTime = DateTime.parse(date);
  var formatter = DateFormat('dd MMM yyyy');
  String formatted = formatter.format(date);
  return formatted;
}

String dateFormatRange(DateTime start, DateTime end){
  var formatter = DateFormat('MMM dd yyyy');
  String dateStart = formatter.format(start);
  String dateEnd = formatter.format(end);

  return '$dateStart - $dateEnd';
}

//Future<FirebaseApp> get firebaseApp async {
//  return FirebaseApp.configure(
//    name: 'MobilePetrol',
//    options: Platform.isIOS
//        ? const FirebaseOptions(
//      googleAppID: '1:1034683950153:ios:919a03cd7c384111',
//      gcmSenderID: '1034683950153',
//      databaseURL: 'https://mobilepetrol-6eefc.firebaseio.com',
//    )
//        : const FirebaseOptions(
//      googleAppID: '1:1034683950153:android:8027226b6e8841b3',
//      apiKey: 'AIzaSyCxIdvAkGg-VBGxPE_iwK4B94X1Fo4Im_Q',
//      databaseURL: 'hhttps://mobilepetrol-6eefc.firebaseio.com',
//    ),
//  );
//}
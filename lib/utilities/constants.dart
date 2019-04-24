import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// etc..

DateFormat kServerDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

/// SharedPreferences Key

const String kLocaleDefault = "en";

/// Theme

class CompanyColors {
  const CompanyColors._();

  const CompanyColors(); // this basically makes it so you can instantiate this class

  static const int _accentPrimaryValue = 0xff6abf78;
  static const Map<int, Color> accentColorList = const <int, Color>{
    50: const Color(0xffe9f6eb),
    100: const Color(0xffc9e8ce),
    200: const Color(0xffa7d9af),
    300: const Color(0xff84cb90),
    400: const Color(_accentPrimaryValue),
    500: const Color(0xff51b461),
    600: const Color(0xff48a557),
    700: const Color(0xff3e924c),
    800: const Color(0xff358142),
    900: const Color(0xff24622e)
  };

  static const int _primaryPrimaryValue = 0xff4d5c96;
  static const Map<int, Color> primaryColorList = const <int, Color>{
    50: const Color(0xffe9ebf2),
    100: const Color(0xffc7cddf),
    200: const Color(0xffa4adca),
    300: const Color(0xff818db3),
    400: const Color(0xff6674a4),
    500: const Color(_primaryPrimaryValue),
    600: const Color(0xff47548d),
    700: const Color(0xff3e4a81),
    800: const Color(0xff374074),
    900: const Color(0xff2c305c)
  };

  static const MaterialColor primary = MaterialColor(
    _primaryPrimaryValue,
    primaryColorList,
  );

  static const MaterialColor accent = MaterialColor(
    _accentPrimaryValue,
    accentColorList,
  );
}

const Color systemPrimaryTextColor = Color(0xff232323);
const Color systemSecondaryTextColor = Color(0xff545454);
const Color systemRedColor = Color(0xffE54A52);
const Color systemHyperlinkColor = Color(0xff0645AD);
const Color systemBlueColor = Color(0xff98dbf5);
const Color systemYellowColor = Color(0xfff3f7a6);
const Color systemGreenColor = Color(0xffa6eab0);
const Color systemLightGreyColor = Color(0xfffafafa);
const Color systemGreyColor = Color(0xffcbccce);
const Color systemDarkerGreyColor = Color(0xffA3A4A5);
const Color systemDarkestGreyColor = Color(0xff7B7C7C);
const Color systemPurpleColor = Color(0xff4600d3);
const Color systemOrangeColor = Color(0xffc18400);
const Color systemTealColor = Color(0xff009373);

const double kCardImageHeight = 194.0;

const TextStyle kHyperlinkStyle = TextStyle(color: Colors.blue);
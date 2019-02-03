import 'dart:convert';

import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_text.dart';

final RegExp emojiRegex = RegExp(
    r"(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|[\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|[\ud83c[\ude32-\ude3a]|[\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])");

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
    Scaffold.of(context).hideCurrentSnackBar();
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

String dateFormatRange(DateTime start, DateTime end) {
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

Widget handleEmoji(String input, {TextStyle style}) {
  style ??= TextStyle(color: Colors.black, fontSize: 14.0);

  int lastEmojiIndex = 0;
  int emojiIndex = input.indexOf(emojiRegex);
  List<TextSpan> textSpans = [];

  while (emojiIndex >= 0) {
    textSpans.add(TextSpan(text: input.substring(lastEmojiIndex, emojiIndex), style: style));

    String emojis = "";

    for (int i = emojiIndex; i < input.length; i++) {
      String currentLetter = input.substring(i, i + 1);

      //check for surrogates emoji
      if (RegExp(r"[\ud800-\udbff]|[\udc00-\udfff]").hasMatch(currentLetter)) {
        String currentLetter2 = i == input.length - 1 ? "" : input.substring(i + 1, i + 2);
        if (RegExp(r"[\ud800-\udbff]|[\udc00-\udfff]").hasMatch(currentLetter2)) {
          emojis = "$emojis$currentLetter$currentLetter2";
          i++;
        }
      } else {
        if (!emojiRegex.hasMatch(currentLetter)) {
          lastEmojiIndex = i;
          emojiIndex = i;
          break;
        } else {
          emojis = "$emojis${input.substring(i, i + 1)}";
        }
      }
    }

    textSpans.add(TextSpan(text: emojis, style: style.copyWith(fontSize: style.fontSize * 0.85)));

    emojiIndex = input.indexOf(emojiRegex, emojiIndex);
  }

  textSpans.add(TextSpan(text: input.substring(lastEmojiIndex, input.length), style: style));

  return Text.rich(TextSpan(children: textSpans), overflow: TextOverflow.ellipsis, maxLines: 3,);
}

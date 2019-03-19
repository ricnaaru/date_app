import 'dart:io';
import 'dart:ui';

import 'package:date_app/components/adv_dialog_input.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_group_check.dart';

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

Future<FirebaseApp> get firebaseApp async {
  return await FirebaseApp.appNamed('DateApp') == null ? FirebaseApp.configure(
    name: 'DateApp',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:476982417788:ios:45ba40082a5a8ae7',
      gcmSenderID: '476982417788',
      databaseURL: 'https://dateapp-6ebae.firebaseio.com',
    )
        : const FirebaseOptions(
      googleAppID: '1:476982417788:android:31a46ee0feaf156f',
      apiKey: 'AIzaSyAQ_njDcO4OgTkQtkd4i6qxFmL3Jg1FRDE',
      databaseURL: 'https://dateapp-6ebae.firebaseio.com',
    ),
  ) : FirebaseApp.appNamed('DateApp');
}

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

  return Text.rich(
    TextSpan(children: textSpans),
    overflow: TextOverflow.ellipsis,
    maxLines: 3,
  );
}

dynamic pickFromDialogChooser(BuildContext context,
    {String title = "", List<GroupCheckItem> items, String currentItem = ""}) async {
  assert(items != null);
  DateDict dict = DateDict.of(context);

  AdvGroupCheckController controller = AdvGroupCheckController(checkedValue: currentItem, itemList: items);

  var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AdvDialogInput(
          title: title,
          content: Container(
            child: AdvGroupCheck(
              controller: controller,
              callback: (newValue) async {
                await Future.delayed(Duration(milliseconds: 100));
                Navigator.pop(context, newValue);
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(dict.getString("cancel")),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      });

  return result;
}

//List<Member> members = [
//  Member(
//      id: "M-00001",
//      name: "Michelle Deborah Lusikooy",
//      email: "michelitha@yahoo.com",
//      phone: "0812 1958 7577",
//      birthday: DateTime(1984, 2, 16),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_kak_michelle.jpg?alt=media&token=7a4ce3cd-216c-4980-acd8-8189ae534ebb"),
//  Member(
//      id: "M-00002",
//      name: "Aseng Pasaribu",
//      email: "asengsupriyadi@gmail.com",
//      phone: "0812 6339 1389",
//      birthday: DateTime(1993, 12, 4),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_aseng.jpg?alt=media&token=21db9ffb-40b8-447d-8aff-652fad11c462"),
//  Member(
//      id: "M-00003",
//      name: "Bonita Delores",
//      email: "bonitadelores@gmail.com",
//      phone: "0819 0510 8760",
//      birthday: DateTime(1995, 4, 24),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_bonita.jpg?alt=media&token=d9b1640f-6b50-4e21-bcdb-73b5aae0419e"),
//  Member(
//      id: "M-00004",
//      name: "Charles Yeremia Far-Far",
//      email: "cyfarfar@gmail.com",
//      phone: "0878 5242 9559",
//      birthday: DateTime(1992, 9, 2),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_yere.jpg?alt=media&token=806705c4-2059-4c85-afc3-f7e730cfa2a4"),
//  Member(
//      id: "M-00005",
//      name: "Christiany Simamora",
//      email: "christinesimamora24@gmail.com",
//      phone: "0877 7662 1656",
//      birthday: DateTime(1994, 7, 24),
//      photo: "https://www.masikids.com/public/img/not_found.png"),
//  Member(
//      id: "M-00006",
//      name: "Felly Meilinda",
//      email: "pliawdesign@gmail.com",
//      phone: "0852 2299 4629",
//      birthday: DateTime(1987, 5, 29),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_cikgu.jpg?alt=media&token=69dfd51e-f92d-4e07-a962-e0d4e22f9dab"),
//  Member(
//      id: "M-00007",
//      name: "Flora Katharina Hutabarat",
//      email: "ninamj78@gmail.com",
//      phone: "0811 188 8914",
//      birthday: DateTime(1978, 2, 27),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_kak_nina.jpg?alt=media&token=8995254b-1640-4dbd-a11d-6e6d3fe85ac2"),
//  Member(
//      id: "M-00008",
//      name: "Franscisco Manullang",
//      email: "sisco7053ph@yahoo.com",
//      phone: "0812 841 8182",
//      birthday: DateTime(1976, 7, 7),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_bang_sisco.jpg?alt=media&token=e774b6e9-b5d2-479e-9ce1-de07b6ac05da"),
//  Member(
//      id: "M-00009",
//      name: "Ida Merlin Purba",
//      email: "idamerlinmerlin@gmail.com",
//      phone: "0852 0790 4350",
//      birthday: DateTime(1994, 5, 15),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_ida.jpg?alt=media&token=863bef67-47c3-4d5f-acfc-68976bf21615"),
//  Member(
//      id: "M-00010",
//      name: "Julita Rosalia Legi",
//      email: "julitalegi@gmail.com",
//      phone: "0853 9886 1265",
//      birthday: DateTime(1993, 7, 5),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_julita.jpg?alt=media&token=a0383a5a-e147-42fb-8ae6-973cdde9e53a"),
//  Member(
//      id: "M-00011",
//      name: "Mayyanti",
//      email: "mayyanti@gmail.com",
//      phone: "0877 8507 2334",
//      birthday: DateTime(1990, 5, 3),
//      photo: "https://www.masikids.com/public/img/not_found.png"),
//  Member(
//      id: "M-00012",
//      name: "Mika Putri",
//      email: "mikaputribudiono@gmail.com",
//      phone: "0858 8124 2020",
//      birthday: DateTime(1992, 9, 21),
//      photo: "https://www.masikids.com/public/img/not_found.png"),
//  Member(
//      id: "M-00013",
//      name: "Nico Hasugian",
//      email: "nicoalexhasugian@yahoo.co.id",
//      phone: "0852 6106 2008",
//      birthday: DateTime(1992, 2, 27),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_nico.jpg?alt=media&token=c893e7fb-e4cd-46a8-93e7-ac49ea295752"),
//  Member(
//      id: "M-00014",
//      name: "Proctor Tayu",
//      email: "proctor.tayu@gmail.com",
//      phone: "0812 700 0753",
//      birthday: DateTime(1987, 10, 25),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_tor.jpg?alt=media&token=5c698999-e51f-4806-bca4-2aca28e45a46"),
//  Member(
//      id: "M-00015",
//      name: "Richardo Gio Vanni Thayeb",
//      email: "richardothayeb@gmail.com",
//      phone: "0878 7871 4718",
//      birthday: DateTime(1991, 6, 6),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_ric.jpg?alt=media&token=45650d64-a54a-47aa-a8ce-38f5a57f230d"),
//  Member(
//      id: "M-00016",
//      name: "Roy Martino",
//      email: "roy_edan86@yahoo.com",
//      phone: "0821 4057 3886",
//      birthday: DateTime(1986, 3, 11),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_roy.jpg?alt=media&token=e9866431-d714-489e-b2d5-9ed36f99c4d3"),
//  Member(
//      id: "M-00017",
//      name: "Stevvani",
//      email: "stevani170989@gmail.com",
//      phone: "0818 0815 2680",
//      birthday: DateTime(1989, 9, 17),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_vani.jpg?alt=media&token=acab3dfc-0c69-4a80-a078-4d087352399d"),
//  Member(
//      id: "M-00018",
//      name: "Yohana Meilina",
//      email: "yohanna.meilina@gmail.com",
//      phone: "0812 9402 6842",
//      birthday: DateTime(1985, 5, 5),
//      photo:
//      "https://firebasestorage.googleapis.com/v0/b/dateapp-6ebae.appspot.com/o/profile_pic_yohana.jpg?alt=media&token=31f5b813-fe03-4c65-a3a4-ec5127984ade"),
//];

enum ServePosition {
  dateMember,
  dateCoreTeam,
  dateLeader,
  dateFacilitator,
}

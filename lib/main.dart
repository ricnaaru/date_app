import 'package:date_app/application.dart';
import 'package:date_app/pages/home.dart';
import 'package:date_app/pages/home_container.dart';
import 'package:date_app/pages/login.dart';
import 'package:date_app/utilities/assets.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/pref_keys.dart' as prefKeys;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pit_components/components/adv_future_builder.dart';
import 'package:pit_components/pit_components.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(NemobApp());

class ComponentsConfig {
  static Color sequenceLineColor = systemYellowColor;
  static Color sequenceInitialColor = systemBlueColor;
  static Color sequenceFilledColor = systemHyperlinkColor;
  static double sequenceTitleContentRatio = 0.3;
  static double sequenceBoxSize = 40.0;
  static double sequenceDividerWidth = 16.0;
}

class NemobApp extends StatefulWidget {
  @override
  _NemobAppState createState() => new _NemobAppState();
}

class _NemobAppState extends State<NemobApp> {
  Locale _locale = Locale("en");
  Widget _widget = Container();
  SharedPreferences prefs;
  bool changingLanguage = false;

  @override
  void initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;

//    NotificationHelper.init(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage fired! => $message");
//        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//            'your channel id', 'your channel name', 'your channel description',
//            importance: Importance.Max, priority: Priority.High);
//        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//        var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//        await FlutterLocalNotificationsPlugin()
//            .show(0, 'plain title', 'plain body', platformChannelSpecifics, payload: 'item id 2');
//      },
//      onLaunch: (Map<String, dynamic> message) {
//        print("onLaunch fired! => $message");
//      },
//      onResume: (Map<String, dynamic> message) {
//        print("onResume fired! => $message");
//      },
//      onTokenRefresh: (String token) {
//        print("onTokenRefresh fired! => $token");
//      },
//    );

//    NotificationHelper.getToken();
//    NotificationHelper.getToken();
  }

  @override
  Widget build(BuildContext context) {
    if (changingLanguage) {
      setState(() {
        changingLanguage = false;
      });
    }

    return AdvFutureBuilder(
      futureExecutor: getPrefs,
      widgetBuilder: (BuildContext context) {
        if (prefs != null) {
          final String localeString = (prefs.getString(prefKeys.kLocale) ?? "en");
          final String userId = (prefs.getString(prefKeys.kUserId) ?? "");
          print("userId => $userId");
          _locale = Locale(localeString);
          _widget = userId.isEmpty ? LoginPage() : HomeContainerPage(); //RegisterPage();

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              DateLocalizationsDelegate(overriddenLocale: _locale),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', 'US'), // English
              const Locale('id', 'ID'), // Hebrew
            ],
            theme: new ThemeData(
                brightness: Brightness.light,
                primarySwatch: CompanyColors.primary,
                primaryColor: CompanyColors.primary[500],
                primaryColorBrightness: Brightness.dark,
                accentColor: CompanyColors.accent[500],
                accentColorBrightness: Brightness.light,
                scaffoldBackgroundColor: Color.lerp(CompanyColors.accent[50], Colors.white, 0.8)),
            home: _widget,
          );
        } else {
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }

  Future<bool> getPrefs(BuildContext context) async {
    prefs ??= await SharedPreferences.getInstance();
    PitComponents.buttonBackgroundColor = CompanyColors.primary[500];
    PitComponents.buttonTextColor = Colors.white;
    PitComponents.textFieldBackgroundColor = CompanyColors.accent[50];
    PitComponents.textFieldBorderColor = CompanyColors.primary[500];
    PitComponents.datePickerBackgroundColor = CompanyColors.accent[50];
    PitComponents.datePickerBorderColor = CompanyColors.primary[500];
    PitComponents.chooserBackgroundColor = CompanyColors.accent[50];
    PitComponents.chooserBorderColor = CompanyColors.primary[500];
    PitComponents.datePickerToolbarColor = CompanyColors.primary;
    PitComponents.datePickerHeaderColor = CompanyColors.primary;
    PitComponents.datePickerSelectedColor = CompanyColors.primary;
    PitComponents.datePickerTodayColor = systemGreenColor;
    PitComponents.groupCheckCheckColor = CompanyColors.primary;
    PitComponents.radioButtonColor = CompanyColors.primary;
    PitComponents.loadingAssetName = Assets.hLoading;
    PitComponents.editableMargin = EdgeInsets.all(0.0);

    await precacheImage(AssetImage(Assets.logoBlack), context);

    return true;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
}

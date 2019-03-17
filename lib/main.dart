import 'package:date_app/application.dart';
import 'package:date_app/pages/home_container.dart';
import 'package:date_app/utilities/assets.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/notification_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pit_components/components/adv_future_builder.dart';
import 'package:pit_components/pit_components.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(new NemobApp());

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

    NotificationHelper.init(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage fired! => $message");
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.Max, priority: Priority.High);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await FlutterLocalNotificationsPlugin()
            .show(0, 'plain title', 'plain body', platformChannelSpecifics, payload: 'item id 2');
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch fired! => $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume fired! => $message");
      },
      onTokenRefresh: (String token) {
        print("onTokenRefresh fired! => $token");
      },
    );

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
          final String localeString = (prefs.getString(global.locale) ?? "id");
          _locale = Locale(localeString);
          _widget = DateAppHome();

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
                primarySwatch: global.CompanyColors.primary,
                primaryColor: global.CompanyColors.primary[500],
                primaryColorBrightness: Brightness.light,
                accentColor: global.CompanyColors.accent[500],
                accentColorBrightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white),
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
    PitComponents.buttonBackgroundColor = global.CompanyColors.primary[500];
    PitComponents.buttonTextColor = Colors.white;
    PitComponents.textFieldBackgroundColor = global.CompanyColors.accent[50];
    PitComponents.textFieldBorderColor = global.CompanyColors.primary[500];
    PitComponents.datePickerBackgroundColor = global.CompanyColors.accent[50];
    PitComponents.datePickerBorderColor = global.CompanyColors.primary[500];
    PitComponents.chooserBackgroundColor = global.CompanyColors.accent[50];
    PitComponents.chooserBorderColor = global.CompanyColors.primary[500];
    PitComponents.datePickerToolbarColor = global.systemPrimaryColor;
    PitComponents.datePickerHeaderColor = global.systemPrimaryColor;
    PitComponents.datePickerSelectedColor = global.systemPrimaryColor;
    PitComponents.datePickerTodayColor = global.systemGreenColor;
    PitComponents.groupCheckCheckColor = global.systemPrimaryColor;
    PitComponents.radioButtonColor = global.systemPrimaryColor;
    PitComponents.loadingAssetName = Assets.hLoading;
    return true;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
}

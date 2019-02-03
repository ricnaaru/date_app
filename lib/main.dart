import 'package:date_app/application.dart';
import 'package:date_app/pages/home_container.dart';
import 'package:date_app/pages/register.dart';
import 'package:date_app/utilities/assets.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:date_app/utilities/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pit_components/pit_components.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(DateApp());

class DateApp extends StatefulWidget {
  @override
  _DateAppState createState() => new _DateAppState();
}

class _DateAppState extends State<DateApp> {
  Locale _locale = Locale("en");
  Widget _widget = Container();
  SharedPreferences prefs;

  getPrefs() async {
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

    return prefs;
  }

  @override
  void initState() {
    super.initState();
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPrefs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              prefs = snapshot.data;
              final String localeString =
                  (prefs.getString(global.locale) ?? "en");
              _locale = Locale(localeString);
              _widget = DateAppHome();//RegisterPage();
            }

            return MaterialApp(
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
                  accentColorBrightness: Brightness.light),
              home: _widget,
            );
          default:
            return MaterialApp(
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
                  accentColorBrightness: Brightness.light),
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
        }
      },
    );
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
}

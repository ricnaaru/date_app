import 'dart:ui';

import 'package:date_app/presenters/home_container.dart';
import 'package:flutter/material.dart';

class Application {
  static final Application _application = Application._internal();
  HomeInterface homeInterface;

  factory Application() {
    return _application;
  }

  Application._internal();

  final Map<String, String> supportedLanguagesMap = {
    "en": "English",
    "id": "Bahasa"
  };

  final List<String> supportedLanguages = [
    "English",
    "Bahasa",
  ];

  final List<String> supportedLanguagesCodes = [
    "en",
    "id",
  ];

  //returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  //function to be invoked when changing the language
  LocaleChangeCallback onLocaleChanged;
}

Application application = Application();

typedef void LocaleChangeCallback(Locale locale);

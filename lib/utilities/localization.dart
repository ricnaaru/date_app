import 'dart:async';

import 'package:date_app/application.dart';
import 'package:date_app/components/adv_dialog.dart';
import 'package:date_app/utilities/string_helper.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';

class DateDict {
  DateDict({Locale locale}) : this.locale = locale ?? const Locale("en");

  final Locale locale;

  static DateDict of(BuildContext context) {
    return Localizations.of<DateDict>(context, DateDict);
  }

  static Map<String, Map<String, Map<String, String>>> _localizedMaps = {
    "id": {
      "marital_status": {
        'none': '-',
        'in_a_relationship': 'Pacaran',
        'married': 'Menikah',
        'single': 'Lajang'
      },
    },
    "en": {
      "marital_status": {
        'none': '-',
        'in_a_relationship': 'In a Relationship',
        'married': 'Married',
        'single': 'Single'
      },
    }
  };

//  'verify_code' => 'Kode Verifikasi'
//  -- untuk normal
//  'verify_code_info' => 'Pesan mengenai kode konfirmasi akan dikirimkan ke ponsel anda.'
//  -- untuk medium size info
//  'verify_code_label' => 'Kode Verifikasi : '
//  -- untuk label dengan :
//  'verify_code_msg' => 'Verifikasi kode bertujuan untuk menverifikasi nomor handphone yang anda masukkan, sehingga kami tahu bahwa itu adalah nomor anda pribadi. Caranya tinggal klik 'Verifikasi', dan kami akan mengirimkan kode ke Handphone anda dalam bentuk SMS, lalu masukkan kode tersebut ke dalam sistem'
//  -- untuk yang agak panjang infonya
//  'verify_code_title' => 'Konfirmasi nomor telepon'
//  -- untuk title page, usahakan pakai verify_code dulu (yang polos)
//  'err_verify_code_(terserah)' => 'Konfirmasi nomor telepon salah!'
//  -- untuk error, terserahnya bisa diisi huruf (empty / length) atau 1 2 3 jg gpp

  static Map<String, Map<String, String>> _localizedValues = {
    'id': {
      'account': "Akun",
      'account_information': "Informasi Akun",
      'additional_information': "Informasi Tambahan",
      'address': "Alamat",
      'alarm_set': "Alarm telah dibuat",
      'alarm_set_info': "Alarm dibuat pada",
      'back': "Kembali",
      'baptism_church': "Gereja Baptis",
      'baptism_date': "Tanggal Baptis",
      'cancel': "Batal",
      'church_information': "Informasi Gereja",
      'class_history': "Riwayat Kelas",
      'community': "Komunitas",
      'company': "Perusahaan",
      'company_address': "Alamat Perusahaan",
      'computing_vote_info': "Tenang sembari kami mengkalkulasi Voting ini",
      'congratulation': "Selamat!",
      'continue': "Lanjutkan",
      'date_of_birth': "Tanggal Lahir",
      'day': "hari",
      'days': "hari",
      'email': "Email",
      'employee': "Karyawan",
      'entrepreneur': "Wirausaha",
      'err_no_option_selected':
          "Mohon tentukan pilihan anda dari beberapa pilihan ini",
      'event': "Acara",
      'have_a_nice_day': "Semoga harimu menyenangkan!",
      'home': "Beranda",
      'hour': "jam",
      'hours': "jam",
      'id': "ID",
      'i_have_been_baptized': "Saya telah dibaptis",
      'job_description': "Deskripsi Pekerjaan",
      'join_jpcc_since': "Bergabung dengan JPCC sejak",
      'major': "Jurusan",
      'marital_status': "Status",
      'minute': "menit",
      'minutes': "menit",
      'name': "Nama",
      'next': "Berikut",
      'notification': "Notifikasi",
      'office_address': "Alamat Kantor",
      'password': "Password",
      'personal_information': "Informasi Pribadi",
      'phone_number': "No Telp",
      'registration_success':
          "Kamu telah terdaftar di sistem kami\nSiap menelusuri DATE App?!",
      'remind_me': "Remind me!",
      'second': "detik",
      'seconds': "detik",
      'semester': "Semester",
      'shop_address': "Alamat Toko",
      'shop_description': "Deskripsi Toko",
      'shop_name': "Nama Toko",
      'student': "Mahasiswa",
      'submit': "Selesai",
      'take_the_vote': "Ikuti Vote ini",
      'thank_you_vote_submitted': "Terima kasih, pilihanmu telah tersimpan!",
      'university': "Universitas",
      'username': "Username",
      'voting': "Voting",
      'working_since': "Bekerja sejak",
    },
    'en': {
      'account': "Account",
      'account_information': "Account Information",
      'additional_information': "Additional Information",
      'address': "Address",
      'alarm_set': "Alarm Set",
      'alarm_set_info': "Alarm set at",
      'back': "Back",
      'baptism_church': "Baptism Church",
      'baptism_date': "Baptism Date",
      'cancel': "Cancel",
      'church_information': "Church Information",
      'class_history': "Class History",
      'community': "Community",
      'company': "Company",
      'company_address': "Company Address",
      'computing_vote_info': "Chill, while we are computing your votes",
      'congratulation': "Congratulation!",
      'continue': "Continue",
      'date_of_birth': "Birthday",
      'day': "day",
      'days': "days",
      'email': "Email",
      'employee': "Employee",
      'entrepreneur': "Entrepreneur",
      'err_no_option_selected': "Please pick one of these options",
      'event': "Event",
      'have_a_nice_day': "Have a nice day!",
      'home': "Home",
      'hour': "hour",
      'hours': "hours",
      'id': "ID",
      'i_have_been_baptized': "I have been baptized",
      'job_description': "Job Description",
      'join_jpcc_since': "Join JPCC since",
      'major': "Major",
      'marital_status': "Status",
      'minute': "minute",
      'minutes': "minutes",
      'name': "Name",
      'next': "Next",
      'notification': "Notification",
      'office_address': "Office Address",
      'password': "Password",
      'personal_information': "Personal Information",
      'phone_number': "Phone Number",
      'registration_success':
          "You have been registered to our system\nNow you're good to go!",
      'remind_me': "Remind me!",
      'second': "second",
      'seconds': "seconds",
      'semester': "Semester",
      'shop_address': "Shop Address",
      'shop_description': "Shop Description",
      'shop_name': "Shop Name",
      'student': "Student",
      'submit': "Submit",
      'take_the_vote': "Take the Vote",
      'thank_you_vote_submitted': "Thank you, your vote has been submitted!",
      'university': "University",
      'username': "Username",
      'voting': "Voting",
      'working_since': "Working Since",
    },
  };

  String getString(String value) {
    Map<String, String> localizedValue =
        _localizedValues[locale.languageCode] ?? _localizedValues["en"];

    return localizedValue[value] ??
        _localizedValues["en"][value] ??
        "Raw $value";
  }

  Map<String, String> getMap(String value) {
    Map<String, Map<String, String>> localizedMaps =
        _localizedMaps[locale.languageCode] ?? _localizedMaps["en"];

    return localizedMaps[value] ?? {"raw_$value": "Raw $value"};
  }

  DateFormat getDateFormat(String format) {
    return DateFormat(format, locale.languageCode ?? "en");
  }

  NumberFormat getNumberFormat(String format) {
    return NumberFormat(format, locale.languageCode ?? "en");
  }

  String durationToString(Duration duration) {
    int day = duration.inDays.abs();
    int hour = (duration.inHours.abs() % 24);
    int minute = (duration.inMinutes.abs() % 60);
    int second = (duration.inSeconds.abs() % 60);
    String dayString = day == 0
        ? ""
        : "$day ${day.abs() == 1 ? this.getString("day") : this.getString("days")}";
    String hourString = hour == 0
        ? ""
        : "$hour ${hour.abs() == 1 ? this.getString("hour") : this.getString("hours")}";
    String minuteString = minute == 0
        ? ""
        : "$minute ${minute.abs() == 1 ? this.getString("minute") : this.getString("minutes")}";
    String secondString = "$second ${second.abs() == 1 ? this.getString("second") : this.getString("seconds")}";
    String result = "";

    result = secondString == ""
        ? result
        : result == ""
            ? minuteString == "" && hourString == "" && dayString == ""
                ? "$secondString"
                : "and $secondString"
            : "$result $secondString";
    result = minuteString == ""
        ? result
        : result == ""
            ? hourString == "" && dayString == ""
                ? "$minuteString"
                : "and $minuteString"
            : "$minuteString $result";
    result = hourString == ""
        ? result
        : result == ""
            ? dayString == "" ? "$hourString" : "and $hourString"
            : "$hourString $result";
    result = dayString == ""
        ? result
        : result == "" ? "and $dayString" : "$dayString $result";

    return (duration.isNegative ? "-$result" : result);
  }
}

class DateLocalizationsDelegate extends LocalizationsDelegate<DateDict> {
  final Locale overriddenLocale;

  const DateLocalizationsDelegate({this.overriddenLocale});

  @override
  bool isSupported(Locale locale) =>
      application.supportedLanguagesCodes.contains(locale.languageCode);

  @override
  Future<DateDict> load(Locale locale) {
    return SynchronousFuture<DateDict>(
        DateDict(locale: this.overriddenLocale ?? locale));
  }

  @override
  bool shouldReload(DateLocalizationsDelegate old) => true;
}


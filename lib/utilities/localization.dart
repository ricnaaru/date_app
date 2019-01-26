import 'dart:async';

import 'package:date_app/application.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

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
    'en': {
      'account_information': "Informasi Akun",
      'additional_information': "Informasi Tambahan",
      'address': "Alamat",
      'baptism_church': "Gereja Baptis",
      'baptism_date': "Tanggal Baptis",
      'church_information': "Informasi Gereja",
      'class_history': "Riwayat Kelas",
      'company': "Perusahaan",
      'company_address': "Alamat Perusahaan",
      'date_of_birth': "Tanggal Lahir",
      'email': "Email",
      'employee': "Karyawan",
      'entrepreneur': "Wirausaha",
      'id': "ID",
      'i_have_been_baptized': "Saya telah dibaptis",
      'job_description': "Deskripsi Pekerjaan",
      'join_jpcc_since': "Bergabung dengan JPCC sejak",
      'major': "Jurusan",
      'marital_status': "Status",
      'name': "Nama",
      'next': "Berikut",
      'office_address': "Alamat Kantor",
      'password': "Password",
      'personal_information': "Informasi Pribadi",
      'phone_number': "No Telp",
      'semester': "Semester",
      'shop_address': "Alamat Toko",
      'shop_description': "Deskripsi Toko",
      'shop_name': "Nama Toko",
      'student': "Mahasiswa",
      'university': "Universitas",
      'username': "Username",
      'working_since': "Bekerja sejak",
    },
    'id': {
      'account_information': "Account Information",
      'additional_information': "Additional Information",
      'address': "Address",
      'baptism_church': "Baptism Church",
      'baptism_date': "Baptism Date",
      'church_information': "Church Information",
      'class_history': "Class History",
      'company': "Company",
      'company_address': "Company Address",
      'date_of_birth': "Birthday",
      'email': "Email",
      'employee': "Employee",
      'entrepreneur': "Entrepreneur",
      'id': "ID",
      'i_have_been_baptized': "I have been baptized",
      'job_description': "Job Description",
      'join_jpcc_since': "Join JPCC since",
      'major': "Major",
      'marital_status': "Status",
      'name': "Name",
      'next': "Next",
      'office_address': "Office Address",
      'password': "Password",
      'personal_information': "Personal Information",
      'phone_number': "Phone Number",
      'semester': "Semester",
      'shop_address': "Shop Address",
      'shop_description': "Shop Description",
      'shop_name': "Shop Name",
      'student': "Student",
      'university': "University",
      'username': "Username",
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

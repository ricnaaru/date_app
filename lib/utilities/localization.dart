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
      "interval_type": {
        'once': 'Sekali',
        'daily': 'Harian',
        'weekly': 'Mingguan',
        'monthly': 'Bulanan',
        'annual': 'Tahunan',
        'custom': 'Custom'
      },
      "check_availability": {
        'never': 'Tidak Pernah',
        'every_round': 'Setiap Putaran',
        'once': 'Sekali (Sebelum generate)',
        'daily': 'Harian',
        'weekly': 'Mingguan',
        'monthly': 'Bulanan',
        'annual': 'Tahunan',
      },
    },
    "en": {
      "marital_status": {
        'none': '-',
        'in_a_relationship': 'In a Relationship',
        'married': 'Married',
        'single': 'Single'
      },
      "interval_type": {
        'once': 'Once',
        'daily': 'Daily',
        'weekly': 'Weekly',
        'monthly': 'Monthly',
        'annual': 'Annual',
        'custom': 'Custom'
      },
      "check_availability": {
        'never': 'Never',
        'every_round': 'Every Round',
        'once': 'Once (Before generate)',
        'daily': 'Daily',
        'weekly': 'Weekly',
        'monthly': 'Monthly',
        'annual': 'Annual',
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
      'add_event': "Tambah Acara",
      'add_participants': "Tambah Peserta",
      'add_position': "Tambah Posisi",
      'alarm_set': "Alarm telah dibuat",
      'alarm_set_info': "Alarm dibuat pada",
      'all_participants': "Semua Peserta",
      'and_more': "dan lebih",
      'ascension': "Kenaikan Isa Almasih",
      'as_ordered': "Sesuai Urutan",
      'back': "Kembali",
      'baptism_church': "Gereja Baptis",
      'baptism_date': "Tanggal Baptis",
      'birthday': "Ulang Tahun",
      'cancel': "Batal",
      'category': "Kategori",
      'check_all': "Pilih Semua",
      'check_availability': "Cek Ketersediaan",
      'chinese_new_year': "Tahun Baru Imlek",
      'christmas': "Hari Natal",
      'church_information': "Informasi Gereja",
      'class_history': "Riwayat Kelas",
      'community': "Komunitas",
      'company': "Perusahaan",
      'company_address': "Alamat Perusahaan",
      'computing_vote_info': "Tenang sembari kami mengkalkulasi Voting ini",
      'congratulation': "Selamat!",
      'continue': "Lanjutkan",
      'date_member': "Anggota DATE",
      'date_of_birth': "Tanggal Lahir",
      'day': "hari",
      'days': "hari",
      'days_interval': "Interval hari",
      'description': "Deskripsi",
      'eid_alfitr': "Hari Raya Idul Fitri",
      'eid_aladha': "Hari Raya Idul Adha",
      'email': "Email",
      'employee': "Karyawan",
      'entrepreneur': "Wirausaha",
      'err_no_option_selected':
          "Mohon tentukan pilihan anda dari beberapa pilihan ini",
      'err_no_participant': "Mohon pilih peserta terlebih dahulu",
      'event': "Acara",
      'event_detail': "Detil Acara",
      'from': "Dari",
      'generate': "Generate",
      'generate_participant_schedule_method': "Metode generate jadwal peserta",
      'good_friday': "Jumat Agung",
      'group': "Grup",
      'have_a_nice_day': "Semoga harimu menyenangkan!",
      'holiday': "Liburan",
      'home': "Beranda",
      'hour': "jam",
      'hours': "jam",
      'id': "ID",
      'independence_day': "Hari Kemerdekaan Republik Indonesia",
      'input_description': "Tulis deskripsi",
      'input_name': "Tulis nama",
      'interval_type': "Tipe interval",
      'islamic_new_year': "Tahun Baru Hijriyah",
      'isra_miraj': "Isra Mi'raj",
      'i_have_been_baptized': "Saya telah dibaptis",
      'job_description': "Deskripsi Pekerjaan",
      'join_jpcc_since': "Bergabung dengan JPCC sejak",
      'labor_day': "Hari Buruh",
      'major': "Jurusan",
      'marital_status': "Status",
      'mawlid': "Maulid Nabi Muhammad SAW",
      'minute': "menit",
      'minutes': "menit",
      'name': "Nama",
      'new_year': "Tahun Baru",
      'next': "Berikut",
      'nyepi': "Hari Raya Nyepi",
      'notification': "Notifikasi",
      'no_event': "Tidak ada acara",
      'office_address': "Alamat Kantor",
      'open_discussion': "Mulai Diskusi",
      'pancasila': "Hari Lahir Pancasila",
      'participant': "Peserta",
      'participants': "Peserta",
      'password': "Password",
      'personal': "Personal",
      'personal_information': "Informasi Pribadi",
      'phone_number': "No Telp",
      'position': "Posisi",
      'position_qualification_setting': "Pengaturan Kualifikasi Posisi",
      'registration_success':
          "Kamu telah terdaftar di sistem kami\nSiap menelusuri DATE App?!",
      'remind_me': "Remind me!",
      'reorder_info':
          "Ketuk dan tahan kemudian drag dan drop item untuk mengurutkan ulang",
      's_birthday': "Ulang tahun {name}",
      'second': "detik",
      'seconds': "detik",
      'semester': "Semester",
      'shop_address': "Alamat Toko",
      'shop_description': "Deskripsi Toko",
      'shop_name': "Nama Toko",
      'show_age': "Tampilkan umum saya ke publik",
      'shuffle': "Acak",
      'sort_a_z': "Urutkan dari A ke Z",
      'sort_z_a': "Urutkan dari Z ke A",
      'student': "Mahasiswa",
      'submit': "Selesai",
      'take_the_vote': "Ikuti Vote ini",
      'thank_you_vote_submitted': "Terima kasih, pilihanmu telah tersimpan!",
      'time_hint': "hh:mm AM/PM",
      'to': "sampai",
      'uncheck_all': "Hapus Semua Pilihan",
      'university': "Universitas",
      'until_date': "Sampai Tanggal",
      'username': "Username",
      'vesak': "Hari Raya Waisak",
      'voting': "Voting",
      'working_since': "Bekerja sejak",
    },
    'en': {
      'account': "Account",
      'account_information': "Account Information",
      'additional_information': "Additional Information",
      'address': "Address",
      'add_event': "Add Event",
      'add_participants': "Add Participants",
      'add_position': "Add Position",
      'alarm_set': "Alarm Set",
      'alarm_set_info': "Alarm set at",
      'all_participants': "All Participants",
      'and_more': "and more",
      'ascension': "Ascension Day",
      'as_ordered': "As Ordered",
      'back': "Back",
      'baptism_church': "Baptism Church",
      'baptism_date': "Baptism Date",
      'birthday': "Birthday",
      'cancel': "Cancel",
      'category': "Category",
      'check_all': "Check All",
      'check_availability': "Check Availability",
      'chinese_new_year': "Chinese New Year",
      'christmas': "Christmas Day",
      'church_information': "Church Information",
      'class_history': "Class History",
      'community': "Community",
      'company': "Company",
      'company_address': "Company Address",
      'computing_vote_info': "Chill, while we are computing your votes",
      'congratulation': "Congratulation!",
      'continue': "Continue",
      'date_member': "DATE Member",
      'date_of_birth': "Birthday",
      'day': "day",
      'days': "days",
      'days_interval': "Days interval",
      'description': "Description",
      'eid_alfitr': "Eid al-Fitr Holiday",
      'eid_aladha': "Eid al-Adha Holiday",
      'email': "Email",
      'employee': "Employee",
      'entrepreneur': "Entrepreneur",
      'err_no_option_selected': "Please pick one of these options",
      'err_no_participant': "Please select at least one participant first",
      'event': "Event",
      'event_detail': "Event Detail",
      'from': "From",
      'generate': "Generate",
      'generate_participant_schedule_method': "Generate participant schedule method",
      'good_friday': "Good Friday",
      'group': "Group",
      'have_a_nice_day': "Have a nice day!",
      'holiday': "Holiday",
      'home': "Home",
      'hour': "hour",
      'hours': "hours",
      'id': "ID",
      'independence_day': "Indonesia's Independence Day",
      'input_description': "Input description",
      'input_location': "Input location (Optional)",
      'input_name': "Input name",
      'interval_type': "Interval type",
      'islamic_new_year': "Islamic New Year",
      'isra_miraj': "Isra and Mi'raj",
      'i_have_been_baptized': "I have been baptized",
      'job_description': "Job Description",
      'join_jpcc_since': "Join JPCC since",
      'labor_day': "Labor Day",
      'major': "Major",
      'location': "Location",
      'marital_status': "Status",
      'mawlid': "Mawlid al-Nabi al-Sharif",
      'minute': "minute",
      'minutes': "minutes",
      'name': "Name",
      'new_year': "New Year",
      'next': "Next",
      'notification': "Notification",
      'no_event': "No Event",
      'nyepi': "Nyepi Holiday",
      'office_address': "Office Address",
      'open_discussion': "Open Discussion",
      'pancasila': "Pancasila Day",
      'participant': "Participant",
      'participants': "Participants",
      'password': "Password",
      'personal': "Personal",
      'personal_information': "Personal Information",
      'phone_number': "Phone Number",
      'position': "Position",
      'position_qualification_setting': "Position Qualification Setting",
      'registration_success':
          "You have been registered to our system\nNow you're good to go!",
      'remind_me': "Remind me!",
      'reorder_info': "Tap and hold then drag and drop item to reorder",
      'second': "second",
      'seconds': "seconds",
      'semester': "Semester",
      's_birthday': "{name}'s Birthday",
      'shop_address': "Shop Address",
      'shop_description': "Shop Description",
      'shop_name': "Shop Name",
      'show_age': "Show my age to public",
      'shuffle': "Shuffle",
      'sort_a_z': "Sort A to Z",
      'sort_z_a': "Sort Z to A",
      'student': "Student",
      'submit': "Submit",
      'take_the_vote': "Take the Vote",
      'thank_you_vote_submitted': "Thank you, your vote has been submitted!",
      'time_hint': "hh:mm AM/PM",
      'to': "to",
      'uncheck_all': "Uncheck All",
      'university': "University",
      'until_date': "Until Date",
      'username': "Username",
      'vesak': "Vesak Holiday",
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
    String secondString =
        "$second ${second.abs() == 1 ? this.getString("second") : this.getString("seconds")}";
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

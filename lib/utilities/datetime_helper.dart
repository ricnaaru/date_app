import 'package:intl/intl.dart';

const _kFirebaseFormat = "yyyy-MM-dd";

class DateTimeHelper {
  static DateTime convertFirebaseDate(int date) {
    if (date == null || date <= 0) return null;
    DateFormat dateFormatFirebase = DateFormat(_kFirebaseFormat);
    String dateRawString = "$date";
    String dateString = "${dateRawString.substring(0, 4)}-${dateRawString.substring(4, 6)}-${dateRawString.substring(6, 8)}";

    return dateFormatFirebase.parse(dateString);
  }
}

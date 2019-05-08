import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _kFirebaseDateFormat = "yyyy-MM-dd";
const _kFirebaseTimeFormat = "h:mm a";

class DateTimeHelper {
  static DateTime convertFromFirebaseDate(String dateString) {
    if (dateString == null) return null;
    DateFormat dateFormatFirebase = DateFormat(_kFirebaseDateFormat);

    return dateFormatFirebase.parse(dateString);
  }
  
  static String convertToFirebaseDate(DateTime date) {
    if (date == null) return null;
    DateFormat dateFormatFirebase = DateFormat(_kFirebaseDateFormat);

    return dateFormatFirebase.format(date);
  }
  
  static TimeOfDay convertFromFirebaseTime(String timeString) {
    if (timeString == null) return null;
    DateFormat timeFormatFirebase = DateFormat(_kFirebaseTimeFormat);

    return TimeOfDay.fromDateTime(timeFormatFirebase.parse(timeString));
  }

  static String convertToFirebaseTime(TimeOfDay time) {
    if (time == null) return null;

    int hour = (time.hour % 12);
    String hourString = hour == 0 ? "12" : hour.toString();
    String minute = time.minute.toString().padLeft(2, '0');
    String ampm = time.hour > 11 ? "PM" : "AM";

    return "$hourString:$minute $ampm";
  }
}

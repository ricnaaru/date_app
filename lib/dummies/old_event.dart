

import 'package:flutter/material.dart';

enum EventPeriod { once, daily, weekly, monthly, annual }
enum EventType { holiday, jpcc, date, birthday, group, personal }

class EventItem {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String venue;
  final EventPeriod eventPeriod;
  final EventType eventType;

  EventItem({this.name, this.startTime, this.endTime, this.venue, EventPeriod eventPeriod, EventType eventType})
      : this.eventPeriod = eventPeriod ?? EventPeriod.once,
        this.eventType = eventType ?? EventType.personal;

  EventItem.birthday({@required this.name, @required this.startTime})
      : this.endTime = null,
        this.venue = "",
        this.eventPeriod = EventPeriod.annual,
        this.eventType = EventType.birthday;

  EventItem.annualHoliday({@required this.name, @required this.startTime, this.endTime})
      : this.venue = "",
        this.eventPeriod = EventPeriod.annual,
        this.eventType = EventType.holiday;

  EventItem.holiday({@required this.name, @required this.startTime, this.endTime})
      : this.venue = "",
        this.eventPeriod = EventPeriod.once,
        this.eventType = EventType.holiday;

  bool matchDate(DateTime otherDate, {DateTime untilAnotherDate, bool alwaysEndOfMonth = true}) {
    assert(untilAnotherDate == null || (untilAnotherDate?.difference(otherDate)?.inDays ?? 0) >= 0);

    return this.endTime == null
        ? _matchSingleDate(otherDate, untilAnotherDate: untilAnotherDate, alwaysEndOfMonth: alwaysEndOfMonth)
        : _matchRangeDate(otherDate, untilAnotherDate: untilAnotherDate, alwaysEndOfMonth: alwaysEndOfMonth);
  }

  bool _matchSingleDate(DateTime otherDate, {DateTime untilAnotherDate, bool alwaysEndOfMonth = true}) {
    assert(untilAnotherDate == null || (untilAnotherDate?.difference(otherDate)?.inDays ?? 0) >= 0);

    /// harusnya ceknya dari daily dulu karena kalo ada yg daily sampe tgl >= tgl yg dicek, artinya ada event
    /// kedua dari once, kalo tanggalnya sama, brrt ada event
    /// ketiga dari monthly, kalo tanggalnya sama, berarti ada event
    /// keempat dari annual, kalo bulan dan tanggalnya sama, berarti ada event
    /// kelima dari weekly atau custom, karena harus ada kalkulasi dulu
    ///
    /// so the best thing is populate masing2 ke type period dulu, baru dimatch

    DateTime currentStart = clearTime(this.startTime);
    DateTime otherStart = otherDate = clearTime(otherDate);
    DateTime otherEnd = clearTime(untilAnotherDate ?? otherDate);

    if (otherStart.difference(currentStart).inDays < 0 && otherEnd.difference(currentStart).inDays < 0) return false;

    switch (this.eventPeriod) {
      case EventPeriod.once:
        return !(currentStart.difference(otherStart).inDays < 0) && !(currentStart.difference(otherEnd).inDays > 0);
      case EventPeriod.daily:
        return true;
      case EventPeriod.weekly:
        if (!(currentStart.difference(otherStart).inDays < 0) && !(currentStart.difference(otherEnd).inDays > 0)) return true;

        int diffFromStart = otherStart.difference(currentStart).inDays;

        DateTime nearestStart = currentStart.add(Duration(days: (diffFromStart / 7).floor() * 7));

        return !(nearestStart.difference(otherStart).inDays < 0) && !(nearestStart.difference(otherEnd).inDays > 0);

        break;
      case EventPeriod.monthly:
        DateTime nearestStart;
        int startLastDay = getLastDay(DateTime(otherStart.year, otherStart.month, 1));
        if (currentStart.day > startLastDay) {
          if (alwaysEndOfMonth) {
            nearestStart = DateTime(otherStart.year, otherStart.month, startLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestStart = DateTime(otherStart.year, otherStart.month, startLastDay + 1);
            }
          }
        } else {
          nearestStart = DateTime(otherStart.year, otherStart.month, (currentStart.day));
        }

        return !(nearestStart.difference(otherStart).inDays < 0) && !(nearestStart.difference(otherEnd).inDays > 0);
      case EventPeriod.annual:
        DateTime nearestStart;
        int startLastDay = getLastDay(DateTime(otherStart.year, currentStart.month, 1));
        if (currentStart.day > startLastDay) {
          if (alwaysEndOfMonth) {
            nearestStart = DateTime(otherStart.year, currentStart.month, startLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestStart = DateTime(otherStart.year, currentStart.month, startLastDay + 1);
            }
          }
        } else {
          nearestStart = DateTime(otherStart.year, currentStart.month, (currentStart.day));
        }

        return !(nearestStart.difference(otherStart).inDays < 0) && !(nearestStart.difference(otherEnd).inDays > 0);
    }

    return false;
  }

  bool _matchRangeDate(DateTime otherDate, {DateTime untilAnotherDate, bool alwaysEndOfMonth = true}) {
    assert(untilAnotherDate == null || (untilAnotherDate?.difference(otherDate)?.inDays ?? 0) >= 0);

    DateTime currentStart = clearTime(this.startTime);
    DateTime currentEnd = clearTime(this.endTime ?? this.startTime);
    DateTime otherStart = otherDate = clearTime(otherDate);
    DateTime otherEnd = clearTime(untilAnotherDate ?? otherDate);

    if (otherStart.difference(currentStart).inDays < 0 && otherEnd.difference(currentStart).inDays < 0) return false;

    switch (this.eventPeriod) {
      case EventPeriod.once:
        return !(currentStart.difference(otherStart).inDays < 0 && currentEnd.difference(otherEnd).inDays < 0) &&
            !(currentStart.difference(otherStart).inDays > 0 && currentEnd.difference(otherEnd).inDays > 0);
      case EventPeriod.daily:
        return true;
      case EventPeriod.weekly:
        if (!(currentStart.difference(otherStart).inDays < 0 && currentEnd.difference(otherEnd).inDays < 0) &&
            !(currentStart.difference(otherStart).inDays > 0 && currentEnd.difference(otherEnd).inDays > 0)) return true;

        int diffFromStart = otherStart.difference(currentStart).inDays;
        int currentLength = currentEnd.difference(currentStart).inDays;

        DateTime nearestStart = currentStart.add(Duration(days: (diffFromStart / 7).floor() * 7));
        DateTime nearestEnd = nearestStart.add(Duration(days: currentLength));

        return !(nearestStart.difference(otherStart).inDays < 0 && nearestEnd.difference(otherEnd).inDays < 0) &&
            !(nearestStart.difference(otherStart).inDays > 0 && nearestEnd.difference(otherEnd).inDays > 0);

        break;
      case EventPeriod.monthly:
        DateTime nearestStart;
        int startLastDay = getLastDay(DateTime(otherStart.year, otherStart.month, 1));
        if (currentStart.day > startLastDay) {
          if (alwaysEndOfMonth) {
            nearestStart = DateTime(otherStart.year, otherStart.month, startLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestStart = DateTime(otherStart.year, otherStart.month, startLastDay + 1);
            }
          }
        } else {
          nearestStart = DateTime(otherStart.year, otherStart.month, (currentStart.day));
        }
        DateTime nearestEnd;
        int endLastDay = getLastDay(DateTime(otherEnd.year, otherEnd.month, 1));
        if (currentEnd.day > endLastDay) {
          if (alwaysEndOfMonth) {
            nearestEnd = DateTime(otherEnd.year, otherEnd.month, endLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestEnd = DateTime(otherEnd.year, otherEnd.month, endLastDay + 1);
            }
          }
        } else {
          nearestEnd = DateTime(otherEnd.year, otherEnd.month, (currentEnd.day));
        }

        return !(nearestStart.difference(otherStart).inDays < 0 && nearestEnd.difference(otherEnd).inDays < 0) &&
            !(nearestStart.difference(otherStart).inDays > 0 && nearestEnd.difference(otherEnd).inDays > 0);
      case EventPeriod.annual:
        DateTime nearestStart;
        int startLastDay = getLastDay(DateTime(otherStart.year, currentStart.month, 1));
        if (currentStart.day > startLastDay) {
          if (alwaysEndOfMonth) {
            nearestStart = DateTime(otherStart.year, currentStart.month, startLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestStart = DateTime(otherStart.year, currentStart.month, startLastDay + 1);
            }
          }
        } else {
          nearestStart = DateTime(otherStart.year, currentStart.month, (currentStart.day));
        }
        DateTime nearestEnd;
        int endLastDay = getLastDay(DateTime(otherEnd.year, currentEnd.month, 1));
        if (currentEnd.day > endLastDay) {
          if (alwaysEndOfMonth) {
            nearestEnd = DateTime(otherEnd.year, currentEnd.month, endLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestEnd = DateTime(otherEnd.year, currentEnd.month, endLastDay + 1);
            }
          }
        } else {
          nearestEnd = DateTime(otherEnd.year, currentEnd.month, (currentEnd.day));
        }

        return !(nearestStart.difference(otherStart).inDays < 0 && nearestEnd.difference(otherEnd).inDays < 0) &&
            !(nearestStart.difference(otherStart).inDays > 0 && nearestEnd.difference(otherEnd).inDays > 0);
    }

    return false;
  }

  DateTime clearTime(DateTime source) {
    return DateTime(source.year, source.month, source.day);
  }

  int getLastDay(DateTime dateTime) {
    int lastDay = 0;

    if (dateTime.month == 1 ||
        dateTime.month == 3 ||
        dateTime.month == 5 ||
        dateTime.month == 7 ||
        dateTime.month == 8 ||
        dateTime.month == 10 ||
        dateTime.month == 12) {
      lastDay = 31;
    } else if (dateTime.month == 4 || dateTime.month == 6 || dateTime.month == 9 || dateTime.month == 11) {
      lastDay = 30;
    } else {
      if (dateTime.year % 4 == 0) {
        lastDay = 29;
      } else {
        lastDay = 28;
      }
    }
    return lastDay;
  }

  @override
  String toString() {
    return "EventItem($name)";
  }
}
import 'package:date_app/components/daily_calendar_carousel.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/pit_components.dart';

enum EventPeriod { once, daily, weekly, monthly, annual }
enum EventType { holiday, jpcc, date, birthday, group, personal }

class EventItem {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String venue;
  final EventPeriod eventPeriod;
  final EventType eventType;

  EventItem(
      {this.name,
      this.startTime,
      this.endTime,
      this.venue,
      EventPeriod eventPeriod,
      EventType eventType})
      : this.eventPeriod = eventPeriod ?? EventPeriod.once,
        this.eventType = eventType ?? EventType.personal;

  EventItem.birthday({@required this.name, @required this.startTime})
      : this.endTime = null,
        this.venue = "",
        this.eventPeriod = EventPeriod.annual,
        this.eventType = EventType.birthday;

  EventItem.annualHoliday(
      {@required this.name, @required this.startTime, this.endTime})
      : this.venue = "",
        this.eventPeriod = EventPeriod.annual,
        this.eventType = EventType.holiday;

  EventItem.holiday(
      {@required this.name, @required this.startTime, this.endTime})
      : this.venue = "",
        this.eventPeriod = EventPeriod.once,
        this.eventType = EventType.holiday;

  bool matchDate(DateTime otherDate,
      {DateTime untilAnotherDate, bool alwaysEndOfMonth = true}) {
    assert(untilAnotherDate == null ||
        (untilAnotherDate?.difference(otherDate)?.inDays ?? 0) >= 0);

    DateTime currentStart = clearTime(this.startTime);
    DateTime currentEnd = clearTime(this.endTime ?? this.startTime);
    DateTime otherStart = otherDate = clearTime(otherDate);
    DateTime otherEnd = clearTime(untilAnotherDate ?? otherDate);

    if (otherStart.difference(currentStart).inDays < 0) return false;

    switch (this.eventPeriod) {
      case EventPeriod.once:
        return !(currentStart.difference(otherStart).inDays < 0 &&
                currentEnd.difference(otherEnd).inDays < 0) &&
            !(currentStart.difference(otherStart).inDays > 0 &&
                currentEnd.difference(otherEnd).inDays > 0);
      case EventPeriod.daily:
        return true;
      case EventPeriod.weekly:
        if (!(currentStart.difference(otherStart).inDays < 0 &&
                currentEnd.difference(otherEnd).inDays < 0) &&
            !(currentStart.difference(otherStart).inDays > 0 &&
                currentEnd.difference(otherEnd).inDays > 0)) return true;

        int diffFromStart = otherStart.difference(currentStart).inDays;
        int currentLength = currentEnd.difference(currentStart).inDays;

        DateTime nearestStart =
            currentStart.add(Duration(days: (diffFromStart / 7).floor() * 7));
        DateTime nearestEnd = nearestStart.add(Duration(days: currentLength));

        return !(nearestStart.difference(otherStart).inDays < 0 &&
                nearestEnd.difference(otherEnd).inDays < 0) &&
            !(nearestStart.difference(otherStart).inDays > 0 &&
                nearestEnd.difference(otherEnd).inDays > 0);

        break;
      case EventPeriod.monthly:
        DateTime nearestStart;
        int startLastDay = getLastDay(DateTime(otherStart.year, otherStart.month, 1));
        if (currentStart.day > startLastDay) {
          if (alwaysEndOfMonth) {
            nearestStart =
                DateTime(otherStart.year, otherStart.month, startLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestStart =
                  DateTime(otherStart.year, otherStart.month, startLastDay + 1);
            }
          }
        } else {
          nearestStart =
              DateTime(otherStart.year, otherStart.month, (currentStart.day));
        }
        DateTime nearestEnd;
        int endLastDay = getLastDay(DateTime(otherEnd.year, otherEnd.month, 1));
        if (currentEnd.day > endLastDay) {
          if (alwaysEndOfMonth) {
            nearestEnd =
                DateTime(otherEnd.year, otherEnd.month, endLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestEnd =
                  DateTime(otherEnd.year, otherEnd.month, endLastDay + 1);
            }
          }
        } else {
          nearestEnd =
              DateTime(otherEnd.year, otherEnd.month, (currentEnd.day));
        }

        return !(nearestStart.difference(otherStart).inDays < 0 &&
                nearestEnd.difference(otherEnd).inDays < 0) &&
            !(nearestStart.difference(otherStart).inDays > 0 &&
                nearestEnd.difference(otherEnd).inDays > 0);
      case EventPeriod.annual:
        DateTime nearestStart;
        int startLastDay = getLastDay(DateTime(otherStart.year, currentStart.month, 1));
        if (currentStart.day > startLastDay) {
          if (alwaysEndOfMonth) {
            nearestStart =
                DateTime(otherStart.year, currentStart.month, startLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestStart =
                  DateTime(otherStart.year, currentStart.month, startLastDay + 1);
            }
          }
        } else {
          nearestStart =
              DateTime(otherStart.year, currentStart.month, (currentStart.day));
        }
        DateTime nearestEnd;
        int endLastDay = getLastDay(DateTime(otherEnd.year, currentEnd.month, 1));
        if (currentEnd.day > endLastDay) {
          if (alwaysEndOfMonth) {
            nearestEnd =
                DateTime(otherEnd.year, currentEnd.month, endLastDay);
          } else {
            if (this.endTime == null) {
              return false;
            } else {
              nearestEnd =
                  DateTime(otherEnd.year, currentEnd.month, endLastDay + 1);
            }
          }
        } else {
          nearestEnd =
              DateTime(otherEnd.year, currentEnd.month, (currentEnd.day));
        }

        return !(nearestStart.difference(otherStart).inDays < 0 &&
            nearestEnd.difference(otherEnd).inDays < 0) &&
            !(nearestStart.difference(otherStart).inDays > 0 &&
                nearestEnd.difference(otherEnd).inDays > 0);
    }
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
    } else if (dateTime.month == 4 ||
        dateTime.month == 6 ||
        dateTime.month == 9 ||
        dateTime.month == 11) {
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
}

class EventPage extends StatefulWidget {
  const EventPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventPageState();
}

class EventPageState extends AdvState<EventPage> {
  List<EventItem> eventItems = [
    EventItem.birthday(
        name: "Michelle Deborah Lusikooy", startTime: DateTime(1984, 2, 16)),
    EventItem.birthday(
        name: "Aseng Pasaribu", startTime: DateTime(1993, 12, 4)),
    EventItem.birthday(
        name: "Bonita Delores", startTime: DateTime(1995, 4, 24)),
    EventItem.birthday(
        name: "Charles Yeremia Far-Far", startTime: DateTime(1992, 9, 2)),
    EventItem.birthday(
        name: "Christiany Simamora", startTime: DateTime(1994, 7, 24)),
    EventItem.birthday(
        name: "Felly Meilinda", startTime: DateTime(1987, 5, 29)),
    EventItem.birthday(
        name: "Flora Katharina Hutabarat", startTime: DateTime(1978, 2, 27)),
    EventItem.birthday(
        name: "Fransisco Manullang", startTime: DateTime(1976, 7, 7)),
    EventItem.birthday(
        name: "Ida Merlin Purba", startTime: DateTime(1994, 5, 15)),
    EventItem.birthday(
        name: "Julita Rosalia Legi", startTime: DateTime(1993, 7, 5)),
    EventItem.birthday(name: "Mayyanti", startTime: DateTime(1990, 5, 3)),
    EventItem.birthday(name: "Mika Putri", startTime: DateTime(1992, 9, 21)),
    EventItem.birthday(name: "Nico Hasugian", startTime: DateTime(1992, 2, 27)),
    EventItem.birthday(name: "Proctor Tayu", startTime: DateTime(1987, 10, 25)),
    EventItem.birthday(
        name: "Richardo Gio Vanni Thayeb", startTime: DateTime(1991, 6, 6)),
    EventItem.birthday(name: "Roy Martino", startTime: DateTime(1986, 3, 11)),
    EventItem.birthday(name: "Stevvani", startTime: DateTime(1989, 9, 17)),
    EventItem.birthday(
        name: "Yohanna Meilina", startTime: DateTime(1985, 5, 5)),
  ];

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);

    DateTime n = DateTime.now();

    print(
        "nahh => ${DateTime(2019, 1, 29).difference(DateTime(2019, 6, 4)).inDays}");

    DateDict dict = DateDict.of(context);

    List<EventItem> holidays = [
      EventItem.holiday(
          name: dict.getString("chinese_new_year"),
          startTime: DateTime(2019, 2, 4)),
      EventItem.annualHoliday(
          name: dict.getString("new_year"), startTime: DateTime(2019, 1, 1)),
      EventItem.holiday(
          name: dict.getString("nyepi"), startTime: DateTime(2019, 3, 7)),
      EventItem.holiday(
          name: dict.getString("isra_miraj"), startTime: DateTime(2019, 4, 3)),
      EventItem.holiday(
          name: dict.getString("good_friday"),
          startTime: DateTime(2019, 4, 19)),
      EventItem.annualHoliday(
          name: dict.getString("labor_day"), startTime: DateTime(2019, 5, 1)),
      EventItem.holiday(
          name: dict.getString("vesak"), startTime: DateTime(2019, 5, 19)),
      EventItem.holiday(
          name: dict.getString("ascension"), startTime: DateTime(2019, 5, 30)),
      EventItem.annualHoliday(
          name: dict.getString("pancasila"), startTime: DateTime(2019, 6, 1)),
      EventItem.holiday(
          name: dict.getString("eid_alfitr"),
          startTime: DateTime(2019, 6, 3),
          endTime: DateTime(2019, 6, 7)),
      EventItem.holiday(
          name: dict.getString("eid_aladha"), startTime: DateTime(2019, 8, 11)),
      EventItem.annualHoliday(
          name: dict.getString("independence_day"),
          startTime: DateTime(2019, 8, 17)),
      EventItem.holiday(
          name: dict.getString("islamic_new_year"),
          startTime: DateTime(2019, 9, 1)),
      EventItem.holiday(
          name: dict.getString("mawlid"), startTime: DateTime(2019, 11, 9)),
      EventItem.holiday(
          name: dict.getString("christmas"),
          startTime: DateTime(2019, 12, 24),
          endTime: DateTime(2019, 12, 25)),
    ];

    eventItems.addAll(holidays);
  }

  @override
  Widget advBuild(BuildContext context) {
    return SafeArea(
      child: DailyCalendarCarousel(
        weekDays: PitComponents.weekdaysArray,
        onDayPressed: (DateTime date) {
//        if (_datePicked) return;
//        _datePicked = true;
//        this.setState(() => _currentDate = dates);
//        await new Future.delayed(const Duration(milliseconds: 200));
//        Navigator.pop(context, _currentDate);

          List<EventItem> newEventItems = [];

          for (EventItem item in eventItems) {
            if (item.matchDate(date)) {
              newEventItems.add(item);
            }
          }

          return newEventItems;
        },
        thisMonthDayBorderColor: Colors.grey,
        selectedDateTime: DateTime.now(),
        daysHaveCircularBorder: false,
        markedDates: [],
//        minDateTime: DateTime(2000, 11, 1),
//        maxDateTime: DateTime(2050, 2, 31),
      ),
    );
  }

  void onFabTapped() {
    print("Event here!");
  }
}

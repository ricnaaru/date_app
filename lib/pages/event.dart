//import 'package:date_app/components/daily_calendar_carousel.dart';
//import 'package:date_app/utilities/localization.dart';
//import 'package:date_app/utilities/models.dart';
//import 'package:flutter/material.dart';
//import 'package:pit_components/components/adv_state.dart';
//import 'package:pit_components/pit_components.dart';
//
//class EventPage extends StatefulWidget {
//  final List<Birthday> birthday;
//  final List<Holiday> holiday;
//  final List<Event> events;
//
//  EventPage({Key key, this.birthday, this.holiday, this.events}) : super(key: key);
//
//  @override
//  State<StatefulWidget> createState() => EventPageState();
//}
//
//class EventPageState extends AdvState<EventPage> {
//  GlobalKey<DailyCalendarCarouselState> _carouselKey = GlobalKey<DailyCalendarCarouselState>();
//
////  List<EventItem> eventItems = [
////    EventItem.birthday(name: "Michelle Deborah Lusikooy", startTime: DateTime(1984, 2, 16)),
////    EventItem.birthday(name: "Stevvani", startTime: DateTime(1989, 9, 17)),
////    EventItem.birthday(name: "Richardo Gio Vanni Thayeb", startTime: DateTime(1991, 6, 6)),
////    EventItem.birthday(name: "Julita Rosalia Legi", startTime: DateTime(1993, 7, 5)),
////    EventItem.birthday(name: "Felly Meilinda", startTime: DateTime(1987, 5, 29)),
////    EventItem.birthday(name: "Charles Yeremia Far-Far", startTime: DateTime(1992, 9, 2)),
////    EventItem.birthday(name: "Ida Merlin Purba", startTime: DateTime(1994, 5, 15)),
////    EventItem.birthday(name: "Aseng Pasaribu", startTime: DateTime(1993, 12, 4)),
////    EventItem.birthday(name: "Christiany Simamora", startTime: DateTime(1994, 7, 24)),
////    EventItem.birthday(name: "Nico Hasugian", startTime: DateTime(1992, 2, 27)),
////    EventItem.birthday(name: "Mika Putri", startTime: DateTime(1992, 9, 21)),
////    EventItem.birthday(name: "Proctor Tayu", startTime: DateTime(1987, 10, 25)),
////    EventItem.birthday(name: "Flora Katharina Hutabarat", startTime: DateTime(1978, 2, 27)),
////    EventItem.birthday(name: "Fransisco Manullang", startTime: DateTime(1976, 7, 7)),
////    EventItem.birthday(name: "Bonita Delores", startTime: DateTime(1995, 4, 24)),
////    EventItem.birthday(name: "Mayyanti", startTime: DateTime(1990, 5, 3)),
////    EventItem.birthday(name: "Roy Martino", startTime: DateTime(1986, 3, 11)),
////    EventItem.birthday(name: "Yohanna Meilina", startTime: DateTime(1985, 5, 5)),
////    EventItem(name: "Bawa Makan", startTime: DateTime(2019, 5, 5)),
////  ];
//
//  @override
//  void initStateWithContext(BuildContext context) {
//    super.initStateWithContext(context);
//
//    DateDict dict = DateDict.of(context);
//
////    List<EventItem> holidays = [
////      EventItem.holiday(name: dict.getString("chinese_new_year"), startTime: DateTime(2019, 2, 5)),
////      EventItem.annualHoliday(name: dict.getString("new_year"), startTime: DateTime(2019, 1, 1)),
////      EventItem.holiday(name: dict.getString("nyepi"), startTime: DateTime(2019, 3, 7)),
////      EventItem.holiday(name: dict.getString("isra_miraj"), startTime: DateTime(2019, 4, 3)),
////      EventItem.holiday(name: dict.getString("good_friday"), startTime: DateTime(2019, 4, 19)),
////      EventItem.annualHoliday(name: dict.getString("labor_day"), startTime: DateTime(2019, 5, 1)),
////      EventItem.holiday(name: dict.getString("vesak"), startTime: DateTime(2019, 5, 19)),
////      EventItem.holiday(name: dict.getString("ascension"), startTime: DateTime(2019, 5, 30)),
////      EventItem.annualHoliday(name: dict.getString("pancasila"), startTime: DateTime(2019, 6, 1)),
////      EventItem.holiday(name: dict.getString("eid_alfitr"), startTime: DateTime(2019, 6, 3), endTime: DateTime(2019, 6, 7)),
////      EventItem.holiday(name: dict.getString("eid_aladha"), startTime: DateTime(2019, 8, 11)),
////      EventItem.annualHoliday(name: dict.getString("independence_day"), startTime: DateTime(2019, 8, 17)),
////      EventItem.holiday(name: dict.getString("islamic_new_year"), startTime: DateTime(2019, 9, 1)),
////      EventItem.holiday(name: dict.getString("mawlid"), startTime: DateTime(2019, 11, 9)),
////      EventItem.holiday(name: dict.getString("christmas"), startTime: DateTime(2019, 12, 24), endTime: DateTime(2019, 12, 25)),
////    ];
//
////    eventItems.addAll(holidays);
//  }
//
//  @override
//  Widget advBuild(BuildContext context) {
//    return SafeArea(
//      child: DailyCalendarCarousel(
//        key: _carouselKey,
//        minDateTime: DateTime(2019, 1, 1),
//        maxDateTime: DateTime(2019, 12, 31),
//        weekDays: PitComponents.weekdaysArray,
//        checkMarkedCallback: (DateTime date, PickType type, {EventCategory category}) {
//          if (category == EventCategory.birthday && widget.birthday != null) {
//            if (widget.birthday
//                .where((Birthday birthday) => DateTime(date.year, birthday.date.month, birthday.date.day) == date)
//                .length >
//                0) return true;
//          }
//
//          if (category == EventCategory.holiday && widget.holiday != null) {
//            List<Holiday> xo = widget.holiday.where((Holiday holiday) {
//              DateTime startDate = holiday.startDate;
//              DateTime endDate = holiday.endDate;
//
//              if (holiday.period == HolidayPeriod.once) {
//                if (endDate == null) {
//                  return date.compareTo(startDate) == 0;
//                } else {
//                  return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
//                }
//              } else if (holiday.period == HolidayPeriod.annual) {
//                startDate = DateTime(date.year, startDate.month, startDate.day);
//
//                if (endDate == null) {
//                  return date.compareTo(startDate) == 0;
//                } else {
//                  endDate = DateTime(date.year, endDate.month, endDate.day);
//
//                  return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
//                }
//              }
//            }).toList();
//
//            return xo.length > 0;
//          }
//
//          return false;
//        },
//        getEventCallback: (DateTime date) {
//          List<Event> events = [];
//          if (widget.birthday != null) {
//            events.addAll(widget.birthday
//                .where((Birthday birthday) => DateTime(date.year, birthday.date.month, birthday.date.day) == date)
//                .map((Birthday birthday) => Event.fromBirthday(birthday))
//                .toList());
//          }
//
//          if (widget.holiday != null) {
//            events.addAll(widget.holiday
//                .where((Holiday holiday) {
//              DateTime startDate = holiday.startDate;
//              DateTime endDate = holiday.endDate;
//              print("startDate => $startDate");
//              print("endDate => $endDate");
//              print("holiday.period => ${holiday.period}");
//              if (holiday.period == HolidayPeriod.once) {
//                if (endDate == null) {
//                  return date.compareTo(startDate) == 0;
//                } else {
//                  return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
//                }
//              } else if (holiday.period == HolidayPeriod.annual) {
//                startDate = DateTime(date.year, startDate.month, startDate.day);
//
//                if (endDate == null) {
//                  return date.compareTo(startDate) == 0;
//                } else {
//                  endDate = DateTime(date.year, endDate.month, endDate.day);
//
//                  return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
//                }
//              }
//            })
//                .map((Holiday holiday) => Event.fromHoliday(holiday))
//                .toList());
//          }
//
//          return events;
//        },
//        onDayPressed: (DateTime date) {
////        if (_datePicked) return;
////        _datePicked = true;
////        this.setState(() => _currentDate = dates);
////        await new Future.delayed(const Duration(milliseconds: 200));
////        Navigator.pop(context, _currentDate);
//
////          List<Event> newEventItems = [];
////
////          for (EventItem item in eventItems) {
////            if (item.matchDate(date)) {
////              newEventItems.add(item);
////            }
////          }
////
////          return newEventItems;
//        },
//        thisMonthDayBorderColor: Colors.grey,
//        selectedDateTime: DateTime.now(),
//        daysHaveCircularBorder: false,
////        minDateTime: DateTime(2000, 11, 1),
////        maxDateTime: DateTime(2050, 2, 31),
//      ),
//    );
//  }
//
//  void onFabTapped() {
//    print("syalalalla");
//    _carouselKey.currentState.onFabTapped();
//  }
//}

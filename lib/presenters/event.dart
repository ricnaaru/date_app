import 'package:date_app/components/daily_calendar_carousel.dart';
import 'package:date_app/models.dart';
import 'package:date_app/pages/event_detail.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';

class EventPresenter extends Presenter {
  DateTime lastDate = DateTime.now();
  List<Widget> lastEventWidgets = [];
  List<EventModel> events;
  List<BirthdayModel> birthdays;
  List<HolidayModel> holidays;

  EventPresenter(BuildContext context, View<StatefulWidget> view) : super(context, view);

  @override
  void init() {}

  bool checkMarkedDate(DateTime date, PickType type, {MarkerType markerType}) {
    if (markerType == MarkerType.birthday) {
      if (birthdays == null) return false;

      if (birthdays
              .where((BirthdayModel birthday) =>
                  DateTime(date.year, birthday.date.month, birthday.date.day) == date)
              .length >
          0) return true;
    }

    if (markerType == MarkerType.event) {
      if (events == null) return false;

      if (events
              .where((EventModel event) =>
                  date.compareTo(event.startDate) >= 0 && date.compareTo(event.endDate) <= 0)
              .length >
          0) return true;
    }

    if (markerType == MarkerType.holiday) {
      if (holidays == null) return false;

      List<HolidayModel> xo = holidays.where((HolidayModel holiday) {
        DateTime startDate = holiday.startDate;
        DateTime endDate = holiday.endDate;

        if (holiday.interval == HolidayIntervalType.once) {
          if (endDate == null) {
            return date.compareTo(startDate) == 0;
          } else {
            return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
          }
        } else if (holiday.interval == HolidayIntervalType.annual) {
          startDate = DateTime(date.year, startDate.month, startDate.day);

          if (endDate == null) {
            return date.compareTo(startDate) == 0;
          } else {
            endDate = DateTime(date.year, endDate.month, endDate.day);

            return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
          }
        }
      }).toList();

      return xo.length > 0;
    }

    return false;
  }

  void onFabTapped() {
    Routing.push(context, EventDetailPage(lastDate, lastEventWidgets));
  }

  List<Widget> onDayPressed(DateTime date, EventCardGenerator eventCardGenerator) {
    List<Widget> result = [];

    if (birthdays != null)
      result.addAll(birthdays
          .where((BirthdayModel birthday) =>
              DateTime(date.year, birthday.date.month, birthday.date.day) == date)
          .map((birthday) {
        return eventCardGenerator(birthday.name, MarkerType.birthday);
      }));

    if (events != null)
      result.addAll(events
          .where((EventModel event) =>
              date.compareTo(event.startDate) >= 0 && date.compareTo(event.endDate) <= 0)
          .map((event) {
        return eventCardGenerator(event.name, MarkerType.event);
      }));

    if (holidays != null)
      result.addAll(holidays.where((HolidayModel holiday) {
        DateTime startDate = holiday.startDate;
        DateTime endDate = holiday.endDate;

        if (holiday.interval == HolidayIntervalType.once) {
          if (endDate == null) {
            return date.compareTo(startDate) == 0;
          } else {
            return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
          }
        } else if (holiday.interval == HolidayIntervalType.annual) {
          startDate = DateTime(date.year, startDate.month, startDate.day);

          if (endDate == null) {
            return date.compareTo(startDate) == 0;
          } else {
            endDate = DateTime(date.year, endDate.month, endDate.day);

            return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
          }
        }
      }).map((holiday) {
        return eventCardGenerator(dict.getString(holiday.name), MarkerType.holiday);
      }));

    lastEventWidgets = result;
    lastDate = date;
    return result;
  }
}

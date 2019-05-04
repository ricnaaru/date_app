import 'package:date_app/components/daily_calendar_carousel.dart';
import 'package:date_app/models.dart';
import 'package:date_app/pages/event_detail.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';

class EventPresenter extends Presenter {
  DateTime lastDate = DateTime.now();
  List<EventModel> lastEvents = [];

  EventPresenter(BuildContext context, View<StatefulWidget> view) : super(context, view);

  @override
  void init() {
  }

  bool checkMarkedDate(List<EventModel> events, DateTime date, PickType type,
      {EventCategory category}) {
    if (events == null) return false;

    if (category == EventCategory.birthday) {
      if (events
              .where((EventModel event) =>
                  event.category == EventCategory.birthday &&
                  DateTime(date.year, event.startDate.month, event.startDate.day) == date)
              .length >
          0) return true;
    }

    if (category == EventCategory.holiday) {
      return events.where((EventModel event) {
            DateTime startDate = event.startDate;
            DateTime endDate = event.endDate;

            if (event.category != EventCategory.holiday) return false;

            if (event.interval == IntervalType.once) {
              if (endDate == null) {
                return date.compareTo(startDate) == 0;
              } else {
                return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
              }
            } else if (event.interval == IntervalType.annual) {
              startDate = DateTime(date.year, startDate.month, startDate.day);

              if (endDate == null) {
                return date.compareTo(startDate) == 0;
              } else {
                endDate = DateTime(date.year, endDate.month, endDate.day);

                return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
              }
            }
          }).length >
          0;
    }

    return false;
  }

  void onFabTapped() {
    Routing.push(context, EventDetailPage(lastDate, lastEvents));
  }

  List<EventModel> onDayPressed(List<EventModel> events, DateTime date) {
    List<EventModel> result = [];

    if (events == null) return [];

    result.addAll(events
        .where((EventModel event) =>
    DateTime(date.year, event.startDate.month, event.startDate.day) == date &&
        event.category == EventCategory.birthday)
        .toList());

    result.addAll(events.where((EventModel event) {
      DateTime startDate = event.startDate;
      DateTime endDate = event.endDate;

      if (event.category != EventCategory.holiday) return false;

      if (event.interval == IntervalType.once) {
        if (endDate == null) {
          return date.compareTo(startDate) == 0;
        } else {
          return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
        }
      } else if (event.interval == IntervalType.annual) {
        startDate = DateTime(date.year, startDate.month, startDate.day);

        if (endDate == null) {
          return date.compareTo(startDate) == 0;
        } else {
          endDate = DateTime(date.year, endDate.month, endDate.day);

          return date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0;
        }
      }
    }).toList());
    lastEvents = result;
    return result;
  }
}

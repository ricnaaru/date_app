import 'package:date_app/models.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/presenters/event.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';

abstract class HomeInterface {
  void onDataRefreshed();
  void resetEvents();
}

class HomePresenter extends Presenter {
  List<NewsFeedModel> _newsFeed;
  List<EventModel> _events;
  List<BirthdayModel> _birthdays;
  List<HolidayModel> _holidays;
  int currentIndex = 0;
  EventPresenter eventPresenter;

  HomePresenter(BuildContext context, View<StatefulWidget> view)
      : super(context, view);

  @override
  void init() {
    refreshFeed().then((_) {
      view.refresh();
    });
    refreshEvents().then((_) {
      view.refresh();
    });
    refreshBirthdays().then((_) {
      view.refresh();
    });
    refreshHolidays().then((_) {
      view.refresh();
    });
  }

  Future<void> refreshFeed() async {
    await Future.delayed(Duration(seconds: 2));
    List<NewsFeedModel> newsFeeds = await DataEngine.getNewsFeed(context);
    this._newsFeed = newsFeeds;
  }

  Future<void> refreshEvents() async {
    await Future.delayed(Duration(seconds: 2));
    List<EventModel> events = await DataEngine.getEvent(context);
    this._events = events;
  }

  Future<void> refreshHolidays() async {
    await Future.delayed(Duration(seconds: 2));
    List<HolidayModel> holidays = await DataEngine.getHoliday(context);
    this._holidays = holidays;
  }

  Future<void> refreshBirthdays() async {
    await Future.delayed(Duration(seconds: 2));
    List<BirthdayModel> birthdays = await DataEngine.getBirthday(context);
    this._birthdays = birthdays;
  }

  List<NewsFeedModel> get newsFeed => _newsFeed;

  List<EventModel> get events => _events;

  List<BirthdayModel> get birthdays => _birthdays;

  List<HolidayModel> get holidays => _holidays;

  void onFabTapped() {
    if (currentIndex == 1) {
      //Event
      eventPresenter?.onFabTapped();
    }
  }
}

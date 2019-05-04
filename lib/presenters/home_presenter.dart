import 'package:date_app/models.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/presenters/event.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';

abstract class HomeInterface {
  void onDataRefreshed();
}

class HomePresenter extends Presenter {
  HomeInterface _homeInterface;
  List<NewsFeedModel> _newsFeed;
  List<EventModel> _events;
  int currentIndex = 0;
  EventPresenter eventPresenter;

  HomePresenter(BuildContext context, View<StatefulWidget> view, {HomeInterface homeInterface})
      : this._homeInterface = homeInterface,
        super(context, view);

  @override
  void init() {
    refreshFeed().then((_) {
      view.refresh();
    });
    refreshEvents().then((_) {
      view.refresh();
    });
  }

  Future<void> refreshFeed() async {
    await Future.delayed(Duration(seconds: 2));
    List<NewsFeedModel> newsFeeds = await DataEngine.getNewsFeed(context);
    this._newsFeed = newsFeeds;
    _homeInterface.onDataRefreshed();
  }

  Future<void> refreshEvents() async {
    await Future.delayed(Duration(seconds: 2));
    List<EventModel> events = await DataEngine.getEvent(context);
    this._events = events;
    _homeInterface.onDataRefreshed();
  }

  List<NewsFeedModel> get newsFeed => _newsFeed;

  List<EventModel> get events => _events;

  void onFabTapped() {
    if (currentIndex == 1) {
      //Event
      eventPresenter?.onFabTapped();
    }
  }
}

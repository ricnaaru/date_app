import 'package:date_app/models.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/view.dart';
import 'package:flutter/src/widgets/framework.dart';

abstract class HomeInterface {
  void onDataRefreshed();
}

class HomePresenter extends Presenter {
  HomeInterface _interface;
  List<NewsFeedModel> _newsFeed;

  HomePresenter(BuildContext context, View<StatefulWidget> view, {HomeInterface interface})
      : this._interface = interface,
        super(context, view);

  @override
  void init() {
    view.process(() async {
      await refreshFeed();
    });
  }

  Future<void> refreshFeed() async {
    await Future.delayed(Duration(seconds: 2));
    List<NewsFeedModel> newsFeeds = await DataEngine.getNewsFeed(context);
    this._newsFeed = newsFeeds;
    _interface.onDataRefreshed();
  }

  List<NewsFeedModel> get newsFeed => _newsFeed;
}

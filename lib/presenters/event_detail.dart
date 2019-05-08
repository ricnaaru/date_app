import 'package:date_app/pages/event_add.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';

class EventDetailPresenter extends Presenter {
  DateTime _date;
  EventDetailPresenter(BuildContext context, View<StatefulWidget> view, DateTime date) : this._date = date, super(context, view);

  @override
  void init() {}

  void handleChatTapped() async {
    if (!view.mounted) return;

//    Routing.push(context, OpenDiscussionPage());
  }

  void handleEventTapped() {
    if (!view.mounted) return;

    Routing.push(context, EventAddPage(date: _date));
  }
}

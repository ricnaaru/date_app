import 'package:date_app/components/daily_calendar_carousel.dart';
import 'package:date_app/models.dart';
import 'package:date_app/pages/event_add.dart';
import 'package:date_app/pages/event_detail.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';

class MyEventPresenter extends Presenter {
  List<EventSettingModel> myEvents;

  MyEventPresenter(BuildContext context, View<StatefulWidget> view) : super(context, view);

  @override
  void init() {
  }

  void goToEditEvent(EventSettingModel eventSetting) {
    Routing.push(context, EventAddPage(eventSetting: eventSetting));
  }

  void deleteEventSetting(EventSettingModel eventSetting) async {

    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(dict.getString("confirmation")),
          content: Text(dict.getString("confirm_delete_event_setting")),
          actions: <Widget>[
            FlatButton(
              child: Text(dict.getString("no")),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text(dict.getString("yes")),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );

    if (!confirmed) return;

    view.process( () async {
      await DataEngine.deleteEventSetting(eventSetting.id);

      view.refresh();
    });
  }
}

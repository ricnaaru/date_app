import 'package:date_app/pages/event_add.dart';
import 'package:date_app/pages/home.dart';
import 'package:date_app/pages/home_container.dart';
import 'package:date_app/pages/register.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class EventDetailPresenter extends Presenter {
  EventDetailPresenter(BuildContext context, View<StatefulWidget> view) : super(context, view);

  @override
  void init() {}

  void handleChatTapped() async {
    if (!view.mounted) return;

//    Routing.push(context, OpenDiscussionPage());
  }

  void handleEventTapped() {
    if (!view.mounted) return;

    Routing.push(context, EventAddPage());

//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          DateDict dict = DateDict.of(context);
//          return AdvDialog(
//            title: dict.getString("add_event"),
//            content: Text("Content will available soon!"),
//          );
//        });
  }
}

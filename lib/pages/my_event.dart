import 'package:date_app/cards/event_setting_card.dart';
import 'package:date_app/components/daily_calendar_carousel.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event.dart';
import 'package:date_app/presenters/home_container.dart';
import 'package:date_app/presenters/my_event.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/pit_components.dart';
import 'package:refresher/refresher.dart';

class MyEventPage extends StatefulWidget {
  final HomePresenter homePresenter;

  MyEventPage(this.homePresenter);

  @override
  State<StatefulWidget> createState() => MyEventPageState();
}

class MyEventPageState extends View<MyEventPage> {
  MyEventPresenter _presenter;
  HomePresenter _homePresenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _presenter = MyEventPresenter(context, this);
    _homePresenter = widget.homePresenter;
  }

  @override
  Widget buildView(BuildContext context) {
    _presenter.myEvents = _homePresenter.myEvents;

    DateFormat df = dict.getDateFormat("dd MMM yyyy");

    return Refresher(
      onRefresh: () async {
        await _homePresenter.refreshMyEvents();
        setState(() {});
      },
      child: AdvColumn(
        margin: EdgeInsets.all(16.0),
        divider: ColumnDivider(16.0),
        children: (_presenter.myEvents ?? []).map((myEvent) {
          return EventSettingCard(
            eventSetting: myEvent,
            onEdit: () {
              _presenter.goToEditEvent(myEvent);
            },
            onDelete: () {
              _presenter.deleteEventSetting(myEvent);
            },
          );
        }).toList(),
      ),
    );
  }
}

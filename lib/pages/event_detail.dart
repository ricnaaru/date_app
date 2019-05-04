import 'package:date_app/components/adv_floating_button.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event_detail.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/string_helper.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';

class EventDetailPage extends StatefulWidget {
  final DateTime date;
  final List<EventModel> eventItems;

  EventDetailPage(this.date, this.eventItems);

  @override
  State<StatefulWidget> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends View<EventDetailPage> with TickerProviderStateMixin {
  EventDetailPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _presenter = EventDetailPresenter(context, this);
  }

  @override
  Widget buildView(BuildContext context) {
    DateDict dict = DateDict.of(context);
    DateFormat df = dict.getDateFormat("d MMM yyyy");

    List<Widget> children = [];

    for (int i = 0; i < (widget.eventItems?.length ?? 0); i++) {
      Widget child = _buildEventCard(dict, widget.eventItems[i]);

      children.add(child);
    }

    if (children.length == 0) {
      children.add(Center(
          child: Material(color: Colors.transparent, child: Text(dict.getString("no_event")))));
    }

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(df.format(widget.date), style: h8.copyWith(color: Colors.white)),
          Text(dict.getString("event_detail"), style: p4.copyWith(color: Colors.white)),
        ]),
        elevation: 1.0,
      ),
      body: SingleChildScrollView(
          child: Hero(
        tag: "dailyDetail",
        child: AdvColumn(
            divider: ColumnDivider(8.0),
            margin: EdgeInsets.only(top: 16.0, bottom: 85.0),
            children: children),
      )),
      floatingActionButton: AdvFloatingButton(
        icons: [Icons.event_note, Icons.chat],
        callbacks: [_presenter.handleEventTapped, _presenter.handleChatTapped],
      ),
    );
  }

  Widget _buildEventCard(DateDict dict, EventModel item) {
    IconData icon;
    String text;

    switch (item.category) {
      case EventCategory.birthday:
        icon = Icons.cake;
        text = StringHelper.formatString(dict.getString("s_birthday"), {"{name}": "${item.name}"});
        break;
      case EventCategory.holiday:
        icon = Icons.flag;
        text = "${dict.getString(item.name)}";
        break;
      case EventCategory.date:
        icon = Icons.group;
        text = "DATE : ${item.name}";
        break;
      case EventCategory.jpcc:
        icon = Icons.home;
        text = "JPCC : ${item.name}";
        break;
      case EventCategory.group:
        icon = Icons.group;
        text = "${dict.getString("group")} : ${item.name}";
        break;
      case EventCategory.personal:
        icon = Icons.person;
        text = "${dict.getString("personal")} : ${item.name}";
        break;
    }

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: AdvRow(children: [
          Expanded(child: Material(color: Colors.transparent, child: Text(text))),
          Icon(icon)
        ]));
  }
}

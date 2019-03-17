import 'package:date_app/components/adv_floating_button.dart';
import 'package:date_app/pages/add_event.dart';
import 'package:date_app/pages/event.dart';
import 'package:date_app/pages/open_discussion.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/models.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/utilities/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';

class EventDetailPage extends StatefulWidget {
  final List<Event> eventItems;

  EventDetailPage(this.eventItems);

  @override
  State<StatefulWidget> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);

    List<Widget> children = [];

    for (int i = 0; i < (widget.eventItems?.length ?? 0); i++) {
      Widget child = _buildEventCard(dict, widget.eventItems[i]);

      children.add(child);
    }

    if (children.length == 0) {
      children.add(Center(
          child: Material(
              color: Colors.transparent,
              child: Text(dict.getString("no_event")))));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dict.getString("event_detail")),
        elevation: 0.0,
        backgroundColor: Colors.white,
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
        callbacks: [_handleEventTapped, _handleChatTapped],
      ),
    );
  }

  Widget _buildEventCard(DateDict dict, Event item) {
    IconData icon;
    String text;

    switch (item.category) {
      case EventCategory.birthday:
        icon = Icons.cake;
        text = StringHelper.formatString(
            dict.getString("s_birthday"), {"{name}": "${item.name}"});
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
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: AdvRow(children: [
          Expanded(
              child: Material(color: Colors.transparent, child: Text(text))),
          Icon(icon)
        ]));
  }

  void _handleChatTapped() async {
    if (!this.mounted) return;

    Routing.push(context, OpenDiscussionPage());
  }

  void _handleEventTapped() {
    if (!this.mounted) return;

    Routing.push(context, AddEventPage());

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

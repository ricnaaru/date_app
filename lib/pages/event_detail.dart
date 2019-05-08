import 'package:date_app/components/adv_floating_button.dart';
import 'package:date_app/presenters/event_detail.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';

class EventDetailPage extends StatefulWidget {
  final DateTime date;
  final List<Widget> eventWidgets;

  EventDetailPage(this.date, this.eventWidgets);

  @override
  State<StatefulWidget> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends View<EventDetailPage> with TickerProviderStateMixin {
  EventDetailPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _presenter = EventDetailPresenter(context, this, widget.date);
  }

  @override
  Widget buildView(BuildContext context) {
    DateDict dict = DateDict.of(context);
    DateFormat df = dict.getDateFormat("d MMM yyyy");

    List<Widget> children = [];

    for (int i = 0; i < (widget.eventWidgets?.length ?? 0); i++) {
      children.add(widget.eventWidgets[i]);
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
}

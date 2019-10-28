import 'package:date_app/cards/event_position_card.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event_position.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/pit_components.dart';

class EventPositionPage extends StatefulWidget {
  final EventSettingModel event;

  EventPositionPage({this.event});

  @override
  State<StatefulWidget> createState() => _EventPositionPageState();
}

class _EventPositionPageState extends View<EventPositionPage> {
  EventPositionPresenter _presenter;
  TextStyle labelStyle = PitComponents.getLabelTextStyle();

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);

    _presenter = EventPositionPresenter(context, this, event: widget.event);
  }

  @override
  Widget buildView(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(dict.getString("event_position")),
        elevation: 1.0,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _presenter.submit();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: AdvColumn(
            margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            divider: ColumnDivider(16.0),
            children: _presenter.event.positions.map((position) {
              return EventPositionCard(model: position);
            }).toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _presenter.addPosition();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

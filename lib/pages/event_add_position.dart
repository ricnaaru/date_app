import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event_add.dart';
import 'package:date_app/presenters/event_add_position.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_text_field.dart';

class EventAddPositionPage extends StatefulWidget {
  final List<PositionModel> positions;
  final int participantQty;

  EventAddPositionPage({this.positions, this.participantQty});

  @override
  State<StatefulWidget> createState() => _EventAddPositionPageState();
}

class _EventAddPositionPageState extends View<EventAddPositionPage> {
  EventAddPositionPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);

    _presenter = EventAddPositionPresenter(context, this, widget.positions, widget.participantQty);
  }

  @override
  Widget buildView(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(dict.getString("add_position")),
        elevation: 1.0,
      ),
      body: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: SingleChildScrollView(
            child: AdvColumn(
                margin: EdgeInsets.all(16.0),
                crossAxisAlignment: CrossAxisAlignment.start,
                divider: ColumnDivider(16.0),
                children: [
                  AdvTextField(controller: _presenter.nameController),
                  AdvTextField(controller: _presenter.codeController),
                  AdvTextField(controller: _presenter.descController),
                  AdvIncrement(controller: _presenter.qtyController),
                ]),
          ),
        ),
        Container(
          child: AdvButton(
            dict.getString("submit"),
            width: double.infinity,
            onPressed: () {
              _presenter.submit();
            },
          ),
          margin: EdgeInsets.all(16.0),
        )
      ]),
    );
  }
}

import 'package:date_app/cards/position_card.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event_position.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/pit_components.dart';
import 'package:smart_text/smart_text.dart';

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

    List<Widget> positionWidgets = [];

    for (int i = 0; i < _presenter.positionControllers.length; i++) {
      Widget row =
          AdvRow(crossAxisAlignment: CrossAxisAlignment.end, divider: RowDivider(8.0), children: [
        Expanded(child: AdvTextField(controller: _presenter.positionControllers[i])),
        AdvIncrement(
          measureText: "@@@@@@",
          controller: _presenter.totalPositionControllers[i],
        )
      ]);

      positionWidgets.add(row);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dict.getString("event_setting")),
        elevation: 1.0,
      ),
      body: AdvColumn(children: [
        Expanded(
            child: SingleChildScrollView(
          child: AdvColumn(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              divider: ColumnDivider(16.0),
              children: [
                PositionCard(
                  model: PositionModel(
                      name: "Gladi Resik",
                      code: "GR",
                      description:
                          "Latihan terakhir dari suatu kegiatan pementasan atau segala hal yang akan disajikan ke ruang publik",
                      qty: 10),
                ),
                AdvColumn(divider: ColumnDivider(2.0), children: [
                  AdvRow(
                      mainAxisAlignment: MainAxisAlignment.end,
                      divider: RowDivider(8.0),
                      children: [
                        Expanded(
                          child: Text(
                            dict.getString("position"),
                            style: labelStyle,
                          ),
                        ),
                        InkWell(
                          child: Text(dict.getString("add_position"),
                              style: labelStyle.copyWith(color: systemHyperlinkColor)),
                          onTap: () {
                            _presenter.addPosition();
                          },
                        )
                      ]),
                  AdvColumn(divider: ColumnDivider(8.0), children: positionWidgets),
                ]),
              ]),
        )),
        Container(
            margin: EdgeInsets.all(18.0),
            child: AdvButton(
              dict.getString("next"),
              width: double.infinity,
              onPressed: () {
                _presenter.submit();
              },
            ))
      ]),
    );
  }
}

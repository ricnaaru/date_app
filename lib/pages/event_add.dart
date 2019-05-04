import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/presenters/event_add.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class EventAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventAddPageState();
}

class _EventAddPageState extends View<EventAddPage> {
  EventAddPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);

    _presenter = EventAddPresenter(context, this);
  }

  @override
  Widget buildView(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(dict.getString("add_event")),
        elevation: 1.0,
      ),
      body: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: SingleChildScrollView(
            child: AdvColumn(
                margin: EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 16.0, bottom: 8.0),
                crossAxisAlignment: CrossAxisAlignment.start,
                divider: ColumnDivider(16.0),
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AdvTextField(controller: _presenter.nameController),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AdvTextField(controller: _presenter.descController),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AdvTextField(controller: _presenter.locationController),
                  ),
                  AdvRow(margin: EdgeInsets.symmetric(horizontal: 8.0), divider: RowDivider(8.0), children: [
                    Expanded(
                      child: InkWell(
                        child: IgnorePointer(
                          ignoring: true,
                          child: AdvTextField(controller: _presenter.fromTimeController),
                        ),
                        onTap: () {
                          _presenter.pickStartTime();
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: IgnorePointer(
                          ignoring: true,
                          child: AdvTextField(controller: _presenter.toTimeController),
                        ),
                        onTap: () {
                          _presenter.pickEndTime();
                        },
                      ),
                    )
                  ]),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AdvChooserDialog(controller: _presenter.categoryController),
                  ),
                ]),
          ),
        ),
        Container(
          child: AdvButton(
            dict.getString("next"),
            width: double.infinity,
            onPressed: () {
              _presenter.nextPage();
            },
          ),
          margin: EdgeInsets.all(16.0),
        )
      ]),
    );
  }
}

import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event_add.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_text_field.dart';

class EventAddPage extends StatefulWidget {
  final DateTime date;
  final EventSettingModel eventSetting;

  EventAddPage({this.date, this.eventSetting}) : assert(date == null || eventSetting == null);

  @override
  State<StatefulWidget> createState() => _EventAddPageState();
}

class _EventAddPageState extends View<EventAddPage> {
  EventAddPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);

    _presenter = EventAddPresenter(
        context,
        this,
        widget.eventSetting == null
            ? EventAddPresenter.constructModel(widget.date)
            : widget.eventSetting);
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
                margin: EdgeInsets.all(16.0),
                crossAxisAlignment: CrossAxisAlignment.start,
                divider: ColumnDivider(16.0),
                children: [
                  AdvTextField(controller: _presenter.nameController),
                  AdvTextField(controller: _presenter.descController),
                  AdvTextField(controller: _presenter.locationController),
                  AdvRow(
                    divider: RowDivider(8.0),
                    children: <Widget>[
                      Expanded(
                        child: AdvDatePicker(
                          selectionType: _presenter.endDateController.enable ? SelectionType.range : SelectionType.single,
                          controller: _presenter.startDateController,
                          onChanged: (dates) {
                            _presenter.onDatePicked(dates);
                          },
                        ),
                      ),
                      Expanded(
                        child: AdvDatePicker(
                          selectionType: SelectionType.range,
                          controller: _presenter.endDateController,
                          onChanged: (dates) {
                            _presenter.onDatePicked(dates);
                          },
                          onToggled: _presenter.onEndDateToggled,
                        withSwitcher: true,
                        ),
                      ),
                    ],
                  ),
                  AdvRow(divider: RowDivider(8.0), children: [
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
                  AdvChooserDialog(controller: _presenter.categoryController),
                  AdvChooserDialog(
                    controller: _presenter.periodController,
                    itemChangeListener: (context, oldValue, newValue) {
                      _presenter.onPeriodChanged(context, oldValue, newValue);
                    },
                  ),
                  (_presenter.periodController.text == "custom")
                      ? AdvIncrement(controller: _presenter.daysController)
                      : null,
                  (_presenter.periodController.text != "once")
                      ? AdvDatePicker(
                          selectionType: SelectionType.single,
                          controller: _presenter.lastGenerateDateController,
                          onChanged: _presenter.onLastGenerateDatePicked,
                        )
                      : null,
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

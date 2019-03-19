import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/pages/add_event_position_setting.dart';
import 'package:date_app/pages/open_discussion.dart';
import 'package:date_app/utilities/backend.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/models.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/adv_radio_button.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/pit_components.dart';

class AddEventSettingPage extends StatefulWidget {
  final String name;
  final String description;
  final String location;
  final String startTime;
  final String endTime;
  final String type;
  final List<Participant> participants;

  AddEventSettingPage(
    this.participants, {
    this.name,
    this.description,
    this.location,
    this.startTime,
    this.endTime,
    this.type,
  });

  @override
  State<StatefulWidget> createState() => _AddEventSettingPageState();
}

class _AddEventSettingPageState extends AdvState<AddEventSettingPage> {
  List<CheckListItem> _allCheckListItems;
  List<CheckListItem> _filteredCheckListItems;
  bool _reorderMode = false;
  bool ascOrder = false;
  AdvIncrementController daysController;
  AdvChooserController periodController;
  List<AdvTextFieldController> positionControllers;
  List<AdvIncrementController> totalPositionControllers;
  AdvRadioGroupController methodController;
  AdvDatePickerController startDateController;
  AdvDatePickerController endDateController;
  AdvChooserController availabilityController;
  TextStyle labelStyle = PitComponents.getLabelTextStyle();

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);
    Map<String, String> eventPeriods = dict.getMap("event_period");
    Map<String, String> checkAvailabilityPeriods = dict.getMap("check_availability");

    String asOrdered = dict.getString("as_ordered");
    String shuffle = dict.getString("shuffle");
    DateTime nextMonth = DateTime.now().add(Duration(days: 30));

    periodController = AdvChooserController(
      label: dict.getString("event_period"),
      text: "once",
      items: eventPeriods.keys.map((key) => GroupCheckItem(key, eventPeriods[key])).toList(),
    );
    daysController = AdvIncrementController(
      label: dict.getString("days_interval"),
      minCounter: 0,
      maxCounter: 366,
    );
    positionControllers = [_defaultPositionController()];
    totalPositionControllers = [_defaultTotalPositionController()];
    methodController = AdvRadioGroupController(checkedValue: "as_ordered", itemList: [
      RadioGroupItem(
        "as_ordered",
        activeItem: AdvRow(divider: RowDivider(4.0), children: [
          Icon(Icons.reorder, color: systemPrimaryColor),
          Text(asOrdered, style: TextStyle(color: systemPrimaryColor))
        ]),
        inactiveItem: AdvRow(
            divider: RowDivider(4.0),
            children: [Icon(Icons.reorder, color: Colors.black54), Text(asOrdered, style: TextStyle(color: Colors.black54))]),
      ),
      RadioGroupItem(
        "shuffle",
        activeItem: AdvRow(divider: RowDivider(4.0), children: [
          Icon(Icons.shuffle, color: systemPrimaryColor),
          Text(shuffle, style: TextStyle(color: systemPrimaryColor))
        ]),
        inactiveItem: AdvRow(
            divider: RowDivider(4.0),
            children: [Icon(Icons.shuffle, color: Colors.black54), Text(shuffle, style: TextStyle(color: Colors.black54))]),
      ),
    ]);

    startDateController = AdvDatePickerController(
        label: dict.getString("start_date"), initialValue: DateTime.now(), dates: [DateTime.now(), nextMonth]);

    endDateController =
        AdvDatePickerController(label: dict.getString("end_date"), initialValue: nextMonth, dates: [DateTime.now(), nextMonth]);

    availabilityController = AdvChooserController(
        label: dict.getString("check_availability"),
        items: checkAvailabilityPeriods.keys.map((key) => GroupCheckItem(key, checkAvailabilityPeriods[key])).toList(),
        text: "never");
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    List<Widget> positionWidgets = [];

    for (int i = 0; i < positionControllers.length; i++) {
      Widget row = AdvRow(crossAxisAlignment: CrossAxisAlignment.end, divider: RowDivider(8.0), children: [
        Expanded(child: AdvTextField(controller: positionControllers[i])),
        AdvIncrement(
          measureText: "@@@@@@",
          controller: totalPositionControllers[i],
        )
      ]);

      positionWidgets.add(row);
    }

    return WillPopScope(
      onWillPop: () async {
        if (_reorderMode) {
          setState(() {
            _filteredCheckListItems = _allCheckListItems.map((item) {
              int index = _filteredCheckListItems.indexOf(item);
              if (index > 0) {
                return _filteredCheckListItems[index];
              } else {
                return item;
              }
            }).toList();
            _reorderMode = false;
          });
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(dict.getString("add_participants")),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: AdvColumn(children: [
          Expanded(
              child: SingleChildScrollView(
            child: AdvColumn(
                margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                divider: ColumnDivider(16.0),
                children: [
                  AdvChooserDialog(
                    controller: periodController,
                    itemChangeListener: (context, oldValue, newValue) {
                      setState(() {});
                    },
                  ),
                  (periodController.text == "custom") ? AdvIncrement(controller: daysController) : null,
                  AdvColumn(divider: ColumnDivider(2.0), children: [
                    AdvRow(mainAxisAlignment: MainAxisAlignment.end, divider: RowDivider(8.0), children: [
                      Expanded(
                        child: Text(
                          dict.getString("position"),
                          style: labelStyle,
                        ),
                      ),
                      InkWell(
                        child: Text(dict.getString("add_position"), style: labelStyle.copyWith(color: systemHyperlinkColor)),
                        onTap: () {
                          setState(() {
                            positionControllers.add(_defaultPositionController());
                            totalPositionControllers.add(_defaultTotalPositionController());
                          });
                        },
                      )
                    ]),
                    AdvColumn(divider: ColumnDivider(8.0), children: positionWidgets),
                  ]),
                  AdvColumn(divider: ColumnDivider(2.0), crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                        child: Text(
                      dict.getString("generate_participant_schedule_method"),
                      style: labelStyle,
                    )),
                    AdvRadioGroup(divider: 16.0, controller: methodController),
                  ]),
                  AdvRow(
                    divider: RowDivider(8.0),
                    children: <Widget>[
                      Expanded(
                        child: AdvDatePicker(
                          selectionType: SelectionType.range,
                          controller: startDateController,
                          onChanged: (dates) {
                            if (dates != null)
                              setState(() {
                                startDateController.initialValue = dates.first;
                                endDateController.initialValue = dates.last;
                                startDateController.dates = dates;
                                endDateController.dates = dates;
                              });
                          },
                        ),
                      ),
                      Expanded(
                        child: AdvDatePicker(
                          selectionType: SelectionType.range,
                          controller: endDateController,
                          onChanged: (dates) {
                            if (dates != null)
                              setState(() {
                                startDateController.initialValue = dates.first;
                                endDateController.initialValue = dates.last;
                                startDateController.dates = dates;
                                endDateController.dates = dates;
                              });
                          },
                        ),
                      ),
                    ],
                  ),
                  AdvChooserDialog(
                    controller: availabilityController,
                    itemChangeListener: (context, oldValue, newValue) {
                      setState(() {});
                    },
                  ),
                ]),
          )),
          Container(
              margin: EdgeInsets.all(18.0),
              child: AdvButton(
                dict.getString("next"),
                width: double.infinity,
                onPressed: () {
                  List<DateTime> dates = Backend.getDates(
                    eventPeriod: periodController.text,
                    customDaysInterval: daysController.counter,
                    startDate: startDateController.initialValue,
                    endDate: endDateController.initialValue,
                  );
//                  String name,
//                      String description,
//                  String location,
//                  String startTime,
//                  String endTime,
//                  String type,
//                  List<Position> positions,
//                  bool shuffle,
//                  List<Availability> availabilities,
//                  List<DateTime> dates,

                  List<Availability> availabilities = [];
                  print("dates[${dates.length}] => $dates");

                  List<Position> positions = [];

                  for (int i = 0; i < positionControllers.length; i++) {
                    String name = positionControllers[i].text;
                    int qty = totalPositionControllers[i].counter;

                    positions.add(Position(name: name, qty: qty));
                  }

                  Routing.push(
                      context,
                      AddEventPositionSettingPage(
                        name: widget.name,
                        description: widget.description,
                        location: widget.location,
                        startTime: widget.startTime,
                        endTime: widget.endTime,
                        type: widget.type,
                        positions: positions,
                        shuffle: methodController.checkedValue == "shuffle",
                        availabilities: availabilities,
                        dates: dates,
                        participants: widget.participants,
                      ));
//                  Backend.generateSchedule(
//                    name: widget.name,
//                    description: widget.description,
//                    location: widget.location,
//                    startTime: widget.startTime,
//                    endTime: widget.endTime,
//                    type: widget.type,
//                    eventPeriod: periodController.text,
//                    customDaysInterval: daysController.counter,
////                    positions: positionControllers,
//                    shuffle: methodController.checkedValue == "shuffle",
////                    List<Availability> availabilities,
//                    startDate: startDateController.initialValue,
//                    endDate: endDateController.initialValue,
//                  );
                },
              ))
        ]),
      ),
    );
  }

  _defaultPositionController() {
    return AdvTextFieldController();
  }

  _defaultTotalPositionController() {
    return AdvIncrementController(counter: 1, minCounter: 1, maxCounter: 10);
  }
}

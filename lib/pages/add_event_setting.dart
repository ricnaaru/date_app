import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/pages/add_event_position_setting.dart';
import 'package:date_app/pages/open_discussion.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
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
  final List<dynamic> participants;

  AddEventSettingPage(this.participants);

  @override
  State<StatefulWidget> createState() => _AddEventSettingPageState();
}

class _AddEventSettingPageState extends AdvState<AddEventSettingPage> {
  List<CheckListItem> _allCheckListItems;
  List<CheckListItem> _filteredCheckListItems;
  bool _reorderMode = false;
  bool ascOrder = false;
  AdvIncrementController daysController;
  AdvChooserController intervalController;
  List<AdvTextFieldController> positionControllers;
  List<AdvIncrementController> totalPositionControllers;
  AdvRadioGroupController methodController;
  AdvDatePickerController untilDateController;
  AdvChooserController availabilityController;
  TextStyle labelStyle = PitComponents.getLabelTextStyle();

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);
    Map<String, String> intervalTypes = dict.getMap("interval_type");
    Map<String, String> checkAvailabilityPeriods = dict.getMap("check_availability");

    String asOrdered = dict.getString("as_ordered");
    String shuffle = dict.getString("shuffle");
    DateTime nextMonth = DateTime.now().add(Duration(days: 30));

    intervalController = AdvChooserController(
      label: dict.getString("interval_type"),
      text: "once",
      items: intervalTypes.keys.map((key) => GroupCheckItem(key, intervalTypes[key])).toList(),
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
    untilDateController =
        AdvDatePickerController(label: dict.getString("until_date"), initialValue: nextMonth, dates: [nextMonth]);

    availabilityController = AdvChooserController(
        label: dict.getString("check_availability"),
        items: checkAvailabilityPeriods.keys.map((key) => GroupCheckItem(key, checkAvailabilityPeriods[key])).toList(),
        text: "never");
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    List<Widget> positions = [];

    for (int i = 0; i < positionControllers.length; i++) {
      Widget row = AdvRow(crossAxisAlignment: CrossAxisAlignment.end, divider: RowDivider(8.0), children: [
        Expanded(child: AdvTextField(controller: positionControllers[i])),
        AdvIncrement(
          measureText: "@@@@@@",
          controller: totalPositionControllers[i],
        )
      ]);

      positions.add(row);
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
                    controller: intervalController,
                    itemChangeListener: (context, oldValue, newValue) {
                      setState(() {});
                    },
                  ),
                  (intervalController.text == "custom") ? AdvIncrement(controller: daysController) : null,
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
                    AdvColumn(divider: ColumnDivider(8.0), children: positions),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                            color: Colors.white,
                            child: InkWell(
                                onTap: () {
                                  List<String> positions = [];

                                  positionControllers.forEach((controller) {
                                    positions.add(controller.text);
                                  });

                                  Routing.push(context, AddEventPositionSettingPage(positions, widget.participants));
                                },
                                child: Text(dict.getString("position_qualification_setting"),
                                    style: labelStyle.copyWith(color: systemHyperlinkColor))))),
                  ]),
                  AdvColumn(divider: ColumnDivider(2.0), crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                        child: Text(
                      dict.getString("generate_participant_schedule_method"),
                      style: labelStyle,
                    )),
                    AdvRadioGroup(divider: 16.0, controller: methodController),
                  ]),
                  AdvDatePicker(
                    controller: untilDateController,
                    onChanged: (dates) {
                      if (dates != null)
                        setState(() {
                          untilDateController.initialValue = dates.first;
                        });
                    },
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
                dict.getString("generate"),
                width: double.infinity,
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

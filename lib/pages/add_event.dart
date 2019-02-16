import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/pages/add_event_participant.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class AddEventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddEventPageState();
}

class _AddEventPageState extends AdvState<AddEventPage>
    with TickerProviderStateMixin {
  AdvTextFieldController nameController;
  AdvTextFieldController descController;
  AdvTextFieldController fromTimeController;
  AdvTextFieldController toTimeController;
  AdvTextFieldController locationController;
  AdvChooserController typeController;
  AnimationController fadeAnimCtrl;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);

    nameController = AdvTextFieldController(
        label: dict.getString("name"), hint: dict.getString("input_name"));

    descController = AdvTextFieldController(
        label: dict.getString("description"),
        hint: dict.getString("input_description"));

    fromTimeController = AdvTextFieldController(
        label: dict.getString("from"), hint: dict.getString("time_hint"),
      text: "9:00 AM",);

    toTimeController = AdvTextFieldController(
      label: dict.getString("to"),
      hint: dict.getString("time_hint"),
      text: "9:00 AM",
    );

    locationController = AdvTextFieldController(
        label: dict.getString("location"),
        hint: dict.getString("input_location"));

    typeController = AdvChooserController(
      text: "personal",
      label: dict.getString("type"),
      items: [
        GroupCheckItem("holiday", dict.getString("holiday")),
        GroupCheckItem("jpcc", "JPCC"),
        GroupCheckItem("date", "DATE"),
        GroupCheckItem("birthday", dict.getString("birthday")),
        GroupCheckItem("group", dict.getString("group")),
        GroupCheckItem("personal", dict.getString("personal")),
      ],
    );

    fadeAnimCtrl =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(dict.getString("add_event")),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: SingleChildScrollView(
            child: AdvColumn(
                margin: EdgeInsets.symmetric(horizontal: 8.0)
                    .copyWith(top: 16.0, bottom: 8.0),
                crossAxisAlignment: CrossAxisAlignment.start,
                divider: ColumnDivider(16.0),
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AdvTextField(controller: nameController),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AdvTextField(controller: descController),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AdvTextField(controller: locationController),
                  ),
                  AdvRow(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      divider: RowDivider(8.0),
                      children: [
                        Expanded(
                          child: InkWell(
                            child: IgnorePointer(
                              ignoring: true,
                              child:
                                  AdvTextField(controller: fromTimeController),
                            ),
                            onTap: () async {
                              TimeOfDay result = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: 0, minute: 0));

                              if (result != null) {
                                fromTimeController.text =
                                    result.format(context);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: IgnorePointer(
                              ignoring: true,
                              child: AdvTextField(controller: toTimeController),
                            ),
                            onTap: () async {
                              TimeOfDay result = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: 0, minute: 0));

                              if (result != null) {
                                toTimeController.text = result.format(context);
                              }
                            },
                          ),
                        )
                      ]),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: AdvChooserDialog(controller: typeController),
                  ),
                ]),
          ),
        ),
        Container(
          child: AdvButton(
            dict.getString("next"),
            width: double.infinity,
            onPressed: () {
              Routing.push(context, AddEventParticipantPage());
            },
          ),
          margin: EdgeInsets.all(16.0),
        )
      ]),
    );
  }
}

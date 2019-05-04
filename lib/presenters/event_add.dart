import 'package:date_app/models.dart';
import 'package:date_app/pages/event_add_participant.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class EventAddPresenter extends Presenter {
  AdvTextFieldController nameController;
  AdvTextFieldController descController;
  AdvTextFieldController fromTimeController;
  AdvTextFieldController toTimeController;
  AdvTextFieldController locationController;
  AdvChooserController categoryController;

  EventAddPresenter(BuildContext context, View<StatefulWidget> view) : super(context, view);

  @override
  void init() {
    DateDict dict = DateDict.of(context);

    nameController =
        AdvTextFieldController(label: dict.getString("name"), hint: dict.getString("input_name"));

    descController = AdvTextFieldController(
        label: dict.getString("description"), hint: dict.getString("input_description"));

    fromTimeController = AdvTextFieldController(
      label: dict.getString("from"),
      hint: dict.getString("time_hint"),
      text: "9:00 AM",
    );

    toTimeController = AdvTextFieldController(
      label: dict.getString("to"),
      hint: dict.getString("time_hint"),
      text: "9:00 AM",
    );

    locationController = AdvTextFieldController(
        label: dict.getString("location"), hint: dict.getString("input_location"));

    categoryController = AdvChooserController(
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
  }

  void pickStartTime() async {
    TimeOfDay result =
        await showTimePicker(context: context, initialTime: TimeOfDay(hour: 0, minute: 0));

    if (result != null) {
      fromTimeController.text = result.format(context);
    }
  }

  void pickEndTime() async {
    TimeOfDay result =
        await showTimePicker(context: context, initialTime: TimeOfDay(hour: 0, minute: 0));

    if (result != null) {
      toTimeController.text = result.format(context);
    }
  }

  void nextPage() {
    DateFormat timeParser = dict.getDateFormat("h:mm a");
    EventModel eventModel = EventModel(
      name: nameController.text,
      description: descController.text,
      startTime: TimeOfDay.fromDateTime(timeParser.parse(fromTimeController.text)),
      endTime: TimeOfDay.fromDateTime(timeParser.parse(toTimeController.text)),
      location: locationController.text,
      category: eventCategoryMap[categoryController.text],
    );

    Routing.push(context, EventAddParticipantPage(event: eventModel));
  }
}

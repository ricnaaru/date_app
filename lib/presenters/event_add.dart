import 'package:date_app/application.dart';
import 'package:date_app/components/toast.dart';
import 'package:date_app/models.dart';
import 'package:date_app/pages/event_add_participant.dart';
import 'package:date_app/pages/event_position.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/datetime_helper.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/utilities/string_helper.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_app/utilities/pref_keys.dart' as prefKeys;

class EventAddPresenter extends Presenter {
  AdvTextFieldController nameController;
  AdvTextFieldController descController;
  AdvTextFieldController fromTimeController;
  AdvTextFieldController toTimeController;
  AdvTextFieldController locationController;
  AdvChooserController categoryController;
  AdvDatePickerController startDateController;
  AdvDatePickerController endDateController;
  AdvIncrementController daysController;
  AdvChooserController periodController;
  AdvDatePickerController lastGenerateDateController;
  DateTime _date;

  EventAddPresenter(BuildContext context, View<StatefulWidget> view, DateTime date)
      : this._date = date,
        super(context, view);

  @override
  void init() {
    Map<String, String> eventPeriods = dict.getMap("interval_type");

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
        GroupCheckItem("jpcc", "JPCC"),
        GroupCheckItem("date", "DATE"),
        GroupCheckItem("group", dict.getString("group")),
        GroupCheckItem("personal", dict.getString("personal")),
      ],
    );

    startDateController = AdvDatePickerController(
        label: dict.getString("start_date"),
        initialValue: _date,
        dates: [_date, _date.add(Duration(days: 7))]);

    endDateController = AdvDatePickerController(
        label: dict.getString("end_date"),
        initialValue: _date.add(Duration(days: 7)),
        dates: [_date, _date.add(Duration(days: 7))]);

    periodController = AdvChooserController(
      label: dict.getString("interval_type"),
      text: "once",
      items: eventPeriods.keys.map((key) => GroupCheckItem(key, eventPeriods[key])).toList(),
    );
    daysController = AdvIncrementController(
      label: dict.getString("days_interval"),
      minCounter: 1,
      maxCounter: 365,
    );

    lastGenerateDateController = AdvDatePickerController(
        label: dict.getString("last_generate_date"),
        initialValue: _date.add(Duration(days: 30)),
        dates: [_date.add(Duration(days: 30))]);
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
    view.process(() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String userId = pref.getString(prefKeys.kUserId);

      EventSettingModel eventModel = EventSettingModel(
          customDays: daysController.counter,
          interval: intervalTypeMap[StringHelper.capitalizeFirstLetter(periodController.text)],
          name: nameController.text,
          description: descController.text,
          startTime: DateTimeHelper.convertFromFirebaseTime(fromTimeController.text),
          endTime: DateTimeHelper.convertFromFirebaseTime(toTimeController.text),
          location: locationController.text,
          category: eventCategoryMap[StringHelper.capitalizeFirstLetter(categoryController.text)],
          eventMaster: userId,
          eventStatus: EventStatus.waiting,
          startDate: startDateController.initialValue,
          endDate: endDateController.initialValue,
          lastGenerateDate: lastGenerateDateController.initialValue);

      if (eventModel.category == EventCategory.personal) {
        submit(eventModel);
      } else {
        Routing.push(context, EventAddParticipantPage(event: eventModel));
      }
    });
  }

  void onDatePicked(List<DateTime> dates) {
    if (dates != null) {
      startDateController.initialValue = dates.first;
      endDateController.initialValue = dates.last;
      startDateController.dates = dates;
      endDateController.dates = dates;

      view.refresh();
    }
  }

  void onLastGenerateDatePicked(List<DateTime> dates) {
    if (dates != null) {
      lastGenerateDateController.initialValue = dates.first;

      view.refresh();
    }
  }

//  once, daily, weekly, monthly, annual, custom
  void submit(EventSettingModel eventSetting) {
    int durationInterval = eventSetting.endDate.difference(eventSetting.startDate).inDays;
    int daysInterval = eventSetting.interval == IntervalType.daily
        ? 1
        : eventSetting.interval == IntervalType.weekly
            ? 7
            : eventSetting.interval == IntervalType.monthly
                ? 28
                : eventSetting.interval == IntervalType.annual
                    ? 365
                    : eventSetting.interval == IntervalType.custom ? eventSetting.customDays : 0;

    if (daysInterval > 0) {
      if (durationInterval >= daysInterval) {
        Toast.showToast(context, dict.getString("err_duration_and_interval_overlap"), duration: Duration(seconds: 3));
        return;
      }
    }

    if (eventSetting.startDate.isAfter(eventSetting.lastGenerateDate)) {
      Toast.showToast(context, dict.getString("err_last_generate_before_start"), duration: Duration(seconds: 3));
      return;
    }

    view.process(() async {
      String key = await DataEngine.postEventSetting(eventSetting);

      eventSetting = eventSetting.copyWith(id: key);

      print("eventSetting.id => ${eventSetting.id}");
      print("result => ${await DataEngine.generatePersonalEvent(eventSetting)}");

      application.homeInterface.resetEvents();

      Navigator.popUntil(context, ModalRoute.withName("/"));

      Toast.showToast(context, dict.getString("event_added"));
    });
  }
}

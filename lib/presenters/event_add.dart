import 'package:date_app/application.dart';
import 'package:date_app/components/toast.dart';
import 'package:date_app/models.dart';
import 'package:date_app/pages/event_add_participant.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/datetime_helper.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/pref_keys.dart' as prefKeys;
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
  EventSettingModel _eventModel;

  EventAddPresenter(BuildContext context, View<StatefulWidget> view, EventSettingModel eventModel)
      : this._eventModel = eventModel,
        super(context, view);

  @override
  void init() {
    Map<String, String> eventPeriods = dict.getMap("interval_type");

    nameController = AdvTextFieldController(
      label: dict.getString("name"),
      hint: dict.getString("input_name"),
      text: _eventModel.name,
    );

    descController = AdvTextFieldController(
      label: dict.getString("description"),
      hint: dict.getString("input_description"),
      text: _eventModel.description,
    );

    fromTimeController = AdvTextFieldController(
      label: dict.getString("from"),
      hint: dict.getString("time_hint"),
      text: _eventModel.startTime == null ? "9:00 AM" : _eventModel.startTime.format(context),
    );

    toTimeController = AdvTextFieldController(
      label: dict.getString("to"),
      hint: dict.getString("time_hint"),
      text: _eventModel.endTime == null ? "9:00 AM" : _eventModel.endTime.format(context),
    );

    locationController = AdvTextFieldController(
      label: dict.getString("location"),
      hint: dict.getString("input_location"),
      text: _eventModel.location,
    );

    categoryController = AdvChooserController(
      text: _eventModel.category == null
          ? "personal"
          : eventCategoryMap.keys
              .firstWhere((k) => eventCategoryMap[k] == _eventModel.category, orElse: () => null)
              .toLowerCase(),
      label: dict.getString("category"),
      items: [
        GroupCheckItem("jpcc", "JPCC"),
        GroupCheckItem("date", "DATE"),
        GroupCheckItem("group", dict.getString("group")),
        GroupCheckItem("personal", dict.getString("personal")),
      ],
    );

    startDateController = AdvDatePickerController(
        label: dict.getString("start_date"),
        initialValue: _eventModel.startDate,
        dates: [_eventModel.startDate, _eventModel.endDate]);

    endDateController = AdvDatePickerController(
      label: dict.getString("end_date"),
      initialValue: _eventModel.endDate,
      dates: [_eventModel.startDate, _eventModel.endDate],
      enable: !(_eventModel.oneDayEvent ?? false),
    );

    periodController = AdvChooserController(
      label: dict.getString("interval_type"),
      text: _eventModel.interval == null
          ? "once"
          : intervalTypeMap.keys
              .firstWhere((k) => intervalTypeMap[k] == _eventModel.interval, orElse: () => null)
              .toLowerCase(),
      items: eventPeriods.keys.map((key) => GroupCheckItem(key, eventPeriods[key])).toList(),
    );

    daysController = AdvIncrementController(
      label: dict.getString("days_interval"),
      minCounter: 1,
      maxCounter: 365,
    );

    lastGenerateDateController = AdvDatePickerController(
      label: dict.getString("last_generate_date"),
      initialValue: _eventModel.lastGenerateDate,
      dates: _eventModel.lastGenerateDate == null ? null : [_eventModel.lastGenerateDate],
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

  void nextPage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(prefKeys.kUserId);

    EventSettingModel eventSetting = EventSettingModel(
        id: _eventModel.id,
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
        oneDayEvent: !endDateController.enable,
        lastGenerateDate: lastGenerateDateController.initialValue);

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

    if ((eventSetting.name ?? "").isEmpty) {
      Toast.showToast(context, dict.getString("err_event_name_empty"),
          duration: Duration(seconds: 3));
      return;
    }

    if (daysInterval > 0) {
      if (durationInterval >= daysInterval) {
        Toast.showToast(context, dict.getString("err_duration_and_interval_overlap"),
            duration: Duration(seconds: 3));
        return;
      }
    }

    if (eventSetting.lastGenerateDate != null &&
        eventSetting.startDate.isAfter(eventSetting.lastGenerateDate)) {
      Toast.showToast(context, dict.getString("err_last_generate_before_start"),
          duration: Duration(seconds: 3));
      return;
    }

    if (eventSetting.category == EventCategory.personal) {
      if ((eventSetting.id ?? "").isNotEmpty) {
      bool confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(dict.getString("confirmation")),
            content: Text(dict.getString("confirm_edit_event_setting")),
            actions: <Widget>[
              FlatButton(
                child: Text(dict.getString("no")),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              FlatButton(
                child: Text(dict.getString("yes")),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );

      if (!confirmed) return;
      }

      view.process(() async {
          await submit(eventSetting);

          await application.homeInterface.resetEvents();
          await application.homeInterface.resetMyEvents();

          Navigator.popUntil(context, ModalRoute.withName("/"));

          Toast.showToast(context, dict.getString("event_added"));
      });
    } else {
      Routing.push(context, EventAddParticipantPage(event: eventSetting));
    }
  }

  void onDatePicked(List<DateTime> dates) {
    if (dates != null) {
      startDateController.initialValue = dates.first;
      startDateController.dates = dates;
      endDateController.initialValue = dates.last;
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
  Future<void> submit(EventSettingModel eventSetting) async {
    if ((eventSetting.id ?? "").isNotEmpty) {
      await DataEngine.deleteEventSetting(eventSetting.id);
    }

    String key = await DataEngine.postEventSetting(eventSetting);

    eventSetting = eventSetting.copyWith(id: key);

    await DataEngine.generatePersonalEvent(eventSetting);
  }

  static EventSettingModel constructModel(DateTime date) {
    return EventSettingModel(startDate: date, endDate: date.add(Duration(days: 7)));
  }

  void onPeriodChanged(BuildContext context, String oldValue, String newValue) {
    if (oldValue != "once" && newValue == "once") {
      lastGenerateDateController.initialValue = null;
      lastGenerateDateController.dates = null;
      _eventModel = _eventModel.copyWith(lastGenerateDate: null);
    }

    view.refresh();
  }

  void onEndDateToggled(bool value) {
    DateTime defaultDate = startDateController.dates?.first ?? DateTime.now();

    if (!value) {
      startDateController.dates = [defaultDate];
      endDateController.dates = [defaultDate];
      endDateController.initialValue = defaultDate;
    } else {
      startDateController.dates = [defaultDate, defaultDate];
      endDateController.dates = [defaultDate, defaultDate];
    }
    view.refresh();
  }
}

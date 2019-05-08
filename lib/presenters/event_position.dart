import 'package:date_app/application.dart';
import 'package:date_app/components/toast.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class EventPositionPresenter extends Presenter {
  EventSettingModel _event;
  List<AdvTextFieldController> positionControllers;
  List<AdvIncrementController> totalPositionControllers;

  EventPositionPresenter(BuildContext context, View<StatefulWidget> view, {EventSettingModel event})
      : this._event = event,
        super(context, view);

  @override
  void init() {
    positionControllers = [_defaultPositionController()];
    totalPositionControllers = [_defaultTotalPositionController()];
  }

  _defaultPositionController() {
    return AdvTextFieldController();
  }

  _defaultTotalPositionController() {
    return AdvIncrementController(counter: 1, minCounter: 1, maxCounter: 10);
  }

  void addPosition() {
    positionControllers.add(_defaultPositionController());
    totalPositionControllers.add(_defaultTotalPositionController());

    view.refresh();
  }

  void submit() {
    view.process(() async {
      List<PositionModel> positions = [];

      for (int i = 0; i < positionControllers.length; i++) {
        positions.add(PositionModel(
          qty: totalPositionControllers[i].counter,
          name: positionControllers[i].text,
        ));
      }

      _event = _event.copyWith(
        positions: positions,
      );

      await DataEngine.postEventSetting(_event);

      application.homeInterface.resetEvents();

      Navigator.popUntil(context, ModalRoute.withName("/"));

      Toast.showToast(context, dict.getString("event_added"));
    });
//                List<DateTime> dates = Backend.getDates(
//                  eventPeriod: periodController.text,
//                  customDaysInterval: daysController.counter,
//                  startDate: startDateController.initialValue,
//                  endDate: endDateController.initialValue,
//                );
////                  String name,
////                      String description,
////                  String location,
////                  String startTime,
////                  String endTime,
////                  String type,
////                  List<Position> positions,
////                  bool shuffle,
////                  List<Availability> availabilities,
////                  List<DateTime> dates,
//
//                List<Availability> availabilities = [];
//
//                for (int i = 0; i < widget.participants.length; i++) {
//                  Participant participant = widget.participants[i];
//                  List<DateTime> selectedDates = await showDialog(
//                      context: context,
//                      builder: (BuildContext context) {
//                        return AvailabilityDialog(participant.name, dates);
//                      });
//
//                  if (selectedDates == null) return;
//
//                  availabilities.add(Availability(id: "$i", participant: participant, availableDates: selectedDates));
//                }
//                print("dates[${dates.length}] => $dates");
//
//                List<Position> positions = [];
//
//                for (int i = 0; i < positionControllers.length; i++) {
//                  String name = positionControllers[i].text;
//                  int qty = totalPositionControllers[i].counter;
//
//                  positions.add(Position(id: "$i", name: name, qty: qty));
//                }
//
//                Routing.push(
//                    context,
//                    AddEventPositionSettingPage(
//                      name: widget.name,
//                      description: widget.description,
//                      location: widget.location,
//                      startTime: widget.startTime,
//                      endTime: widget.endTime,
//                      type: widget.type,
//                      positions: positions,
//                      shuffle: methodController.checkedValue == "shuffle",
//                      availabilities: availabilities,
//                      dates: dates,
//                      participants: widget.participants,
//                    ));
////                  Backend.generateSchedule(
////                    name: widget.name,
////                    description: widget.description,
////                    location: widget.location,
////                    startTime: widget.startTime,
////                    endTime: widget.endTime,
////                    type: widget.type,
////                    eventPeriod: periodController.text,
////                    customDaysInterval: daysController.counter,
//////                    positions: positionControllers,
////                    shuffle: methodController.checkedValue == "shuffle",
//////                    List<Availability> availabilities,
////                    startDate: startDateController.initialValue,
////                    endDate: endDateController.initialValue,
////                  );
  }
}

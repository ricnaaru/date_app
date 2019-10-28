import 'package:date_app/application.dart';
import 'package:date_app/components/mini_checkbox.dart';
import 'package:date_app/components/toast.dart';
import 'package:date_app/models.dart';
import 'package:date_app/pages/event_add_position.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_checkbox.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/components/extras/roundrect_checkbox.dart';

class EventPositionPresenter extends Presenter {
  EventSettingModel _event;

  EventPositionPresenter(BuildContext context, View<StatefulWidget> view, {EventSettingModel event})
      : this._event = event.copyWith(positions: []),
        super(context, view);

  @override
  void init() {

  }

  void addPosition() async {
    int participantQty = _event.participants.length;

    PositionModel newPosition = await Routing.push(context, EventAddPositionPage(positions: _event.positions, participantQty: participantQty));

    if (newPosition != null) {
      _event.positions.add(newPosition);
    }

    view.refresh();
  }

  EventSettingModel get event => _event;

  void submit() async {
    if ((_event.id ?? "").isNotEmpty) {
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
      if ((_event.id ?? "").isNotEmpty) {
        await DataEngine.deleteEventSetting(_event.id);
      }
//      RoundRectCheckbox(onChanged: (bool value) {}, value: null,);
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

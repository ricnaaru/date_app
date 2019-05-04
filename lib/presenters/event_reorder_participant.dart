import 'package:date_app/models.dart';
import 'package:date_app/pages/event_reorder_participant.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_radio_button.dart';
import 'package:pit_components/components/adv_row.dart';

class EventReorderParticipantPresenter extends Presenter {
  EventModel _event;
  bool _ascOrder = true;

  EventReorderParticipantPresenter(BuildContext context, View<StatefulWidget> view, {EventModel event})
      : this._event = event,
        super(context, view);

  @override
  void init() {
  }

  void shuffleParticipants() {
    _event.participants.shuffle();

    view.refresh();
  }

  String getSortAction() {
    return dict.getString(_ascOrder ? "sort_z_a" : "sort_a_z");
  }

  void sortParticipants() {
    if (_ascOrder) {
      _event.participants
          .sort((item, otherItem) => otherItem.name.compareTo(item.name));
    } else {
      _event.participants
          .sort((item, otherItem) => item.name.compareTo(otherItem.name));
    }

    _ascOrder = !_ascOrder;

    view.refresh();
  }

  void reorderParticipants(int before, int after) {
    var data = _event.participants[before];
    _event.participants.removeAt(before);
    _event.participants.insert(after, data);
  }

  void nextPage() {
//            Routing.push(
//                context,
//                AddEventSettingPage(
//                  widget.selectedMember,
//                  name: widget.name,
//                  description: widget.description,
//                  location: widget.location,
//                  startTime: widget.startTime,
//                  endTime: widget.endTime,
//                  type: widget.type,
//                ));
  }
}

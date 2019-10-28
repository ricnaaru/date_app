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

class EventAddPositionPresenter extends Presenter {
  AdvTextFieldController nameController;
  AdvTextFieldController codeController;
  AdvTextFieldController descController;
  AdvIncrementController qtyController;
  List<PositionModel> positions;
  int participantQty;

  EventAddPositionPresenter(
      BuildContext context, View<StatefulWidget> view, this.positions, this.participantQty)
      : super(context, view);

  @override
  void init() {
    nameController =
        AdvTextFieldController(label: dict.getString("name"), hint: dict.getString("input_name"));
    codeController = AdvTextFieldController(
        label: dict.getString("code"),
        hint: dict.getString("input_code"),
        maxLength: 2,
        maxLengthEnforced: true);

    descController = AdvTextFieldController(
        label: dict.getString("description"), hint: dict.getString("input_description"));
    qtyController = AdvIncrementController(
      label: dict.getString("qty"),
      minCounter: 1,
      maxCounter: participantQty,
      counter: 1
    );
  }

  void submit() {
    if ((nameController.text ?? "").isEmpty) {
      nameController.error = dict.getString("err_position_name_empty");
      return;
    }

    if ((codeController.text ?? "").isEmpty) {
      codeController.error = dict.getString("err_position_code_empty");
      return;
    }

    for (PositionModel position in positions) {
      if (position.code.toUpperCase() == codeController.text.toUpperCase()) {
        codeController.error = dict.getString("err_position_code_duplicate");
        return;
      }
    }

    PositionModel positionModel = PositionModel(
      qty: qtyController.counter,
      name: nameController.text,
      code: codeController.text.toUpperCase(),
      description: descController.text,
    );

    Navigator.pop(context, positionModel);
  }
}

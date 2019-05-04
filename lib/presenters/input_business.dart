import 'package:date_app/models.dart';
import 'package:date_app/presenter.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class InputBusinessPresenter extends Presenter {
  AdvTextFieldController _businessNameCtrl;
  AdvTextFieldController _businessDescriptionCtrl;
  AdvTextFieldController _businessAddressCtrl;
  AdvDatePickerController _openSinceCtrl;
  BusinessModel _business;

  InputBusinessPresenter(BuildContext context) : super(context, null);

  @override
  void init() {
    _businessNameCtrl = AdvTextFieldController(label: dict.getString("business_name"), maxLines: 1);
    _businessDescriptionCtrl =
        AdvTextFieldController(label: dict.getString("business_description"));
    _businessAddressCtrl = AdvTextFieldController(label: dict.getString("business_address"));
    _openSinceCtrl = AdvDatePickerController(label: dict.getString("open_since"));
  }

  BusinessModel saveData() {
    _business = BusinessModel(
      businessName: _businessNameCtrl.text ?? "",
      businessAddress: _businessAddressCtrl.text ?? "",
      businessDescription: _businessDescriptionCtrl.text ?? "",
      since: _openSinceCtrl.dates.length == 0 ? null : _openSinceCtrl.dates.first,
    );

    return _business;
  }

  AdvTextFieldController get businessNameCtrl => _businessNameCtrl;

  AdvTextFieldController get businessDescriptionCtrl => _businessDescriptionCtrl;

  AdvTextFieldController get businessAddressCtrl => _businessAddressCtrl;

  AdvDatePickerController get openSinceCtrl => _openSinceCtrl;

  void onOpenDateChanged(List<DateTime> value) {
    if (value != null && value.length > 0) _openSinceCtrl.initialValue = value.first;
  }
}

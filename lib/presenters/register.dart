import 'package:date_app/components/sequence.dart';
import 'package:date_app/models.dart';
import 'package:date_app/pages/input_business_dialog.dart';
import 'package:date_app/pages/input_college_dialog.dart';
import 'package:date_app/pages/input_job_dialog.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

abstract class RegisterInterface {
  void onPageCompleted(int index);

  void onOccupationsAdded();

  void onSequenceCompleted();
}

class RegisterPresenter extends Presenter {
  RegisterInterface _interface;

  /// Personal
  AdvTextFieldController _nameCtrl;
  AdvDatePickerController _dateOfBirthCtrl;
  AdvChooserController _maritalStatusCtrl;
  AdvTextFieldController _addressCtrl;
  AdvTextFieldController _emailCtrl;
  AdvTextFieldController _phoneNumberCtrl;
  bool showBirthday = true;

  SequenceController _sequenceController = SequenceController(selectedIndex: 0);

  /// Additional
  List<OccupationModel> occupations = [];
  String college;
  String job;
  String business;

  /// Church
  bool haveBeenBaptized = false;
  AdvTextFieldController _baptismChurchCtrl;
  AdvDatePickerController _baptismDateCtrl;
  AdvDatePickerController _joinJpccSinceCtrl;
  Map<String, bool> classes = {
    "Partner's Day": false,
    "Community of Believer": false,
    "Community of Leader": false,
    "Community of Councelor": false,
    "Deeper Bible": false,
    "Updating": false,
    "Preparing Together": false
  };

  /// Account
  AdvTextFieldController _usernameCtrl;
  AdvTextFieldController _passwordCtrl;

  View _additionalView;

  set additionalView(View value) {
    _additionalView = value;
  }

  RegisterPresenter(BuildContext context, View<StatefulWidget> view, {RegisterInterface interface})
      : this._interface = interface,
        super(context, view);

  @override
  void init() {
    Map<String, String> maritalStatus = dict.getMap("marital_status");
    List<GroupCheckItem> maritalStatusItems = [];

    maritalStatus.forEach((key, value) {
      maritalStatusItems.add(GroupCheckItem(key, value));
    });

    /// Personal
    _nameCtrl = AdvTextFieldController(label: dict.getString("name"), maxLines: 1);
    _dateOfBirthCtrl = AdvDatePickerController(label: dict.getString("date_of_birth"));
    _maritalStatusCtrl =
        AdvChooserController(label: dict.getString("marital_status"), items: maritalStatusItems);
    _addressCtrl = AdvTextFieldController(label: dict.getString("address"));
    _emailCtrl = AdvTextFieldController(label: dict.getString("email"), maxLines: 1);
    _phoneNumberCtrl = AdvTextFieldController(label: dict.getString("phone_number"), maxLines: 1);

    /// Additional
    college = dict.getString("college");
    job = dict.getString("job");
    business = dict.getString("business");

    /// Church
    _baptismChurchCtrl =
        AdvTextFieldController(label: dict.getString("baptism_church"), maxLines: 1);
    _baptismDateCtrl = AdvDatePickerController(label: dict.getString("baptism_date"));
    _joinJpccSinceCtrl = AdvDatePickerController(label: dict.getString("join_jpcc_since"));

    /// Account
    _usernameCtrl = AdvTextFieldController(label: dict.getString("username"), maxLines: 1);
    _passwordCtrl = AdvTextFieldController(label: dict.getString("password"), maxLines: 1);
  }

  AdvChooserController get maritalStatusCtrl => _maritalStatusCtrl;

  AdvDatePickerController get baptismDateCtrl => _baptismDateCtrl;

  AdvDatePickerController get dateOfBirthCtrl => _dateOfBirthCtrl;

  AdvDatePickerController get joinJpccSinceCtrl => _joinJpccSinceCtrl;

  AdvTextFieldController get nameCtrl => _nameCtrl;

  AdvTextFieldController get addressCtrl => _addressCtrl;

  AdvTextFieldController get emailCtrl => _emailCtrl;

  AdvTextFieldController get phoneNumberCtrl => _phoneNumberCtrl;

  AdvTextFieldController get baptismChurchCtrl => _baptismChurchCtrl;

  AdvTextFieldController get passwordCtrl => _passwordCtrl;

  AdvTextFieldController get usernameCtrl => _usernameCtrl;

  SequenceController get sequenceController => _sequenceController;

  Future<void> addCollegeInformation() async {
    CollegeModel collegeModel = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return InputCollegeDialog();
        });

    if (collegeModel != null) {
      occupations.add(collegeModel);
      _interface.onOccupationsAdded();
    }
  }

  Future<void> addJobInformation() async {
    JobModel jobModel = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return InputJobDialog();
        });

    if (jobModel != null) {
      occupations.add(jobModel);
      _interface.onOccupationsAdded();
    }
  }

  Future<void> addBusinessInformation() async {
    BusinessModel businessModel = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return InputBusinessDialog();
        });

    if (businessModel != null) {
      occupations.add(businessModel);
      _interface.onOccupationsAdded();
    }
  }

  void nextPage() {
    if (_validatePage()) {
      this._sequenceController.selectedIndex++;
      this._interface.onPageCompleted(this._sequenceController.selectedIndex);

      if (this._sequenceController.selectedIndex >= 4) {
        MemberModel member = MemberModel(
          name: _nameCtrl.text ?? "",
          birthday: _dateOfBirthCtrl.dates.length == 0 ? null : _dateOfBirthCtrl.dates.first,
          showBirthday: showBirthday,
          address: _addressCtrl.text ?? "",
          status: _maritalStatusCtrl.text ?? "",
          email: _emailCtrl.text ?? "",
          phoneNumber: _phoneNumberCtrl.text ?? "",
          occupations: occupations,
          haveBeenBaptized: haveBeenBaptized,
          church: _baptismChurchCtrl.text ?? "",
          dateOfBaptize: _baptismDateCtrl.dates.length == 0 ? null : _baptismDateCtrl.dates.first,
          joinJpccSince:
              _joinJpccSinceCtrl.dates.length == 0 ? null : _joinJpccSinceCtrl.dates.first,
          classHistory: classes,
          username: _usernameCtrl.text ?? "",
          password: _passwordCtrl.text ?? "",
        );

        print("before process!");

        view.process(() async {
          bool success = await DataEngine.postMember(member);

          if (success)
            _interface.onSequenceCompleted();
        });
      }
    }
  }

  void onBaptizedDateChanged(List<DateTime> value) {
    if (value != null && value.length > 0) _baptismDateCtrl.initialValue = value.first;
  }

  void onJoinJpccDateChanged(List<DateTime> value) {
    if (value != null && value.length > 0) _joinJpccSinceCtrl.initialValue = value.first;
  }

  bool _validatePage() {
    if (this._sequenceController.selectedIndex == 0) {}

    return true;
  }
}

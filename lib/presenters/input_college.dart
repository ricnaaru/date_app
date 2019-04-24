import 'package:date_app/models.dart';
import 'package:date_app/presenter.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class InputCollegePresenter extends Presenter {
  AdvTextFieldController _universityCtrl;
  AdvTextFieldController _majorCtrl;
  AdvChooserController _degreeCtrl;
  AdvIncrementController _semesterCtrl;
  AdvDatePickerController _classYearCtrl;
  CollegeModel _college;
  Map<String, String> _academicDegrees;

  InputCollegePresenter(BuildContext context) : super(context, null);

  @override
  void init() {
    _academicDegrees = dict.getMap("academic_degree");
    List<GroupCheckItem> _academicDegreeItems = [];

    _academicDegrees.forEach((key, value) {
      _academicDegreeItems.add(GroupCheckItem(key, value));
    });

    _universityCtrl = AdvTextFieldController(label: dict.getString("university"), maxLines: 1);
    _majorCtrl = AdvTextFieldController(label: dict.getString("major"), maxLines: 1);
    _degreeCtrl = AdvChooserController(label: dict.getString("degree"), items: _academicDegreeItems);
    _semesterCtrl = AdvIncrementController(label: dict.getString("semester"), minCounter: 0);
    _classYearCtrl = AdvDatePickerController(label: dict.getString("class_year"));
  }

  CollegeModel saveData() {
    _college = CollegeModel(
      university: _universityCtrl.text ?? "",
      major: _majorCtrl.text ?? "",
      degree: _degreeCtrl.text ?? "",
      semester: _semesterCtrl.counter,
      classYear: _classYearCtrl.dates.length == 0 ? null : _classYearCtrl.dates.first,
    );

    return _college;
  }

  AdvTextFieldController get universityCtrl => _universityCtrl;

  AdvTextFieldController get majorCtrl => _majorCtrl;

  AdvChooserController get degreeCtrl => _degreeCtrl;

  AdvIncrementController get semesterCtrl => _semesterCtrl;

  AdvDatePickerController get classYearCtrl => _classYearCtrl;

  void onClassYearChanged(List<DateTime> value) {
    if (value != null && value.length > 0)
    _classYearCtrl.initialValue = value.first;
  }
}

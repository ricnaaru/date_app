import 'package:date_app/models.dart';
import 'package:date_app/presenter.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class InputJobPresenter extends Presenter {
  AdvTextFieldController _companyCtrl;
  AdvTextFieldController _companyAddressCtrl;
  AdvTextFieldController _jobTitleCtrl;
  AdvTextFieldController _jobDescriptionCtrl;
  AdvDatePickerController _sinceCtrl;
  JobModel _job;

  InputJobPresenter(BuildContext context) : super(context, null);

  @override
  void init() {
    _companyCtrl = AdvTextFieldController(label: dict.getString("company"), maxLines: 1);
    _companyAddressCtrl = AdvTextFieldController(label: dict.getString("company_address"));
    _jobTitleCtrl = AdvTextFieldController(label: dict.getString("job_title"));
    _jobDescriptionCtrl = AdvTextFieldController(label: dict.getString("job_description"));
    _sinceCtrl = AdvDatePickerController(label: dict.getString("working_since"));
  }

  AdvTextFieldController get companyCtrl => _companyCtrl;

  AdvTextFieldController get companyAddressCtrl => _companyAddressCtrl;

  AdvTextFieldController get jobTitleCtrl => _jobTitleCtrl;

  AdvTextFieldController get jobDescriptionCtrl => _jobDescriptionCtrl;

  AdvDatePickerController get sinceCtrl => _sinceCtrl;

  JobModel saveData() {
    _job = JobModel(
      company: _companyCtrl.text ?? "",
      companyAddress: _companyAddressCtrl.text ?? "",
      jobTitle: _jobTitleCtrl.text ?? "",
      jobDescription: _jobDescriptionCtrl.text ?? "",
      since: _sinceCtrl.dates.length == 0 ? null : _sinceCtrl.dates.first,
    );

    return _job;
  }

  void onSinceDateChanged(List<DateTime> value) {
    if (value != null && value.length > 0)
    _sinceCtrl.initialValue = value.first;
  }
}

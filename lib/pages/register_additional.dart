import 'package:date_app/utilities/localization.dart';
import 'package:flutter/material.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_chooser.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_radio_button.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_increment_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;

class RegisterAdditional extends StatefulWidget {
  final VoidCallback onCompleted;

  RegisterAdditional({this.onCompleted});

  @override
  State<StatefulWidget> createState() => _RegisterAdditionalState();
}

class _RegisterAdditionalState extends AdvState<RegisterAdditional> {
  AdvRadioGroupController _professionCtrl;
  String _student;
  String _employee;
  String _entrepreneur;

  AdvTextFieldController _universityCtrl;
  AdvTextFieldController _majorCtrl;
  AdvIncrementController _semesterCtrl;

  AdvTextFieldController _companyCtrl;
  AdvTextFieldController _companyAddressCtrl;
  AdvTextFieldController _jobDescriptionCtrl;
  AdvTextFieldController _sinceCtrl;

  AdvTextFieldController _shopNameCtrl;
  AdvTextFieldController _shopDescriptionCtrl;
  AdvTextFieldController _shopAddressCtrl;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);
    _student = dict.getString("student");
    _employee = dict.getString("employee");
    _entrepreneur = dict.getString("entrepreneur");

    _professionCtrl = AdvRadioGroupController(checkedValue: _student, itemList: [
      RadioGroupItem(
        _student,
        activeItem: Text(_student, style: ts.h9),
        inactiveItem: Text(_student),
      ),
      RadioGroupItem(
        _employee,
        activeItem: Text(_employee, style: ts.h9),
        inactiveItem: Text(_employee),
      ),
      RadioGroupItem(
        _entrepreneur,
        activeItem: Text(_entrepreneur, style: ts.h9),
        inactiveItem: Text(_entrepreneur),
      ),
    ]);

    _universityCtrl = AdvTextFieldController(
        label: dict.getString("university"), maxLines: 1);
    _majorCtrl =
        AdvTextFieldController(label: dict.getString("major"), maxLines: 1);
    _semesterCtrl = AdvIncrementController(label: dict.getString("semester"));

    _companyCtrl =
        AdvTextFieldController(label: dict.getString("company"), maxLines: 1);
    _companyAddressCtrl =
        AdvTextFieldController(label: dict.getString("company_address"));
    _jobDescriptionCtrl =
        AdvTextFieldController(label: dict.getString("job_description"));
    _sinceCtrl = AdvTextFieldController(
        label: dict.getString("working_since"), maxLines: 1);

    _shopNameCtrl =
        AdvTextFieldController(label: dict.getString("shop_name"), maxLines: 1);
    _shopDescriptionCtrl =
        AdvTextFieldController(label: dict.getString("shop_description"));
    _shopAddressCtrl =
        AdvTextFieldController(label: dict.getString("shop_address"));
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);
    String profession = _professionCtrl.checkedValue;
    String student = dict.getString("student");
    String employee = dict.getString("employee");
    String entrepreneur = dict.getString("entrepreneur");

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 32.0)
            .copyWith(top: 0.0, bottom: 16.0),
        child: AdvColumn(
          divider: ColumnDivider(16.0),
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: AdvColumn(
                    divider: ColumnDivider(8.0),
                    children: [
                      Container(height: 40.0),
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: AdvRadioGroup(
                            divider: 8.0,
                            controller: _professionCtrl,
                            callback: (checkedValue) {
                              setState(() {});
                            },
                          )),
                      profession == student
                          ? _buildProfessionInformation(context, [
                        AdvTextField(controller: _universityCtrl),
                        AdvTextField(controller: _majorCtrl),
                        AdvIncrement(controller: _semesterCtrl),])
                          : null,
                      profession == employee
                          ? _buildProfessionInformation(context,[
                        AdvTextField(controller: _companyCtrl),
                        AdvTextField(controller: _companyAddressCtrl),
                        AdvTextField(controller: _jobDescriptionCtrl),
                        AdvTextField(controller: _sinceCtrl),
                      ])
                          : null,
                      profession == entrepreneur
                          ? _buildProfessionInformation(context,[
                        AdvTextField(controller: _shopNameCtrl),
                        AdvTextField(controller: _shopDescriptionCtrl),
                        AdvTextField(controller: _shopAddressCtrl),
                      ])
                          : null,
                    ],
                  )),
            ),
            AdvButton(
              dict.getString("next"),
              width: double.infinity,
              onPressed: () {
                if (widget.onCompleted != null) widget.onCompleted();
              },
            ),
          ],
        ));
  }

  Widget _buildProfessionInformation(BuildContext context, List<Widget> children) {
    return AdvColumn(
      divider: ColumnDivider(8.0),
      children: children,
    );
  }
}

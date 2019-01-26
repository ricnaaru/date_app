import 'package:date_app/utilities/localization.dart';
import 'package:flutter/material.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_chooser.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class RegisterPersonal extends StatefulWidget {
  final VoidCallback onCompleted;

  RegisterPersonal({this.onCompleted});

  @override
  State<StatefulWidget> createState() => _RegisterPersonalState();
}

class _RegisterPersonalState extends AdvState<RegisterPersonal> {
  AdvTextFieldController _nameCtrl;
  AdvDatePickerController _dateOfBirthCtrl;
  AdvChooserController _maritalStatusCtrl;
  AdvTextFieldController _addressCtrl;
  AdvTextFieldController _emailCtrl;
  AdvTextFieldController _phoneNumberCtrl;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);

    _nameCtrl =
        AdvTextFieldController(label: dict.getString("name"), maxLines: 1);
    _dateOfBirthCtrl =
        AdvDatePickerController(label: dict.getString("date_of_birth"));
    _maritalStatusCtrl = AdvChooserController(
        label: dict.getString("marital_status"),
        items: dict.getMap("marital_status"));
    _addressCtrl = AdvTextFieldController(label: dict.getString("address"));
    _emailCtrl =
        AdvTextFieldController(label: dict.getString("email"), maxLines: 1);
    _phoneNumberCtrl = AdvTextFieldController(
        label: dict.getString("phone_number"), maxLines: 1);
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

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
                      AdvTextField(controller: _nameCtrl),
                      AdvDatePicker(
                        controller: _dateOfBirthCtrl,
                        onChanged: (List value) {
                          _dateOfBirthCtrl.initialValue = value.first;
                        },
                      ),
                      AdvTextField(controller: _addressCtrl),
                      AdvChooser(controller: _maritalStatusCtrl),
                      AdvTextField(controller: _emailCtrl),
                      AdvTextField(controller: _phoneNumberCtrl),
                    ],
                  )),
            ),
            AdvButton(
              dict.getString("next"),
              width: double.infinity,
              onPressed: () {
                if (widget.onCompleted != null) widget.onCompleted();
//                controller.selectedIndex =
//                    (controller.selectedIndex + 1).clamp(0, 10);
              },
            ),
          ],
        ));
  }
}

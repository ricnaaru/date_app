import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/presenters/register.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_checkbox.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_text_field.dart';

class RegisterPersonalPage extends StatefulWidget {
  final RegisterPresenter presenter;

  RegisterPersonalPage({@required this.presenter});

  @override
  State<StatefulWidget> createState() => _RegisterPersonalPageState();
}

class _RegisterPersonalPageState extends State<RegisterPersonalPage> {
  RegisterPresenter _presenter;

  @override
  void initState() {
    _presenter = widget.presenter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 32.0).copyWith(top: 0.0, bottom: 16.0),
        child: AdvColumn(
          divider: ColumnDivider(16.0),
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: AdvColumn(
                divider: ColumnDivider(8.0),
                children: [
                  Container(height: 40.0),
                  AdvTextField(controller: _presenter.nameCtrl),
                  AdvDatePicker(
                    controller: _presenter.dateOfBirthCtrl,
                    onChanged: (List value) {
                      _presenter.dateOfBirthCtrl.initialValue = value.first;
                    },
                  ),
                  AdvRow(divider: RowDivider(8.0), children: [
                    AdvCheckbox(
                      value: _presenter.showBirthday,
                      onChanged: (bool value) {
                        _presenter.showBirthday = value;
                      },
                    ),
                    Text(dict.getString("show_age")),
                  ]),
                  AdvTextField(controller: _presenter.addressCtrl),
                  AdvChooserDialog(controller: _presenter.maritalStatusCtrl),
                  AdvTextField(controller: _presenter.emailCtrl),
                  AdvTextField(controller: _presenter.phoneNumberCtrl),
                ],
              )),
            ),
            AdvButton(
              dict.getString("next"),
              width: double.infinity,
              onPressed: () {
                _presenter.nextPage();
              },
            ),
          ],
        ));
  }
}

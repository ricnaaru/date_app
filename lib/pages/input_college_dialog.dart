import 'package:date_app/components/custom_dialog_input.dart';
import 'package:date_app/presenters/input_business.dart';
import 'package:date_app/presenters/input_college.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_chooser.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_text_field.dart';

class InputCollegeDialog extends StatefulWidget {
  @override
  _InputCollegeDialogState createState() => _InputCollegeDialogState();
}

class _InputCollegeDialogState extends View<InputCollegeDialog> {
  InputCollegePresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _presenter = InputCollegePresenter(context);
  }

  @override
  Widget buildView(BuildContext context) {
    return CustomDialogInput(
      title: dict.getString("college"), //dict.getString("select_availability"),
      content: AdvColumn(
        padding: EdgeInsets.all(16.0),
        divider: ColumnDivider(8.0),
        children: [
          AdvTextField(controller: _presenter.universityCtrl),
          AdvTextField(controller: _presenter.majorCtrl),
          AdvChooser(controller: _presenter.degreeCtrl),
          AdvIncrement(controller: _presenter.semesterCtrl),
          AdvDatePicker(
            controller: _presenter.classYearCtrl,
            onChanged: _presenter.onClassYearChanged,
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(dict.getString("cancel")),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(dict.getString("ok")),
          onPressed: () {
            Navigator.pop(context, _presenter.saveData());
          },
        )
      ],
    );
  }
}

import 'package:date_app/components/custom_dialog_input.dart';
import 'package:date_app/presenters/input_business.dart';
import 'package:date_app/presenters/input_job.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_chooser.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_text_field.dart';

class InputJobDialog extends StatefulWidget {
  @override
  _InputJobDialogState createState() => _InputJobDialogState();
}

class _InputJobDialogState extends View<InputJobDialog> {
  InputJobPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _presenter = InputJobPresenter(context);
  }

  @override
  Widget buildView(BuildContext context) {
    return CustomDialogInput(
      title: dict.getString("college"), //dict.getString("select_availability"),
      content: AdvColumn(
        padding: EdgeInsets.all(16.0),
        divider: ColumnDivider(8.0),
        children: [
          AdvTextField(controller: _presenter.companyCtrl),
          AdvTextField(controller: _presenter.companyAddressCtrl),
          AdvTextField(controller: _presenter.jobTitleCtrl),
          AdvTextField(controller: _presenter.jobDescriptionCtrl),
          AdvDatePicker(
            controller: _presenter.sinceCtrl,
            onChanged: _presenter.onSinceDateChanged,
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

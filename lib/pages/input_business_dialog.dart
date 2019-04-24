import 'package:date_app/components/custom_dialog_input.dart';
import 'package:date_app/presenters/input_business.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_chooser.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_increment.dart';
import 'package:pit_components/components/adv_text_field.dart';

class InputBusinessDialog extends StatefulWidget {
  @override
  _InputBusinessDialogState createState() => _InputBusinessDialogState();
}

class _InputBusinessDialogState extends View<InputBusinessDialog> {
  InputBusinessPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    _presenter = InputBusinessPresenter(context);
  }

  @override
  Widget buildView(BuildContext context) {
    return CustomDialogInput(
      title: dict.getString("business"), //dict.getString("select_availability"),
      content: AdvColumn(
        padding: EdgeInsets.all(16.0),
        divider: ColumnDivider(8.0),
        children: [
          AdvTextField(controller: _presenter.businessNameCtrl),
          AdvTextField(controller: _presenter.businessDescriptionCtrl),
          AdvTextField(controller: _presenter.businessAddressCtrl),
          AdvDatePicker(
            controller: _presenter.openSinceCtrl,
            onChanged: _presenter.onOpenDateChanged,
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

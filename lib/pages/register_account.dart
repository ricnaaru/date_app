import 'package:date_app/presenters/register.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class RegisterAccountPage extends StatefulWidget {
  final RegisterPresenter presenter;

  RegisterAccountPage({@required this.presenter});

  @override
  State<StatefulWidget> createState() => _RegisterAccountPageState();
}

class _RegisterAccountPageState extends View<RegisterAccountPage> {
  RegisterPresenter _presenter;

  @override
  void initState() {
    _presenter = widget.presenter;
    super.initState();
  }

  @override
  Widget buildView(BuildContext context) {
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
                  AdvTextField(controller: _presenter.usernameCtrl),
                  AdvTextField(controller: _presenter.passwordCtrl),
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

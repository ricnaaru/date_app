import 'package:date_app/utilities/localization.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';

class RegisterAccount extends StatefulWidget {
  final VoidCallback onCompleted;

  RegisterAccount({this.onCompleted});

  @override
  State<StatefulWidget> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends AdvState<RegisterAccount> {
  AdvTextFieldController _usernameCtrl;
  AdvTextFieldController _passwordCtrl;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);

    _usernameCtrl =
        AdvTextFieldController(label: dict.getString("username"), maxLines: 1);
    _passwordCtrl =
        AdvTextFieldController(label: dict.getString("password"), maxLines: 1);
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
                  AdvTextField(controller: _usernameCtrl),
                  AdvTextField(controller: _passwordCtrl),
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

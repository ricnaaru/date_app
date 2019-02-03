import 'package:date_app/components/adv_dialog.dart';
import 'package:date_app/components/sequence.dart';
import 'package:date_app/pages/home_container.dart';
import 'package:date_app/pages/register_account.dart';
import 'package:date_app/pages/register_additional.dart';
import 'package:date_app/pages/register_church.dart';
import 'package:date_app/pages/register_personal.dart';
import 'package:date_app/utilities/assets.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_state.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends AdvState<RegisterPage> {
  SequenceController _sequenceController = SequenceController(selectedIndex: 0);

  Function _onCompleted;

  @override
  void initStateWithContext(BuildContext context) {
//    timeDilation = 5.0;
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);

    _onCompleted = () {
      _sequenceController.selectedIndex =
          (_sequenceController.selectedIndex + 1).clamp(0, 4);

      if (_sequenceController.selectedIndex == 4) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AdvDialog(
                title: dict.getString("congratulation"),
                content: AdvColumn(
                  divider: ColumnDivider(8.0),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        dict.getString("registration_success"),
                        style: ts.p3,
                        textAlign: TextAlign.center),
                    Text(
                        dict.getString("have_a_nice_day"),
                        style: ts.h8, textAlign: TextAlign.center),
                    Image.asset(Assets.loadingDummy),
                    AdvButton(
                      dict.getString("continue"),
                      width: double.infinity,
                      onPressed: () {
                        Navigator.pop(context);
                        Routing.pushReplacement(context, DateAppHome());
                      },
                    ),
                  ],
                )));
      }
    };
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    Function titleGenerator = (String title) {
      return Container(
          constraints: BoxConstraints.expand(),
          alignment: Alignment.center,
          child: Text(
            title,
            style: ts.h4,
          ));
    };

    return Scaffold(
      body: Sequence(
        size: 50.0,
        titleContentRatio: 0.2,
        controller: _sequenceController,
        lineColor: global.systemPrimaryColor,
        startColor: global.systemAccentColor,
        endColor: global.systemPrimaryColor,
        children: [
          SequenceItem(
              indicator: Icon(Icons.person),
              title: titleGenerator(dict.getString("personal_information")),
              content: RegisterPersonalPage(onCompleted: _onCompleted)),
          SequenceItem(
              indicator: Icon(Icons.work),
              title: titleGenerator(dict.getString("additional_information")),
              content: RegisterAdditionalPage(onCompleted: _onCompleted)),
          SequenceItem(
              indicator: Icon(Icons.home),
              title: titleGenerator(dict.getString("church_information")),
              content: RegisterChurchPage(onCompleted: _onCompleted)),
          SequenceItem(
              indicator: Icon(Icons.account_box),
              title: titleGenerator(dict.getString("account_information")),
              content: RegisterAccountPage(onCompleted: _onCompleted)),
        ],
      ),
    );
  }
}

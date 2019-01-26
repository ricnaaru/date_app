import 'package:date_app/components/adv_dialog.dart';
import 'package:date_app/components/sequence.dart';
import 'package:date_app/pages/register_account.dart';
import 'package:date_app/pages/register_additional.dart';
import 'package:date_app/pages/register_church.dart';
import 'package:date_app/pages/register_personal.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_state.dart';

class DateAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DateAppHomeState();
}

class _DateAppHomeState extends AdvState<DateAppHome> {
  SequenceController _sequenceController = SequenceController(selectedIndex: 0);

  Function _onCompleted;

  @override
  void initStateWithContext(BuildContext context) {
//    timeDilation = 5.0;
    super.initStateWithContext(context);

    _onCompleted = () {
      _sequenceController.selectedIndex =
          (_sequenceController.selectedIndex + 1).clamp(0, 4);

      if (_sequenceController.selectedIndex == 4) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AdvDialog(
                    child: AdvColumn(divider: ColumnDivider(16.0), children: [
                  Container(
                    child: Text("Congratulation!", style: ts.h7),
                  ),
                  Container(height: 0.5, color: global.systemGreyColor),
                  Icon(Icons.insert_emoticon)
                ])));
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
              content: RegisterPersonal(onCompleted: _onCompleted)),
          SequenceItem(
              indicator: Icon(Icons.work),
              title: titleGenerator(dict.getString("additional_information")),
              content: RegisterAdditional(onCompleted: _onCompleted)),
          SequenceItem(
              indicator: Icon(Icons.home),
              title: titleGenerator(dict.getString("church_information")),
              content: RegisterChurch(onCompleted: _onCompleted)),
          SequenceItem(
              indicator: Icon(Icons.account_box),
              title: titleGenerator(dict.getString("account_information")),
              content: RegisterAccount(onCompleted: _onCompleted)),
        ],
      ),
    );
  }
}

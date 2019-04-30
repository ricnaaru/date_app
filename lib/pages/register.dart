import 'package:date_app/components/custom_dialog.dart';
import 'package:date_app/components/sequence.dart';
import 'package:date_app/presenters/register.dart';
import 'package:date_app/pages/register_account.dart';
import 'package:date_app/pages/register_additional.dart';
import 'package:date_app/pages/register_church.dart';
import 'package:date_app/pages/register_personal.dart';
import 'package:date_app/utilities/assets.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends View<RegisterPage> implements RegisterInterface {
  Function _onCompleted;

  RegisterPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
//    timeDilation = 5.0;
    super.initStateWithContext(context);

    _presenter = RegisterPresenter(context, this, interface: this);
  }

  @override
  Widget buildView(BuildContext context) {
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
      body: Stack(
        children: [
          Sequence(
            boxSize: 50.0,
            titleContentRatio: 0.2,
            controller: _presenter.sequenceController,
            lineColor: CompanyColors.primary,
            initialColor: CompanyColors.accent,
            filledColor: CompanyColors.primary,
            children: [
              SequenceItem(
                  indicator: Icon(Icons.person),
                  title: titleGenerator(dict.getString("personal_information")),
                  content: RegisterPersonalPage(presenter: _presenter)),
              SequenceItem(
                  indicator: Icon(Icons.work),
                  title: titleGenerator(dict.getString("additional_information")),
                  content: RegisterAdditionalPage(presenter: _presenter)),
              SequenceItem(
                  indicator: Icon(Icons.home),
                  title: titleGenerator(dict.getString("church_information")),
                  content: RegisterChurchPage(presenter: _presenter)),
              SequenceItem(
                  indicator: Icon(Icons.account_box),
                  title: titleGenerator(dict.getString("account_information")),
                  content: RegisterAccountPage(presenter: _presenter)),
            ],
          ),
          SafeArea(
            child: Container(
              height: kToolbarHeight,
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }

  @override
  void onPageCompleted(int index) {}

  @override
  void onSequenceCompleted() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
            title: dict.getString("congratulation"),
            content: AdvColumn(
              divider: ColumnDivider(8.0),
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(dict.getString("registration_success"),
                    style: ts.p3, textAlign: TextAlign.center),
                Text(dict.getString("have_a_nice_day"), style: ts.h8, textAlign: TextAlign.center),
                Image.asset(Assets.loadingDummy),
                AdvButton(
                  dict.getString("continue"),
                  width: double.infinity,
                  onPressed: () {
                    Navigator.pop(context);
//                        Routing.pushReplacement(context, DateAppHome());
                  },
                ),
              ],
            )));
  }

  @override
  void onOccupationsAdded() {
    setState(() {

    });
  }
}

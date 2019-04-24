import 'package:date_app/presenters/register.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_checkbox.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/pit_components.dart';

class RegisterChurchPage extends StatefulWidget {
  final RegisterPresenter presenter;

  RegisterChurchPage({@required this.presenter});

  @override
  State<StatefulWidget> createState() => _RegisterChurchPageState();
}

class _RegisterChurchPageState extends State<RegisterChurchPage> {
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
                  InkWell(
                    onTap: () {
                      setState(() {
                        _presenter.haveBeenBaptized = !_presenter.haveBeenBaptized;
                      });
                    },
                    child: AdvRow(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        divider: RowDivider(8.0),
                        children: [
                          AdvCheckbox(
                            value: _presenter.haveBeenBaptized,
                          ),
                          Text(dict.getString("i_have_been_baptized")),
                        ]),
                  ),
                  _presenter.haveBeenBaptized ? _buildBaptismSection(context) : null,
                  AdvDatePicker(
                    controller: _presenter.joinJpccSinceCtrl,
                    onChanged: _presenter.onJoinJpccDateChanged,
                  ),
                  _buildClassHistorySection(context),
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

  Widget _buildBaptismSection(BuildContext context) {
    return AdvColumn(
      divider: ColumnDivider(8.0),
      children: [
        AdvTextField(controller: _presenter.baptismChurchCtrl),
        AdvDatePicker(
          controller: _presenter.baptismDateCtrl,
          onChanged: _presenter.onBaptizedDateChanged,
        ),
      ],
    );
  }

  Widget _buildClassHistorySection(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return AdvColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dict.getString("class_history"),
          style: ts.h8.merge(TextStyle(color: PitComponents.textFieldLabelColor)),
        )
      ]..addAll(_presenter.classes.keys.map((className) {
          return InkWell(
            child: AdvRow(children: [
              Container(
                  child: AdvCheckbox(
                      activeColor: CompanyColors.primary, value: _presenter.classes[className]),
                  margin: EdgeInsets.all(8.0)),
              Expanded(child: Text(className)),
            ]),
            onTap: () {
              setState(() {
                _presenter.classes[className] = !_presenter.classes[className];
              });
            },
          );
        }).toList()),
    );
  }
}

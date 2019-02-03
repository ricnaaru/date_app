import 'package:date_app/utilities/localization.dart';
import 'package:flutter/material.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_chooser.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_date_picker.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/adv_text_field.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_date_picker_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/pit_components.dart';

class RegisterChurchPage extends StatefulWidget {
  final VoidCallback onCompleted;

  RegisterChurchPage({this.onCompleted});

  @override
  State<StatefulWidget> createState() => _RegisterChurchPageState();
}

class _RegisterChurchPageState extends AdvState<RegisterChurchPage> {
  bool _haveBeenBaptized = false;
  AdvTextFieldController _baptismChurchCtrl;
  AdvDatePickerController _baptismDateCtrl;
  AdvTextFieldController _joinJpccSinceCtrl;
  Map<String, bool> classes = {
    "Partner's Day": false,
    "Community of Believer": false,
    "Community of Leader": false,
    "Community of Councelor": false,
    "Deeper Bible": false,
    "Updating": false,
    "Preparing Together": false
  };

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);

    _baptismChurchCtrl = AdvTextFieldController(
        label: dict.getString("baptism_church"), maxLines: 1);
    _baptismDateCtrl =
        AdvDatePickerController(label: dict.getString("baptism_date"));

    _joinJpccSinceCtrl = AdvTextFieldController(
        label: dict.getString("join_jpcc_since"), maxLines: 1);
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
                  InkWell(
                    child: AdvRow(children: [
                      Container(
                          child: RoundCheckbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: global.systemPrimaryColor,
                              onChanged: (bool value) {
                                setState(() {
                                  _haveBeenBaptized = value;
                                });
                              },
                              value: _haveBeenBaptized),
                          margin: EdgeInsets.all(8.0)),
                      Expanded(
                          child: Text(dict.getString("i_have_been_baptized"))),
                    ]),
                    onTap: () {
                      setState(() {
                        _haveBeenBaptized = !_haveBeenBaptized;
                      });
                    },
                  ),
                  _haveBeenBaptized ? _buildBaptismSection(context) : null,
                  AdvTextField(
                    controller: _joinJpccSinceCtrl,
                    textChangeListener: (oldText, newText) {
                      print("lalala => ${int.tryParse(newText)}");
                      if (int.tryParse(newText) > 2050) {
                        _joinJpccSinceCtrl.text = "2050";
                      }
                    },
                  ),
                  _buildClassHistorySection(context),
                ],
              )),
            ),
            AdvButton(
              dict.getString("next"),
              width: double.infinity,
              onPressed: () {
                if (widget.onCompleted != null) widget.onCompleted();
              },
            ),
          ],
        ));
  }

  Widget _buildBaptismSection(BuildContext context) {
    return AdvColumn(
      divider: ColumnDivider(8.0),
      children: [
        AdvTextField(controller: _baptismChurchCtrl),
        AdvDatePicker(
          controller: _baptismDateCtrl,
          onChanged: (List value) {
            _baptismDateCtrl.initialValue = value.first;
          },
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
          style:
              ts.h8.merge(TextStyle(color: PitComponents.textFieldLabelColor)),
        )
      ]..addAll(classes.keys.map((className) {
          return InkWell(
            child: AdvRow(children: [
              Container(
                  child: RoundCheckbox(
                      activeColor: global.systemPrimaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool value) {
                        setState(() {
                          classes[className] = value;
                        });
                      },
                      value: classes[className]),
                  margin: EdgeInsets.all(8.0)),
              Expanded(child: Text(className)),
            ]),
            onTap: () {
              setState(() {
                classes[className] = !classes[className];
              });
            },
          );
        }).toList()),
    );
  }
}

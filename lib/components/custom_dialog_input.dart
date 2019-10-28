import 'package:flutter/material.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';

class CustomDialogInput extends StatelessWidget {
  final String title;
  final Widget content;floating
  final List<Widget> actions;

  CustomDialogInput({this.title, this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Theme(
          data: ThemeData(brightness: Brightness.light),
          child: Container(
            constraints:
                BoxConstraints(minHeight: 24.0, maxHeight: maxHeight * 0.6),
            child: AdvColumn(
              mainAxisSize: MainAxisSize.min,
              divider: Container(
                color: Colors.black54,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                height: 1.5,
              ),
              children: [
                title != null
                    ? Container(
                        margin: EdgeInsets.all(16.0),
                        child: Text(title, style: ts.h7))
                    : null,
                Flexible(
                    child: SingleChildScrollView(
                  child: content,
                )),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: actions,
                  ),
                )
              ],
            ),
          )),
    );
  }
}

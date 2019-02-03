import 'package:flutter/material.dart';
import 'package:date_app/utilities/global.dart' as global;
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';

class AdvDialog extends StatelessWidget {
  final String title;
  final Widget content;

  AdvDialog({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        constraints: BoxConstraints(minHeight: 24.0),
        margin: EdgeInsets.all(16.0),
        child: AdvColumn(
          mainAxisSize: MainAxisSize.min,
          divider: Container(
            color: Colors.black54,
            height: 0.5,
            margin: EdgeInsets.symmetric(vertical: 8.0),
          ),
          children: [
            AdvRow(children: [
              Expanded(
                child: Text(title, style: ts.h7),
              ),
              InkWell(
                child: Icon(Icons.close, color: global.systemRedColor),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ]),
            Flexible(child: content)
          ],
        ),
      ),
    );
  }
}

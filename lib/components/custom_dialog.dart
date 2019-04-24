import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/textstyles.dart' as ts;
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final WillPopCallback onWillPop;

  CustomDialog({this.title, this.content, this.onWillPop});

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        constraints: BoxConstraints(minHeight: 24.0, maxHeight: maxHeight * 0.6),
        margin: EdgeInsets.all(16.0),
        child: AdvColumn(
          mainAxisSize: MainAxisSize.min,
          divider: Container(
            color: Colors.black54,
            height: 0.5,
            margin: EdgeInsets.only(top: 8.0),
          ),
          children: [
            AdvRow(children: [
              Expanded(
                child: Text(title, style: ts.h7),
              ),
              InkWell(
                child: Icon(Icons.close, color: systemRedColor),
                onTap: () async {
                  if (onWillPop != null && await onWillPop()) Navigator.pop(context);
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

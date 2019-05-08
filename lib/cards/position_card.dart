import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/models.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:smart_text/smart_text.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:url_launcher/url_launcher.dart';

class PositionCard extends StatelessWidget {
  final PositionModel model;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  PositionCard({this.model, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Card(
      color: CompanyColors.accentColorList[50],
      child: Container(
        child: AdvColumn(
          divider: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0).copyWith(bottom: 8.0),
            height: 0.5,
            width: double.infinity,
            color: Colors.grey,
          ),
          children: [
            AdvRow(
                padding: EdgeInsets.all(8.0),
                divider: RowDivider(16.0),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50.0,
                    height: 50.0,
                    child: Text(model.code, style: h8.copyWith(color: Colors.white)),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: CompanyColors.primaryColorList[700]),
                  ),
                  Expanded(
                      child: AdvColumn(
                          divider: ColumnDivider(2.0),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(model.name, style: h7, maxLines: 1),
                        model.qty == 0 ? null : Text(dict.positionNeeded(model.qty), style: p4.copyWith(color: Colors.blueGrey)),
                        SmartText(model.description, maxLines: 2)
                      ]))
                ]),
            AdvRow(mainAxisAlignment: MainAxisAlignment.end, divider: RowDivider(8.0), children: [
              InkWell(
                child: Container(
                  child: Text(
                    dict.getString("delete"),
                    style: h9.copyWith(color: systemRedColor),
                  ),
                  padding: EdgeInsets.all(8.0),
                ),
                onTap: onDelete ?? defaultVoidCallback,
              ),
              InkWell(
                child: Container(
                  child: Text(
                    dict.getString("edit"),
                    style: h9.copyWith(color: Colors.blueAccent),
                  ),
                  padding: EdgeInsets.all(8.0),
                ),
                onTap: onEdit ?? defaultVoidCallback,
              ),
            ]),
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  defaultVoidCallback() {

  }
}

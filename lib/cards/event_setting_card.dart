import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/models.dart';
import 'package:date_app/pages/event_add.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:smart_text/smart_text.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:url_launcher/url_launcher.dart';

class EventSettingCard extends StatelessWidget {
  final EventSettingModel eventSetting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  EventSettingCard({this.eventSetting, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);
    DateFormat df = dict.getDateFormat("dd MMM yyyy");

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
            AdvColumn(
                padding: EdgeInsets.all(8.0),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventSetting.name, style: h7),
                  eventSetting.description == null ? null : Text(eventSetting.description),
                  eventSetting.location == null ? null : Text(eventSetting.location),
                  Text("${df.format(eventSetting.startDate)} - ${df.format(eventSetting.endDate)}",
                      style: p4),
                  Text(
                      "${eventSetting.startTime.format(context)} - ${eventSetting.endTime.format(context)}",
                      style: p4),
                  eventSetting.category == EventCategory.personal ? null : Text(
                      "${dict.availabilitiesConfirmed(eventSetting.availabilities.length, eventSetting.positions.length)}",
                      style: h10.copyWith(color: systemRedColor)),
                ]),
            getActions(context, eventSetting),
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  defaultVoidCallback() {}

  getActions(BuildContext context, EventSettingModel eventSetting) {
    DateDict dict = DateDict.of(context);

    Widget result;

    if (eventSetting.category == EventCategory.personal) {
      result =
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
          ]);
    } else {
      result =
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
        InkWell(
          child: Container(
            child: Text(
              dict.getString("generate"),
              style: h9.copyWith(color: Colors.blueAccent),
            ),
            padding: EdgeInsets.all(8.0),
          ),
          onTap: onEdit ?? defaultVoidCallback,
        ),
      ]);
    }

    return result;
  }
}

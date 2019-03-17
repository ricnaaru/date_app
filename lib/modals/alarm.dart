import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_countdown.dart';
import 'package:date_app/components/adv_dialog.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';

class AlarmModal extends StatelessWidget {
  final DateTime alarmDate;

  AlarmModal(this.alarmDate);

  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);
    DateFormat df = dict.getDateFormat("dd MMM yyyy HH:mm");

    return AdvDialog(
      title: dict.getString("alarm_set"),
      content: AdvColumn(
          divider: ColumnDivider(8.0),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(text: dict.getString("alarm_set_info")),
                TextSpan(text: " ${df.format(alarmDate)} WIB", style: h8)
              ]),
            ),
            AdvCountdown(futureDate: alarmDate),
            CachedNetworkImage(
                imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/7a/Alarm_Clock_GIF_Animation_High_Res.gif"),
          ]),
    );
  }
}

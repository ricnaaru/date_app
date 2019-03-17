import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/modals/alarm.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';

class ReminderCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final DateTime date;
  final String venue;
  final String content;

  ReminderCard({this.imageUrl, this.title, this.date, this.venue, this.content})
      : assert(imageUrl != null),
        assert(title != null),
        assert(date != null),
        assert(venue != null),
        assert(content != null);

  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);
    DateFormat df = dict.getDateFormat("dd MMM yyyy HH:mm");

    return Card(
        child: AdvColumn(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
          child: SizedBox(
            height: kCardImageHeight,
            width: double.infinity,
            child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
          ),
        ),
        AdvColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            divider: ColumnDivider(16.0),
            margin: EdgeInsets.all(8.0),
            children: [
              AdvColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  divider: ColumnDivider(4.0),
                  margin: EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8.0),
                  children: [
                    Text(title, style: h5),
                    Text("${df.format(date)} WIB\n$venue", style: p4),
                  ]),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: handleEmoji(content),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Container(
                    child: Text(
                      dict.getString("remind_me"),
                      style: h9.copyWith(color: Colors.blueAccent),
                    ),
                    padding: EdgeInsets.all(8.0),
                  ),
                  onTap: () {
                    showDialog(context: context, builder: (BuildContext context) => AlarmModal(date));
                  },
                ),
              ),
            ]),
      ], //0.725 | 0.75
    ));
  }
}

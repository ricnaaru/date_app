import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/modals/alarm.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pit_components/components/adv_column.dart';

class PostCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String content;
  final String actionName;
  final VoidCallback actionCallback;

  PostCard({this.imageUrl, this.title, this.subtitle,
    this.content, this.actionName,
    this.actionCallback})
      : assert(imageUrl != null),
        assert(title != null),
        assert(subtitle != null),
        assert(content != null),
        assert(actionName != null && actionCallback != null);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: AdvColumn(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
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
                      margin:
                      EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8.0),
                      children: [
                        Text(title, style: h5),
                        Text(subtitle, style: p4),
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
                          actionName,
                          style: h9.copyWith(color: Colors.blueAccent),
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                      onTap: () {
                        if (actionCallback != null) actionCallback();
                      },
                    ),
                  ),
                ]),
          ], //0.725 | 0.75
        ));
  }
}

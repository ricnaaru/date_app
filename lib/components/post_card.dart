import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/models.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/global.dart';
import 'package:smart_text/smart_text.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:url_launcher/url_launcher.dart';

class PostCard extends StatelessWidget {
  final PostModel model;

  PostCard({this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: AdvColumn(
          children: [
            ClipRRect(
              borderRadius:
              BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0)),
              child: SizedBox(
                height: kCardImageHeight,
                width: double.infinity,
                child: CachedNetworkImage(imageUrl: model.imageUrl, fit: BoxFit.cover),
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
                        Text(model.title, style: h5),
                        Text(model.subtitle, style: p4),
                      ]),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SmartText(model.description, maxLines: 4),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      child: Container(
                        child: Text(
                          model.actionName,
                          style: h9.copyWith(color: Colors.blueAccent),
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                      onTap: () {
                        launch(model.goTo);
                      },
                    ),
                  ),
                ]),
          ], //0.725 | 0.75
        ));
  }
}

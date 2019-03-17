import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/pages/open_discussion.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/models.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityPage extends StatefulWidget {
  final List<Member> members;

  CommunityPage({this.members});

  @override
  State<StatefulWidget> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);
    print("widget.members => ${widget.members}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(dict.getString("date_member")),
      ),
      body: SingleChildScrollView(
          child: AdvColumn(
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              divider: Container(
                height: 0.5,
                color: Colors.black54,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              children: widget.members == null
                  ? []
                  : widget.members.map(
                      (member) {
                        return AdvListTile(
                          padding: EdgeInsets.all(8.0),
                          start: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: CachedNetworkImage(
                              imageUrl: member.photo,
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          expanded:
                              AdvColumn(divider: ColumnDivider(4.0), crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(member.name),
                            InkWell(
                              onTap: () {
                                launch("tel:${member.phone}");
                              },
                              child: Text(
                                "${member.phone}",
                                style: p4.copyWith(color: Colors.blue),
                              ),
                            )
                          ]),
                        );
                      },
                    ).toList())),
    );
  }
}

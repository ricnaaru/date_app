import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/pit_components.dart';
//need to refactor efficiently

class OpenDiscussionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OpenDiscussionPageState();
}

class _OpenDiscussionPageState extends AdvState<OpenDiscussionPage> {
  List<CheckListItem> _checkListItems;
  AdvChooserController categoryController;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);

    _checkListItems = members.map((member) => CheckListItem(member.name, icon: member.photo)).toList();

    categoryController = AdvChooserController(
      label: dict.getString("category"),
      items: [
        GroupCheckItem("holiday", dict.getString("holiday")),
        GroupCheckItem("jpcc", "JPCC"),
        GroupCheckItem("date", "DATE"),
        GroupCheckItem("birthday", dict.getString("birthday")),
        GroupCheckItem("group", dict.getString("group")),
        GroupCheckItem("personal", dict.getString("personal")),
      ],
    );
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(dict.getString("open_discussion")),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: AdvColumn(
            divider: ColumnDivider(16.0),
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: AdvChooserDialog(
                  controller: categoryController,
                ),
              ),
              AdvColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdvRow(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      children: [
                        Expanded(
                            child: Text(dict.getString("participant"),
                                style: PitComponents.getLabelTextStyle())),
                        InkWell(
                          child: Text(
                              dict.getString(_checkListItems
                                          .where((item) => !item.checked)
                                          .length >
                                      0
                                  ? "check_all"
                                  : "uncheck_all"),
                              style: PitComponents.getLabelTextStyle()
                                  .copyWith(color: systemHyperlinkColor)),
                          onTap: () {
                            bool newValue = _checkListItems
                                .where((item) => !item.checked)
                                .length >
                                0;

                            setState(() {
                              for (CheckListItem value in _checkListItems) {
                                value.checked = newValue;
                              }
                            });
                          },
                        )
                      ])
                ]..addAll(
                    _checkListItems.map(
                      (checkListItem) {
                        return AdvListTile(
                            onTap: () {
                              print(
                                  "checkListItem.checked => ${checkListItem.checked}");
                              setState(() {
                                checkListItem.checked = !checkListItem.checked;
                              });
                              print(
                                  "checkListItem.checked => ${checkListItem.checked}");
                            },
                            padding: EdgeInsets.all(8.0),
                            start: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: CachedNetworkImage(
                                imageUrl: checkListItem.icon,
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            expanded: Text(checkListItem.display),
                            end: IgnorePointer(
                              ignoring: true,
                              child: RoundCheckbox(
                                value: checkListItem.checked,
                                onChanged: (bool value) {},
                                activeColor: systemPrimaryColor,
                              ),
                            ));
                      },
                    ),
                  ),
              )
            ]),
      ),
    );
  }
}

class CheckListItem {
  String display;
  String icon;
  bool checked = false;

  CheckListItem(this.display, {this.checked = false, this.icon});

  CheckListItem.fromValue(CheckListItem value) :
    this.display = value.display,
    this.checked = value.checked,
    this.icon = value.icon;
}

class GroupCheckListItem {
  String name;
  List<String> icons;
  List<String> names;
  bool checked = false;

  GroupCheckListItem(this.name, {this.checked = false, this.icons, this.names});

  GroupCheckListItem.fromValue(GroupCheckListItem value) :
    this.name = value.name,
    this.checked = value.checked,
    this.icons = value.icons,
    this.names = value.names;
}

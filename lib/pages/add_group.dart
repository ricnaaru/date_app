import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_checkbox_with_text.dart';
import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/pages/add_event_setting.dart';
import 'package:date_app/pages/open_discussion.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/adv_radio_button.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/components/controllers/adv_text_field_controller.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/pit_components.dart';

class AddGroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends AdvState<AddGroupPage> {
  List<CheckListItem> _allCheckListItems;
  List<CheckListItem> _filteredCheckListItems;
  bool _reorderMode = false;
  bool ascOrder = false;
  bool _errNoParticipant = false;
  AdvTextFieldController groupNameController;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);

//    _allCheckListItems = members
//        .map((member) => CheckListItem(member.name, icon: member.photo))
//        .toList();

    groupNameController = AdvTextFieldController(
        label: dict.getString("name"), hint: dict.getString("input_name"));

    _filteredCheckListItems = _allCheckListItems;
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (_reorderMode) {
          setState(() {
            _filteredCheckListItems = _allCheckListItems.map((item) {
              int index = _filteredCheckListItems.indexOf(item);
              if (index > 0) {
                return _filteredCheckListItems[index];
              } else {
                return item;
              }
            }).toList();
            _reorderMode = false;
          });
          return false;
        }

        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(dict.getString("add_participants")),
            elevation: 0.0,
            backgroundColor: Colors.white,
          ),
          body: Container(
            color: Colors.white,
            child: AdvColumn(children: [
              Expanded(
                child: AdvColumn(
                    divider: ColumnDivider(16.0),
                    margin: EdgeInsets.symmetric(horizontal: 8.0)
                        .copyWith(top: 16.0),
                    children: [
                      _filteredCheckListItems.length == 1
                          ? null
                          : AdvRow(
                              mainAxisAlignment: MainAxisAlignment.end,
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              divider: RowDivider(8.0),
                              children: _getActions(dict)),
                      _getList()
                    ]),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: AdvButton(
                  dict.getString("next"),
                  width: double.infinity,
                  onPressed: () {
                    List<CheckListItem> selectedParticipant =
                        _filteredCheckListItems
                            .where((item) => item.checked)
                            .toList();

                    if (selectedParticipant.length == 0) {
                      setState(() {
                        _errNoParticipant = true;
                      });
                      return;
                    }

                    if (!_reorderMode) {
                      setState(() {
                        _filteredCheckListItems = selectedParticipant;
                        _reorderMode = true;
                      });
                    } else {
//                      Routing.push(context, AddEventSettingPage());
                    }
                  },
                ),
              )
            ]),
          )),
    );
  }

  Widget _getList() {
    if (_reorderMode) {
      return Expanded(
          child: _filteredCheckListItems.length == 1
              ? AdvColumn(children: [
                  Container(
                    child: AdvListTile(
                      onTap: () {},
                      padding: EdgeInsets.all(8.0),
                      start: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CachedNetworkImage(
                          imageUrl: _filteredCheckListItems.first.icon,
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      expanded: Text(_filteredCheckListItems.first.display),
                      end: Container(
                        margin: EdgeInsets.all(4.0),
                        width: 20.0,
                        height: 20.0,
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: systemPrimaryColor,
                        ),
                        child: Center(
                            child: Text(
                          "${_filteredCheckListItems.indexOf(_filteredCheckListItems.first) + 1}",
                          style: p5.copyWith(color: Colors.white),
                        )),
                      ),
                    ),
                    color: Colors.white,
                  ),
                  (_filteredCheckListItems.last ==
                          _filteredCheckListItems.first)
                      ? null
                      : Container(
                          height: 0.5,
                          color: Colors.black54,
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                        )
                ])
              : DragAndDropList(
                  _filteredCheckListItems,
                  canBeDraggedTo: (int oldIndex, int newIndex) {
                    return true;
                  },
                  onDragFinish: (before, after) {
                    var data = _filteredCheckListItems[before];
                    _filteredCheckListItems.removeAt(before);
                    _filteredCheckListItems.insert(after, data);
                  },
                  dragElevation: 8.0,
                  itemBuilder:
                      (BuildContext context, CheckListItem checkListItem) {
                    return AdvColumn(children: [
                      Container(
                        child: AdvListTile(
                          onTap: () {},
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
                          end: Container(
                            margin: EdgeInsets.all(4.0),
                            width: 20.0,
                            height: 20.0,
                            decoration: ShapeDecoration(
                              shape: CircleBorder(),
                              color: systemPrimaryColor,
                            ),
                            child: Center(
                                child: Text(
                              "${_filteredCheckListItems.indexOf(checkListItem) + 1}",
                              style: p5.copyWith(color: Colors.white),
                            )),
                          ),
                        ),
                        color: Colors.white,
                      ),
                      (_filteredCheckListItems.last == checkListItem)
                          ? null
                          : Container(
                              height: 0.5,
                              color: Colors.black54,
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                            )
                    ]);
                  },
                ));
    } else {
      return Expanded(
          child: SingleChildScrollView(
        child: AdvColumn(
            divider: Container(
                height: 0.5,
                color: Colors.black54,
                margin: EdgeInsets.symmetric(horizontal: 8.0)),
            children: _filteredCheckListItems.map((checkListItem) {
              return Container(
                child: AdvListTile(
                  onTap: () {
                    setState(() {
                      _errNoParticipant = false;
                      checkListItem.checked = !checkListItem.checked;
                    });
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
                    child: AdvCheckboxWithText(
                      value: checkListItem.checked,
                    ),
                  ),
                ),
                color: Colors.white,
              );
            }).toList()),
      ));
    }
  }

  List<Widget> _getActions(DateDict dict) {
    if (_reorderMode) {
      return [
        Expanded(
          child: Text(dict.getString("reorder_info"),
              style: PitComponents.getLabelTextStyle()),
        ),
        InkWell(
          child: Text(dict.getString("shuffle"),
              style: PitComponents.getLabelTextStyle()
                  .copyWith(color: systemHyperlinkColor)),
          onTap: () {
            setState(() {
              _filteredCheckListItems.shuffle();
            });
          },
        ),
        InkWell(
          child: Text(dict.getString(ascOrder ? "sort_z_a" : "sort_a_z"),
              style: PitComponents.getLabelTextStyle()
                  .copyWith(color: systemHyperlinkColor)),
          onTap: () {
            if (ascOrder) {
              _filteredCheckListItems.sort((item, otherItem) =>
                  otherItem.display.compareTo(item.display));
            } else {
              _filteredCheckListItems.sort((item, otherItem) =>
                  item.display.compareTo(otherItem.display));
            }

            ascOrder = !ascOrder;

            setState(() {});
          },
        )
      ];
    } else {
      return [
        _errNoParticipant
            ? Expanded(
                child: Text(
                dict.getString("err_no_participant"),
                style: PitComponents.getLabelTextStyle()
                    .copyWith(color: systemRedColor),
              ))
            : null,
        InkWell(
          child: Text(
              dict.getString(_filteredCheckListItems
                          .where((item) => !item.checked)
                          .length >
                      0
                  ? "check_all"
                  : "uncheck_all"),
              style: PitComponents.getLabelTextStyle()
                  .copyWith(color: systemHyperlinkColor)),
          onTap: () {
            bool newValue =
                _filteredCheckListItems.where((item) => !item.checked).length >
                    0;

            setState(() {
              for (CheckListItem value in _filteredCheckListItems) {
                value.checked = newValue;
              }
            });
          },
        )
      ];
    }
  }
}

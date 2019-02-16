import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_checkbox_with_text.dart';
import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/components/adv_dialog.dart';
import 'package:date_app/components/hero_dialog_route.dart';
import 'package:date_app/pages/add_event_setting.dart';
import 'package:date_app/pages/open_discussion.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/adv_radio_button.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/pit_components.dart';

//need to refactor efficiently
class AddEventParticipantPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddEventParticipantPageState();
}

class _AddEventParticipantPageState extends AdvState<AddEventParticipantPage> {
  List<Member> _allMembers;
  List<Member> _filteredMembers = [];
  List<Group> _allGroups;
  List<Group> _filteredGroups = [];
  bool _reorderMode = false;
  bool ascOrder = false;
  bool _errNoParticipant = false;
  AdvRadioGroupController crowdTypeController;
  String _crowdType = "personal";
  TextStyle labelStyle = PitComponents.getLabelTextStyle();

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    DateDict dict = DateDict.of(context);

    String personal = dict.getString("personal");
    String group = dict.getString("group");

    _allMembers = members;
    _allGroups = groups;

    crowdTypeController = AdvRadioGroupController(checkedValue: "personal", itemList: [
      RadioGroupItem(
        "personal",
        activeItem: AdvRow(divider: RowDivider(4.0), children: [
          Icon(Icons.person, color: systemPrimaryColor),
          Text(personal, style: TextStyle(color: systemPrimaryColor))
        ]),
        inactiveItem: AdvRow(
            divider: RowDivider(4.0),
            children: [Icon(Icons.person, color: Colors.black54), Text(personal, style: TextStyle(color: Colors.black54))]),
      ),
      RadioGroupItem(
        "group",
        activeItem: AdvRow(
            divider: RowDivider(4.0),
            children: [Icon(Icons.group, color: systemPrimaryColor), Text(group, style: TextStyle(color: systemPrimaryColor))]),
        inactiveItem: AdvRow(
            divider: RowDivider(4.0),
            children: [Icon(Icons.group, color: Colors.black54), Text(group, style: TextStyle(color: Colors.black54))]),
      ),
    ]);
  }

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (_reorderMode) {
          setState(() {
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
                child: AdvColumn(divider: ColumnDivider(16.0), margin: EdgeInsets.only(top: 16.0), children: [
                  _filteredMembers.length == 1 && _filteredGroups.length == 1
                      ? null
                      : AdvRow(
                          mainAxisAlignment: MainAxisAlignment.end,
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          divider: RowDivider(8.0),
                          children: _getActions(dict)),
                  _reorderMode
                      ? null
                      : AdvRadioGroup(
                          divider: 16.0,
                          controller: crowdTypeController,
                          callback: (crowdType) {
                            setState(() {
                              _crowdType = crowdType;
                              ascOrder = false;

                              _filteredMembers.clear();
                              _filteredGroups.clear();
                            });
                          },
                        ),
                  Expanded(child: _crowdType == "personal" ? _getContentPersonal(context) : _getContentGroup(context))
                ]),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: AdvButton(
                  dict.getString("next"),
                  width: double.infinity,
                  onPressed: () {
                    if (_filteredMembers.length == 0 && _filteredGroups.length == 0) {
                      setState(() {
                        _errNoParticipant = true;
                      });
                      return;
                    }

                    if (!_reorderMode) {
                      setState(() {
                        _reorderMode = true;
                      });
                    } else {
                      List<dynamic> participants;

                      if (_crowdType == "personal") {
                        participants = _filteredMembers;
                      } else {
                        participants = _filteredGroups;
                      }
                      Routing.push(context, AddEventSettingPage(participants));
                    }
                  },
                ),
              )
            ]),
          )),
    );
  }

  List<Widget> _getActions(DateDict dict) {
    if (_reorderMode) {
      return [
        Expanded(child: Text(dict.getString("reorder_info"), style: labelStyle)),
        InkWell(
          child: Text(dict.getString("shuffle"), style: labelStyle.copyWith(color: systemHyperlinkColor)),
          onTap: () {
            setState(() {
              if (_crowdType == "personal") {
                _filteredMembers.shuffle();
              } else {
                _filteredGroups.shuffle();
              }
            });
          },
        ),
        InkWell(
          child:
              Text(dict.getString(ascOrder ? "sort_z_a" : "sort_a_z"), style: labelStyle.copyWith(color: systemHyperlinkColor)),
          onTap: () {
            if (_crowdType == "personal") {
              if (ascOrder) {
                _filteredMembers.sort((item, otherItem) => otherItem.name.compareTo(item.name));
              } else {
                _filteredMembers.sort((item, otherItem) => item.name.compareTo(otherItem.name));
              }
            } else {
              if (ascOrder) {
                _filteredGroups.sort((item, otherItem) => otherItem.name.compareTo(item.name));
              } else {
                _filteredGroups.sort((item, otherItem) => item.name.compareTo(otherItem.name));
              }
            }

            ascOrder = !ascOrder;

            setState(() {});
          },
        )
      ];
    } else {
      String action;

      if (_crowdType == "personal") {
        action = _filteredMembers.length < _allMembers.length ? "check_all" : "uncheck_all";
      } else {
        action = _filteredGroups.length < _allGroups.length ? "check_all" : "uncheck_all";
      }

      return [
        _errNoParticipant
            ? Expanded(child: Text(dict.getString("err_no_participant"), style: labelStyle.copyWith(color: systemRedColor)))
            : null,
        InkWell(
          child: Text(dict.getString(action), style: labelStyle.copyWith(color: systemHyperlinkColor)),
          onTap: () {
            setState(() {
              if (_crowdType == "personal") {
                if (_filteredMembers.length < _allMembers.length) {
                  _filteredMembers = _allMembers;
                } else {
                  _filteredMembers = [];
                }
              } else {
                if (_filteredGroups.length < _allGroups.length) {
                  _filteredGroups = _allGroups;
                } else {
                  _filteredGroups = [];
                }
              }
            });
          },
        )
      ];
    }
  }

  Widget _getContentGroup(BuildContext context) {
    DateDict dict = DateDict.of(context);

    if (_reorderMode) {
      if (_filteredGroups.length == 1) {
        return _getSingleGroup();
      } else {
        return _getDraggableGroup();
      }
    } else {
      return _getCheckableGroup(dict);
    }
  }

  Widget _getSingleGroup() {
    return AdvColumn(children: [
      Container(
        child: AdvListTile(
          onTap: () {},
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          start: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: CachedNetworkImage(
                  imageUrl: _filteredGroups.first.members.first.photo, width: 50.0, height: 50.0, fit: BoxFit.cover)),
          expanded: Text(_filteredGroups.first.name, style: h9),
          end: Container(
            margin: EdgeInsets.all(4.0),
            width: 20.0,
            height: 20.0,
            decoration: ShapeDecoration(shape: CircleBorder(), color: systemPrimaryColor),
            child: Center(
                child: Text("${_filteredGroups.indexOf(_filteredGroups.first) + 1}", style: p5.copyWith(color: Colors.white))),
          ),
        ),
        color: Colors.white,
      ),
      (_filteredGroups.last == _filteredGroups.first)
          ? null
          : Container(height: 0.5, color: Colors.black54, margin: EdgeInsets.symmetric(horizontal: 16.0))
    ]);
  }

  Widget _getDraggableGroup() {
    return DragAndDropList(
      _filteredGroups,
      canBeDraggedTo: (int oldIndex, int newIndex) {
        return true;
      },
      onDragFinish: (before, after) {
        var data = _filteredGroups[before];
        _filteredGroups.removeAt(before);
        _filteredGroups.insert(after, data);
      },
      dragElevation: 8.0,
      itemBuilder: (BuildContext context, Group group) {
        return AdvColumn(children: [
          Container(
            child: AdvListTile(
              onTap: () {},
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              start: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(imageUrl: group.members.first.photo, width: 50.0, height: 50.0, fit: BoxFit.cover)),
              expanded: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(group.name, style: h9),
                group.fixedGroup ? Text("Fixed Group", style: p4.copyWith(color: systemDarkerGreyColor)) : null
              ]),
              end: Container(
                margin: EdgeInsets.all(4.0),
                width: 20.0,
                height: 20.0,
                decoration: ShapeDecoration(shape: CircleBorder(), color: systemPrimaryColor),
                child: Center(child: Text("${_filteredGroups.indexOf(group) + 1}", style: p5.copyWith(color: Colors.white))),
              ),
            ),
            color: Colors.white,
          ),
          (_filteredGroups.last == group)
              ? null
              : Container(height: 0.5, color: Colors.black54, margin: EdgeInsets.symmetric(horizontal: 16.0))
        ]);
      },
    );
  }

  Widget _getCheckableGroup(DateDict dict) {
    return SingleChildScrollView(
      child: AdvColumn(
          divider: Container(
            height: 0.5,
            color: Colors.black54,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          children: _allGroups.map((Group group) {
            return Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_filteredGroups.indexOf(group) == -1) {
                      _filteredGroups.add(group);
                    } else {
                      _filteredGroups.remove(group);
                    }

                    _errNoParticipant = false;
                  });
                },
                child: AdvRow(margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), children: [
                  Expanded(
                      child: AdvColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${group.name}${group.fixedGroup ? " (Fixed Group)" : ""}", style: h9),
                      AdvRow(
                        children: [
                          Container(
                            width: 130.0,
                            child: Stack(children: [
                              group.members.length >= 3
                                  ? Hero(
                                      tag: "MemberItem(3-${group.name})",
                                      child: Container(
                                        margin: EdgeInsets.only(left: 80.0),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50.0),
                                            child: CachedNetworkImage(
                                                imageUrl: group.members[2].photo, width: 50.0, height: 50.0, fit: BoxFit.cover)),
                                      ),
                                    )
                                  : Container(),
                              group.members.length >= 3
                                  ? Hero(
                                      tag: "MemberItem(2-${group.name})",
                                      child: Container(
                                        margin: EdgeInsets.only(left: 40.0),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50.0),
                                            child: CachedNetworkImage(
                                                imageUrl: group.members[1].photo, width: 50.0, height: 50.0, fit: BoxFit.cover)),
                                      ),
                                    )
                                  : Container(),
                              Hero(
                                tag: "MemberItem(1-${group.name})",
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: CachedNetworkImage(
                                        imageUrl: group.members.first.photo, width: 50.0, height: 50.0, fit: BoxFit.cover)),
                              ),
                            ]),
                          ),
                          group.members.length > 3
                              ? InkWell(
                                  child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(dict.getString("and_more"), style: TextStyle(color: systemHyperlinkColor))),
                                  onTap: () {
                                    Navigator.push(context, new HeroDialogRoute(builder: (BuildContext context) {
                                      List<Member> items = [];

                                      for (int i = 0; i < group.members.length; i++) {
                                        items.add(group.members[i]);
                                      }

                                      return GroupModal(group.name, items);
                                    }));
                                  },
                                )
                              : Container()
                        ],
                      ),
                    ],
                  )),
                  IgnorePointer(ignoring: true, child: AdvCheckboxWithText(value: _filteredGroups.indexOf(group) != -1))
                ]),
              ),
            );
          }).toList()),
    );
  }

  Widget _getContentPersonal(BuildContext context) {
    DateDict dict = DateDict.of(context);

    if (_reorderMode) {
      if (_filteredGroups.length == 1) {
        return _getSinglePersonal();
      } else {
        return _getDraggablePersonal();
      }
    } else {
      return _getCheckablePersonal(dict);
    }
  }

  Widget _getSinglePersonal() {
    return AdvColumn(children: [
      Container(
        child: AdvListTile(
          onTap: () {},
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          start: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CachedNetworkImage(
              imageUrl: _filteredMembers.first.photo,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          expanded: Text(_filteredMembers.first.name),
          end: Container(
            margin: EdgeInsets.all(4.0),
            width: 20.0,
            height: 20.0,
            decoration: ShapeDecoration(shape: CircleBorder(), color: systemPrimaryColor),
            child: Center(
                child: Text("${_filteredMembers.indexOf(_filteredMembers.first) + 1}", style: p5.copyWith(color: Colors.white))),
          ),
        ),
        color: Colors.white,
      ),
      (_filteredMembers.last == _filteredMembers.first)
          ? null
          : Container(height: 0.5, color: Colors.black54, margin: EdgeInsets.symmetric(horizontal: 16.0))
    ]);
  }

  Widget _getDraggablePersonal() {
    return DragAndDropList(
      _filteredMembers,
      canBeDraggedTo: (int oldIndex, int newIndex) {
        return true;
      },
      onDragFinish: (before, after) {
        var data = _filteredMembers[before];
        _filteredMembers.removeAt(before);
        _filteredMembers.insert(after, data);
      },
      dragElevation: 8.0,
      itemBuilder: (BuildContext context, Member member) {
        return AdvColumn(children: [
          Container(
            child: AdvListTile(
              onTap: () {},
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              start: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: CachedNetworkImage(
                  imageUrl: member.photo,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              expanded: Text(member.name),
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
                  "${_filteredMembers.indexOf(member) + 1}",
                  style: p5.copyWith(color: Colors.white),
                )),
              ),
            ),
            color: Colors.white,
          ),
          (_filteredMembers.last == member)
              ? null
              : Container(
                  height: 0.5,
                  color: Colors.black54,
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                )
        ]);
      },
    );
  }

  Widget _getCheckablePersonal(DateDict dict) {
    return SingleChildScrollView(
      child: AdvColumn(
          divider: Container(
            height: 0.5,
            color: Colors.black54,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          children: _allMembers.map((member) {
            return Container(
              child: AdvListTile(
                onTap: () {
                  setState(() {
                    if (_filteredMembers.indexOf(member) == -1) {
                      _filteredMembers.add(member);
                    } else {
                      _filteredMembers.remove(member);
                    }
                    _errNoParticipant = false;
                  });
                },
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                start: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(imageUrl: member.photo, width: 50.0, height: 50.0, fit: BoxFit.cover),
                ),
                expanded: Text(member.name),
                end: IgnorePointer(
                  ignoring: true,
                  child: AdvCheckboxWithText(value: _filteredMembers.indexOf(member) != -1),
                ),
              ),
              color: Colors.white,
            );
          }).toList()),
    );
  }
}

class GroupModal extends StatefulWidget {
  final String groupName;
  final List<Member> members;

  GroupModal(this.groupName, this.members);

  @override
  State<StatefulWidget> createState() => _GroupModalState();
}

class _GroupModalState extends State<GroupModal> {
  ScrollController _controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    timeDilation = 5;
    int counter = 0;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AdvDialog(
        onWillPop: _onWillPop,
        title: "Show Members",
        content: SingleChildScrollView(
          controller: _controller,
          child: AdvColumn(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              divider: Container(
                color: Colors.grey,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
              ),
              children: widget.members.map((member) {
                counter++;
                return AdvRow(divider: RowDivider(16.0), children: [
                  Hero(
                    tag: "MemberItem($counter-${widget.groupName})",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: CachedNetworkImage(
                        imageUrl: member.photo,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(member.name),
                ]);
              }).toList()),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    await _controller.animateTo(0.0, duration: Duration(milliseconds: 10), curve: Curves.ease);
    return true;
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_checkbox_with_text.dart';
import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/components/adv_dialog.dart';
import 'package:date_app/components/hero_dialog_route.dart';
import 'package:date_app/pages/add_event_member_reorder.dart';
import 'package:date_app/pages/add_event_setting.dart';
import 'package:date_app/pages/open_discussion.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/models.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_future_builder.dart';
import 'package:pit_components/components/adv_group_check.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/adv_loading_with_barrier.dart';
import 'package:pit_components/components/adv_radio_button.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/components/adv_state.dart';
import 'package:pit_components/components/controllers/adv_chooser_controller.dart';
import 'package:pit_components/mods/mod_checkbox.dart';
import 'package:pit_components/pit_components.dart';

//need to refactor efficiently
class AddEventParticipantPage extends StatefulWidget {
  final String name;
  final String description;
  final String location;
  final String startTime;
  final String endTime;
  final String type;

  AddEventParticipantPage({this.name, this.description, this.location, this.startTime, this.endTime, this.type});

  @override
  State<StatefulWidget> createState() => _AddEventParticipantPageState();
}

class _AddEventParticipantPageState extends AdvState<AddEventParticipantPage> {
  List<Member> _allMembers;
  List<Member> _filteredMembers = [];
  List<Group> _allGroups;
  List<Group> _filteredGroups = [];
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

    return Scaffold(
      appBar: AppBar(
        title: Text(dict.getString("add_participants")),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: AdvFutureBuilder(
        widgetBuilder: _widgetBuilder,
        futureExecutor: _loadAll,
      ),
    );
  }

  Future<bool> _loadAll(BuildContext context) async {
    _allMembers = await DataEngine.getMember();
    _allGroups = await DataEngine.getGroup();

    return true;
  }

  Widget _widgetBuilder(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return AdvLoadingWithBarrier(
        content: _allMembers == null || _allGroups == null
            ? Container()
            : Container(
                child: AdvColumn(children: [
                  Expanded(
                    child: AdvColumn(divider: ColumnDivider(16.0), margin: EdgeInsets.only(top: 16.0), children: [
                      AdvRow(margin: EdgeInsets.symmetric(horizontal: 16.0), children: [
                        Expanded(
                          child: AdvRadioGroup(
                            divider: 16.0,
                            controller: crowdTypeController,
                            callback: (crowdType) {
                              setState(() {
                                _crowdType = crowdType;

                                _filteredMembers.clear();
                                _filteredGroups.clear();
                              });
                            },
                          ),
                        ),
                        _filteredMembers.length == 1 && _filteredGroups.length == 1 ? null : _getActions(dict),
                      ]),
                      _errNoParticipant
                          ? Text(dict.getString("err_no_participant"), style: labelStyle.copyWith(color: systemRedColor))
                          : null,
                      Expanded(child: _crowdType == "personal" ? _getCheckablePersonal(context) : _getCheckableGroup(context))
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
                        List<Participant> participants;

                        if (_crowdType == "personal") {
                          participants = _filteredMembers.map((m) => Participant(id: "M${m.id}", name: m.name, photo: m.photo, type: ParticipantType.member, source: m)).toList();
                        } else {
                          participants = _filteredGroups.map((g) => Participant(id: "G${g.id}", name: g.name, photo: g.members.first.photo, type: ParticipantType.member, source: g)).toList();
                        }
                        Routing.push(
                            context,
                            AddEventMemberReorderPage(
                                name: widget.name,
                                description: widget.description,
                                location: widget.location,
                                startTime: widget.startTime,
                                endTime: widget.endTime,
                                type: widget.type,
                                crowdType: _crowdType,
                                selectedMember: participants));
                      },
                    ),
                  )
                ]),
              ),
        isProcessing: _allMembers == null || _allGroups == null);
  }

  Widget _getActions(DateDict dict) {
    String action = "check_all";

    if (_allMembers != null && _allGroups != null) {
      if (_crowdType == "personal") {
        action = _filteredMembers.length < _allMembers.length ? "check_all" : "uncheck_all";
      } else {
        action = _filteredGroups.length < _allGroups.length ? "check_all" : "uncheck_all";
      }
    }

    return InkWell(
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
    );
  }

  Widget _getCheckableGroup(BuildContext context) {
    DateDict dict = DateDict.of(context);

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
//                      Text("${group.name}${group.fixedGroup ? " (Fixed Group)" : ""}", style: h9),
                      Text("${group.name}", style: h9),
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

  Widget _getCheckablePersonal(BuildContext context) {
    DateDict dict = DateDict.of(context);

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

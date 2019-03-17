import 'dart:math';

import 'package:date_app/components/roundrect_checkbox.dart';
import 'package:date_app/utilities/global.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/models.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/pit_components.dart';

class AddEventPositionSettingPage extends StatefulWidget {
  final List<String> positions;
  final List<dynamic> participants;

  AddEventPositionSettingPage(this.positions, this.participants);

  @override
  State<StatefulWidget> createState() => _AddEventPositionSettingPageState();
}

class _AddEventPositionSettingPageState extends State<AddEventPositionSettingPage> {
  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(dict.getString("position_qualification_setting")),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: AdvColumn(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child: AdvColumn(
                        divider: Container(
                          height: 1.0,
                          color: Colors.black87,
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        children: widget.positions.map((position) {
                          if (widget.participants.first is Member) {
                            return MemberItem(position, widget.participants);
                          } else {
                            return GroupItem(position, widget.participants);
                          }
                        }).toList()))),
            Container(
                margin: EdgeInsets.all(18.0),
                child: AdvButton(
                  dict.getString("submit"),
                  width: double.infinity,
                ))
          ],
        ));
  }
}

class MemberItem extends StatefulWidget {
  final String position;
  final List<Member> members;

  MemberItem(this.position, this.members);

  @override
  State<StatefulWidget> createState() => _MemberItemState();
}

class _MemberItemState extends State<MemberItem> with TickerProviderStateMixin {
  AnimationController anim;
  List<Member> checkedMembers = [];

  @override
  void initState() {
    super.initState();

    anim = AnimationController(vsync: this, duration: kTabScrollDuration);
  }

//  AnimatedIcon(
//  icon: AnimatedIcons.menu_close,
//  color: Colors.white,
//  progress: _animateIcon,
//  )
  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);
    String description;

    if (checkedMembers.length == widget.members.length) {
      description = dict.getString("all_participants");
    } else if (checkedMembers.length == 1) {
      description = "1 ${dict.getString("participant")}";
    } else {
      description = "${checkedMembers.length} ${dict.getString("participants")}";
    }

    return AdvColumn(
        children: [
      AnimatedBuilder(
          animation: anim,
          builder: (BuildContext context, Widget child) {
            return InkWell(
                onTap: () {
                  if (anim.value == 0.0) {
                    anim.forward();
                  } else {
                    anim.reverse();
                  }
                },
                child: AdvRow(
                    padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 8.0, bottom: 8.0 - (anim.value * 4.0)),
                    children: [
                      Expanded(
                          child: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(widget.position, style: h7),
                        Text(description, style: p3),
                      ])),
                      AnimatedBuilder(
                        animation: anim,
                        child: Icon(Icons.keyboard_arrow_right),
                        builder: (BuildContext context, Widget child) {
                          return Transform.rotate(
                            angle: anim.value * 0.5 * pi,
                            child: child,
                          );
                        },
                      )
                    ]));
          })
    ]..add(SizeTransition(
            sizeFactor: anim,
            child: AdvColumn(
                  divider: Container(height: 0.5, color: Colors.black38),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  margin: EdgeInsets.only(left: 24.0, bottom: 8.0, right: 24.0),
                  children: widget.members.map((member) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            if (checkedMembers.indexOf(member) == -1) {
                              checkedMembers.add(member);
                            } else {
                              checkedMembers.remove(member);
                            }
                          });
                        },
                        child: AdvRow(margin: EdgeInsets.all(8.0), children: [
                          Expanded(child: Text(member.name)),
                          AbsorbPointer(
                              child: RoundRectCheckbox(
                            activeColor: systemPrimaryColor,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: checkedMembers.indexOf(member) != -1,
                            onChanged: (value) {},
                          ))
                        ]));
                  }).toList()),
            )));
  }
}

class GroupItem extends StatefulWidget {
  final String position;
  final List<Group> groups;

  GroupItem(this.position, this.groups);

  @override
  State<StatefulWidget> createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> with TickerProviderStateMixin {
  AnimationController anim;
  List<Group> checkedGroups = [];

  @override
  void initState() {
    super.initState();

    anim = AnimationController(vsync: this, duration: kTabScrollDuration);
  }

//  AnimatedIcon(
//  icon: AnimatedIcons.menu_close,
//  color: Colors.white,
//  progress: _animateIcon,
//  )
  @override
  Widget build(BuildContext context) {
    DateDict dict = DateDict.of(context);
    String description;

    if (checkedGroups.length == widget.groups.length) {
      description = dict.getString("all_participants");
    } else if (checkedGroups.length == 1) {
      description = "1 ${dict.getString("participant")}";
    } else {
      description = "${checkedGroups.length} ${dict.getString("participants")}";
    }

    return AdvColumn(
        children: [
          AnimatedBuilder(
              animation: anim,
              builder: (BuildContext context, Widget child) {
                return InkWell(
                    onTap: () {
                      if (anim.value == 0.0) {
                        anim.forward();
                      } else {
                        anim.reverse();
                      }
                    },
                    child: AdvRow(
                        padding: EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 8.0, bottom: 8.0 - (anim.value * 4.0)),
                        children: [
                          Expanded(
                              child: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(widget.position, style: h7),
                                Text(description, style: p3),
                              ])),
                          AnimatedBuilder(
                            animation: anim,
                            child: Icon(Icons.keyboard_arrow_right),
                            builder: (BuildContext context, Widget child) {
                              return Transform.rotate(
                                angle: anim.value * 0.5 * pi,
                                child: child,
                              );
                            },
                          )
                        ]));
              })
        ]..add(SizeTransition(
          sizeFactor: anim,
          child: AdvColumn(
              divider: Container(height: 0.5, color: Colors.black38),
              crossAxisAlignment: CrossAxisAlignment.start,
              margin: EdgeInsets.only(left: 24.0, bottom: 8.0, right: 24.0),
              children: widget.groups.map((group) {
                return InkWell(
                    onTap: () {
                      setState(() {
                        if (checkedGroups.indexOf(group) == -1) {
                          checkedGroups.add(group);
                        } else {
                          checkedGroups.remove(group);
                        }
                      });
                    },
                    child: AdvRow(margin: EdgeInsets.all(8.0), children: [
                      Expanded(child: Text(group.name)),
                      AbsorbPointer(
                          child: RoundRectCheckbox(
                            activeColor: systemPrimaryColor,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: checkedGroups.indexOf(group) != -1,
                            onChanged: (value) {},
                          ))
                    ]));
              }).toList()),
        )));
  }
}

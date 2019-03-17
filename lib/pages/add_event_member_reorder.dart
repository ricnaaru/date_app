import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_checkbox_with_text.dart';
import 'package:date_app/components/adv_chooser_dialog.dart';
import 'package:date_app/components/adv_dialog.dart';
import 'package:date_app/components/hero_dialog_route.dart';
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
class AddEventMemberReorderPage extends StatefulWidget {
  final String name;
  final String description;
  final String location;
  final String startTime;
  final String endTime;
  final String type;
  final String crowdType;
  final List<dynamic> selectedMember;

  AddEventMemberReorderPage(
      {this.name, this.description, this.location, this.startTime, this.endTime, this.type, this.crowdType, this.selectedMember});

  @override
  State<StatefulWidget> createState() => _AddEventMemberReorderPageState();
}

class _AddEventMemberReorderPageState extends AdvState<AddEventMemberReorderPage> {
  bool ascOrder = false;
  TextStyle labelStyle = PitComponents.getLabelTextStyle();

  @override
  Widget advBuild(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(dict.getString("add_participants_reorder")),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _widgetBuilder(context));
  }

  Widget _widgetBuilder(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return AdvColumn(children: [
      Expanded(
        child: AdvColumn(divider: ColumnDivider(16.0), margin: EdgeInsets.only(top: 16.0), children: [
          widget.selectedMember.length == 1
              ? null
              : AdvRow(
                  mainAxisAlignment: MainAxisAlignment.end,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  divider: RowDivider(8.0),
                  children: _getActions(dict)),
          Expanded(child: widget.crowdType == "personal" ? _getContentPersonal(context) : _getContentGroup(context))
        ]),
      ),
      Container(
        padding: EdgeInsets.all(16.0),
        child: AdvButton(
          dict.getString("next"),
          width: double.infinity,
          onPressed: () {
            Routing.push(
                context,
                AddEventSettingPage(
                  widget.selectedMember,
                  name: widget.name,
                  description: widget.description,
                  location: widget.location,
                  startTime: widget.startTime,
                  endTime: widget.endTime,
                  type: widget.type,
                ));
          },
        ),
      )
    ]);
  }

  List<Widget> _getActions(DateDict dict) {
    return [
      Expanded(child: Text(dict.getString("reorder_info"), style: labelStyle)),
      InkWell(
        child: Text(dict.getString("shuffle"), style: labelStyle.copyWith(color: systemHyperlinkColor)),
        onTap: () {
          setState(() {
            widget.selectedMember.shuffle();
          });
        },
      ),
      InkWell(
        child: Text(dict.getString(ascOrder ? "sort_z_a" : "sort_a_z"), style: labelStyle.copyWith(color: systemHyperlinkColor)),
        onTap: () {
          if (ascOrder) {
            widget.selectedMember.sort((item, otherItem) => otherItem.name.compareTo(item.name));
          } else {
            widget.selectedMember.sort((item, otherItem) => item.name.compareTo(otherItem.name));
          }

          ascOrder = !ascOrder;

          setState(() {});
        },
      )
    ];
  }

  Widget _getContentGroup(BuildContext context) {
    if (widget.selectedMember.length == 1) {
      return _getSingleGroup();
    } else {
      return _getDraggableGroup();
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
                  imageUrl: widget.selectedMember.first.members.first.photo, width: 50.0, height: 50.0, fit: BoxFit.cover)),
          expanded: Text(widget.selectedMember.first.name, style: h9),
          end: Container(
            margin: EdgeInsets.all(4.0),
            width: 20.0,
            height: 20.0,
            decoration: ShapeDecoration(shape: CircleBorder(), color: systemPrimaryColor),
            child: Center(
                child: Text("${widget.selectedMember.indexOf(widget.selectedMember.first) + 1}",
                    style: p5.copyWith(color: Colors.white))),
          ),
        ),
        color: Colors.white,
      ),
      (widget.selectedMember.last == widget.selectedMember.first)
          ? null
          : Container(height: 0.5, color: Colors.black54, margin: EdgeInsets.symmetric(horizontal: 16.0))
    ]);
  }

  Widget _getDraggableGroup() {
    return DragAndDropList(
      widget.selectedMember,
      canBeDraggedTo: (int oldIndex, int newIndex) {
        return true;
      },
      onDragFinish: (before, after) {
        var data = widget.selectedMember[before];
        widget.selectedMember.removeAt(before);
        widget.selectedMember.insert(after, data);
      },
      dragElevation: 8.0,
      itemBuilder: (BuildContext context, dynamic group) {
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
//                group.fixedGroup ? Text("Fixed Group", style: p4.copyWith(color: systemDarkerGreyColor)) : null
              ]),
              end: Container(
                margin: EdgeInsets.all(4.0),
                width: 20.0,
                height: 20.0,
                decoration: ShapeDecoration(shape: CircleBorder(), color: systemPrimaryColor),
                child:
                    Center(child: Text("${widget.selectedMember.indexOf(group) + 1}", style: p5.copyWith(color: Colors.white))),
              ),
            ),
            color: Colors.white,
          ),
          (widget.selectedMember.last == group)
              ? null
              : Container(height: 0.5, color: Colors.black54, margin: EdgeInsets.symmetric(horizontal: 16.0))
        ]);
      },
    );
  }

  Widget _getContentPersonal(BuildContext context) {
    if (widget.selectedMember.length == 1) {
      return _getSinglePersonal();
    } else {
      return _getDraggablePersonal();
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
              imageUrl: widget.selectedMember.first.photo,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          expanded: Text(widget.selectedMember.first.name),
          end: Container(
            margin: EdgeInsets.all(4.0),
            width: 20.0,
            height: 20.0,
            decoration: ShapeDecoration(shape: CircleBorder(), color: systemPrimaryColor),
            child: Center(
                child: Text("${widget.selectedMember.indexOf(widget.selectedMember.first) + 1}",
                    style: p5.copyWith(color: Colors.white))),
          ),
        ),
        color: Colors.white,
      ),
      (widget.selectedMember.last == widget.selectedMember.first)
          ? null
          : Container(height: 0.5, color: Colors.black54, margin: EdgeInsets.symmetric(horizontal: 16.0))
    ]);
  }

  Widget _getDraggablePersonal() {
    return DragAndDropList(
      widget.selectedMember,
      canBeDraggedTo: (int oldIndex, int newIndex) {
        return true;
      },
      onDragFinish: (before, after) {
        var data = widget.selectedMember[before];
        widget.selectedMember.removeAt(before);
        widget.selectedMember.insert(after, data);
      },
      dragElevation: 8.0,
      itemBuilder: (BuildContext context, dynamic member) {
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
                  "${widget.selectedMember.indexOf(member) + 1}",
                  style: p5.copyWith(color: Colors.white),
                )),
              ),
            ),
            color: Colors.white,
          ),
          (widget.selectedMember.last == member)
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
}

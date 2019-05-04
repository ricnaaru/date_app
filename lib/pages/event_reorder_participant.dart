import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/photo_image.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event_reorder_participant.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/pit_components.dart';

//need to refactor efficiently
class EventReorderParticipantPage extends StatefulWidget {
  final String crowdType;
  final EventModel event;

  EventReorderParticipantPage({this.crowdType, this.event});

  @override
  State<StatefulWidget> createState() => _EventReorderParticipantPageState();
}

class _EventReorderParticipantPageState extends View<EventReorderParticipantPage> {
  TextStyle labelStyle = PitComponents.getLabelTextStyle();
  EventReorderParticipantPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);

    _presenter = EventReorderParticipantPresenter(context, this, event: widget.event);
  }

  @override
  Widget buildView(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(dict.getString("add_participants_reorder")),
          elevation: 1.0,
        ),
        body: _widgetBuilder(context));
  }

  Widget _widgetBuilder(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return AdvColumn(children: [
      Expanded(
        child:
            AdvColumn(divider: ColumnDivider(16.0), margin: EdgeInsets.only(top: 16.0), children: [
          widget.event.participants.length == 1
              ? null
              : AdvRow(
                  mainAxisAlignment: MainAxisAlignment.end,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  divider: RowDivider(8.0),
                  children: _getActions(dict)),
          Expanded(
              child: widget.crowdType == "personal"
                  ? _getContentPersonal(context)
                  : _getContentGroup(context))
        ]),
      ),
      Container(
        padding: EdgeInsets.all(16.0),
        child: AdvButton(
          dict.getString("next"),
          width: double.infinity,
          onPressed: () {
            _presenter.nextPage();
          },
        ),
      )
    ]);
  }

  List<Widget> _getActions(DateDict dict) {
    return [
      Expanded(child: Text(dict.getString("reorder_info"), style: labelStyle)),
      InkWell(
        child: Text(dict.getString("shuffle"),
            style: labelStyle.copyWith(color: systemHyperlinkColor)),
        onTap: () {
          _presenter.shuffleParticipants();
        },
      ),
      InkWell(
        child: Text(_presenter.getSortAction(),
            style: labelStyle.copyWith(color: systemHyperlinkColor)),
        onTap: () {
          _presenter.sortParticipants();
        },
      )
    ];
  }

  Widget _getContentGroup(BuildContext context) {
    if (widget.event.participants.length == 1) {
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
          start: PhotoImage(
              imageUrl: widget.event.participants.first.photo,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover),
          expanded: Text(widget.event.participants.first.name, style: h9),
          end: Container(
            margin: EdgeInsets.all(4.0),
            width: 20.0,
            height: 20.0,
            decoration: ShapeDecoration(shape: CircleBorder(), color: CompanyColors.primary),
            child: Center(
                child: Text(
                    "${widget.event.participants.indexOf(widget.event.participants.first) + 1}",
                    style: p5.copyWith(color: Colors.white))),
          ),
        ),
        color: Colors.white,
      ),
      (widget.event.participants.last == widget.event.participants.first)
          ? null
          : Container(
              height: 0.5, color: Colors.black54, margin: EdgeInsets.symmetric(horizontal: 16.0))
    ]);
  }

  Widget _getDraggableGroup() {
    return DragAndDropList(
      widget.event.participants,
      canBeDraggedTo: (int oldIndex, int newIndex) => true,
      onDragFinish: (before, after) {
        _presenter.reorderParticipants(before, after);
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
                  child: CachedNetworkImage(
                      imageUrl: group.members.first.photo,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover)),
              expanded: AdvColumn(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(group.name, style: h9),
//                group.fixedGroup ? Text("Fixed Group", style: p4.copyWith(color: systemDarkerGreyColor)) : null
              ]),
              end: Container(
                margin: EdgeInsets.all(4.0),
                width: 20.0,
                height: 20.0,
                decoration: ShapeDecoration(shape: CircleBorder(), color: CompanyColors.primary),
                child: Center(
                    child: Text("${widget.event.participants.indexOf(group) + 1}",
                        style: p5.copyWith(color: Colors.white))),
              ),
            ),
            color: Colors.white,
          ),
          (widget.event.participants.last == group)
              ? null
              : Container(
                  height: 0.5,
                  color: Colors.black54,
                  margin: EdgeInsets.symmetric(horizontal: 16.0))
        ]);
      },
    );
  }

  Widget _getContentPersonal(BuildContext context) {
    if (widget.event.participants.length == 1) {
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
              imageUrl: widget.event.participants.first.photo,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          expanded: Text(widget.event.participants.first.name),
          end: Container(
            margin: EdgeInsets.all(4.0),
            width: 20.0,
            height: 20.0,
            decoration: ShapeDecoration(shape: CircleBorder(), color: CompanyColors.primary),
            child: Center(
                child: Text(
                    "${widget.event.participants.indexOf(widget.event.participants.first) + 1}",
                    style: p5.copyWith(color: Colors.white))),
          ),
        ),
        color: Colors.white,
      ),
      (widget.event.participants.last == widget.event.participants.first)
          ? null
          : Container(
              height: 0.5, color: Colors.black54, margin: EdgeInsets.symmetric(horizontal: 16.0))
    ]);
  }

  Widget _getDraggablePersonal() {
    return DragAndDropList(
      widget.event.participants,
      canBeDraggedTo: (int oldIndex, int newIndex) {
        return true;
      },
      onDragFinish: (before, after) {
        _presenter.reorderParticipants(before, after);
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
                  color: CompanyColors.primary,
                ),
                child: Center(
                    child: Text(
                  "${widget.event.participants.indexOf(member) + 1}",
                  style: p5.copyWith(color: Colors.white),
                )),
              ),
            ),
            color: Colors.white,
          ),
          (widget.event.participants.last == member)
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

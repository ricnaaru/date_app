import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_app/components/adv_dialog.dart';
import 'package:date_app/components/hero_dialog_route.dart';
import 'package:date_app/components/photo_image.dart';
import 'package:date_app/models.dart';
import 'package:date_app/presenters/event_add_participant.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/textstyles.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_button.dart';
import 'package:pit_components/components/adv_checkbox.dart';
import 'package:pit_components/components/adv_column.dart';
import 'package:pit_components/components/adv_list_tile.dart';
import 'package:pit_components/components/adv_loading_with_barrier.dart';
import 'package:pit_components/components/adv_radio_button.dart';
import 'package:pit_components/components/adv_row.dart';
import 'package:pit_components/pit_components.dart';

//need to refactor efficiently
class EventAddParticipantPage extends StatefulWidget {
  final EventSettingModel event;

  EventAddParticipantPage({this.event});

  @override
  State<StatefulWidget> createState() => _EventAddParticipantPageState();
}

class _EventAddParticipantPageState extends View<EventAddParticipantPage> {
//  AdvRadioGroupController crowdTypeController;
  TextStyle labelStyle = PitComponents.getLabelTextStyle();
  EventAddParticipantPresenter _presenter;

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);

    _presenter = EventAddParticipantPresenter(context, this, event: widget.event);
  }

  @override
  Widget buildView(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(dict.getString("add_participants")),
          elevation: 1.0,
        ),
        body: _widgetBuilder(context));
  }

  Widget _widgetBuilder(BuildContext context) {
    DateDict dict = DateDict.of(context);

    return AdvLoadingWithBarrier(
        content: _presenter.allMembers == null || _presenter.allGroups == null
            ? Container()
            : Container(
                child: AdvColumn(children: [
                  Expanded(
                    child: AdvColumn(
                        divider: ColumnDivider(16.0),
                        margin: EdgeInsets.only(top: 16.0),
                        children: [
                          AdvRow(margin: EdgeInsets.symmetric(horizontal: 16.0), children: [
                            Expanded(
                              child: AdvRadioGroup(
                                divider: 16.0,
                                controller: _presenter.crowdTypeController,
                                callback: (crowdType) {
                                  _presenter.onCrowdTypeChanged(crowdType);
                                },
                              ),
                            ),
                            _presenter.selectedMembers.length == 1 &&
                                    _presenter.selectedGroups.length == 1
                                ? null
                                : _getActions(),
                          ]),
                          _presenter.errorNoParticipantSelected
                              ? Text(dict.getString("err_no_participant"),
                                  style: labelStyle.copyWith(color: systemRedColor))
                              : null,
                          Expanded(
                              child: _presenter.crowdType == "personal"
                                  ? _getCheckablePersonal(context)
                                  : _getCheckableGroup(context))
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
                ]),
              ),
        isProcessing: _presenter.allMembers == null || _presenter.allGroups == null);
  }

  Widget _getActions() {
    String action = _presenter.getActionString();

    return InkWell(
      child: Text(action, style: labelStyle.copyWith(color: systemHyperlinkColor)),
      onTap: () {
        _presenter.checkAction();
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
          children: _presenter.allGroups.map((GroupModel group) {
            return Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  _presenter.onGroupSelected(group);
                },
                child: AdvRow(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    children: [
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
                                  group.membersId.length >= 3
                                      ? Hero(
                                          tag: "MemberItem(3-${group.name})",
                                          child: Container(
                                            margin: EdgeInsets.only(left: 70.0),
                                            child: PhotoImage(
                                                imageUrl:
                                                    _presenter.getMemberPhoto(group.membersId[2]),
                                                width: 50.0,
                                                height: 50.0,
                                                fit: BoxFit.cover),
                                          ),
                                        )
                                      : Container(),
                                  group.membersId.length >= 2
                                      ? Hero(
                                          tag: "MemberItem(2-${group.name})",
                                          child: Container(
                                            margin: EdgeInsets.only(left: 30.0),
                                            child: PhotoImage(
                                                imageUrl:
                                                    _presenter.getMemberPhoto(group.membersId[1]),
                                                width: 50.0,
                                                height: 50.0,
                                                fit: BoxFit.cover),
                                          ),
                                        )
                                      : Container(),
                                  Hero(
                                      tag: "MemberItem(1-${group.name})",
                                      child: PhotoImage(
                                          imageUrl: _presenter.getMemberPhoto(group.membersId[0]),
                                          width: 50.0,
                                          height: 50.0,
                                          fit: BoxFit.cover)),
                                ]),
                              ),
                              group.membersId.length > 3
                                  ? InkWell(
                                      child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(dict.getString("and_more"),
                                              style: TextStyle(color: systemHyperlinkColor))),
                                      onTap: () {
                                        Navigator.push(context,
                                            new HeroDialogRoute(builder: (BuildContext context) {
                                          List<MemberModel> members =
                                              _presenter.getMemberList(group);

                                          return GroupModal(group.name, members);
                                        }));
                                      },
                                    )
                                  : Container()
                            ],
                          ),
                        ],
                      )),
                      IgnorePointer(
                          ignoring: true,
                          child: AdvCheckbox(value: _presenter.selectedGroups.indexOf(group) != -1))
                    ]),
              ),
            );
          }).toList()),
    );
  }

  Widget _getCheckablePersonal(BuildContext context) {
    return SingleChildScrollView(
      child: AdvColumn(
          divider: Container(
            height: 0.5,
            color: Colors.black54,
            margin: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          children: _presenter.allMembers.map((member) {
            return Container(
              child: AdvListTile(
                onTap: () {
                  _presenter.onMemberSelected(member);
                },
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                start: PhotoImage(
                    imageUrl: member.photo, width: 50.0, height: 50.0, fit: BoxFit.cover),
                expanded: Text(member.name),
                end: IgnorePointer(
                  ignoring: true,
                  child: AdvCheckbox(value: _presenter.selectedMembers.indexOf(member) != -1),
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
  final List<MemberModel> members;

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
                    child: PhotoImage(
                      imageUrl: member.photo,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
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

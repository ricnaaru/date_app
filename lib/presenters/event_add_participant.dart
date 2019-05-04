import 'package:date_app/models.dart';
import 'package:date_app/pages/event_reorder_participant.dart';
import 'package:date_app/presenter.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/firebase_database_engine.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/routing.dart';
import 'package:date_app/view.dart';
import 'package:flutter/material.dart';
import 'package:pit_components/components/adv_radio_button.dart';
import 'package:pit_components/components/adv_row.dart';

class EventAddParticipantPresenter extends Presenter {
  AdvRadioGroupController _crowdTypeController;
  List<MemberModel> _allMembers;
  List<MemberModel> _selectedMembers = [];
  List<GroupModel> _allGroups;
  List<GroupModel> _selectedGroups = [];
  String _crowdType = "personal";
  bool _errorNoParticipantSelected = false;
  EventModel _event;

  EventAddParticipantPresenter(BuildContext context, View<StatefulWidget> view, {EventModel event})
      : this._event = event,
        super(context, view);

  @override
  void init() {
    DateDict dict = DateDict.of(context);

    String personal = dict.getString("personal");
    String group = dict.getString("group");

    _crowdTypeController = AdvRadioGroupController(checkedValue: "personal", itemList: [
      RadioGroupItem(
        "personal",
        activeItem: AdvRow(divider: RowDivider(4.0), children: [
          Icon(Icons.person, color: CompanyColors.primary),
          Text(personal, style: TextStyle(color: CompanyColors.primary))
        ]),
        inactiveItem: AdvRow(divider: RowDivider(4.0), children: [
          Icon(Icons.person, color: Colors.black54),
          Text(personal, style: TextStyle(color: Colors.black54))
        ]),
      ),
      RadioGroupItem(
        "group",
        activeItem: AdvRow(divider: RowDivider(4.0), children: [
          Icon(Icons.group, color: CompanyColors.primary),
          Text(group, style: TextStyle(color: CompanyColors.primary))
        ]),
        inactiveItem: AdvRow(divider: RowDivider(4.0), children: [
          Icon(Icons.group, color: Colors.black54),
          Text(group, style: TextStyle(color: Colors.black54))
        ]),
      ),
    ]);
    DataEngine.getMembers(context).then((result) {
      _allMembers = result;
      view.refresh();
    });
    DataEngine.getGroups(context).then((result) {
      _allGroups = result;
      view.refresh();
    });
  }

  void nextPage() {
    if (_selectedMembers.length == 0 && _selectedGroups.length == 0) {
      _errorNoParticipantSelected = true;
      view.refresh();
      return;
    }

    List<ParticipantModel> participants;

    if (_crowdType == "personal") {
      participants = _selectedMembers
          .map((member) => ParticipantModel(
              id: "M${member.id}",
              name: member.name,
              photo: member.photo,
              type: ParticipantType.member,
              sourceId: member.id))
          .toList();
    } else {
      participants = _selectedGroups
          .map((g) => ParticipantModel(
              id: "G${g.id}",
              name: g.name,
              photo: g.photo,
              type: ParticipantType.member,
              sourceId: g.id))
          .toList();
    }

    _event = _event.copyWith(participants: participants);

    Routing.push(
        context,
        EventReorderParticipantPage(
          event: _event,
          crowdType: _crowdType,
        ));
  }

  List<MemberModel> get allMembers => _allMembers;

  List<GroupModel> get allGroups => _allGroups;

  List<MemberModel> get selectedMembers => _selectedMembers;

  List<GroupModel> get selectedGroups => _selectedGroups;

  String get crowdType => _crowdType;

  bool get errorNoParticipantSelected => _errorNoParticipantSelected;

  AdvRadioGroupController get crowdTypeController => _crowdTypeController;

  void onCrowdTypeChanged(String crowdType) {
    _crowdType = crowdType;

    _selectedMembers.clear();
    _selectedGroups.clear();
    view.refresh();
  }

  void checkAction() {
    if (_crowdType == "personal") {
      if (_selectedMembers.length < _allMembers.length) {
        _selectedMembers = _allMembers;
      } else {
        _selectedMembers = [];
      }
    } else {
      if (_selectedGroups.length < _allGroups.length) {
        _selectedGroups = _allGroups;
      } else {
        _selectedGroups = [];
      }
    }
    _errorNoParticipantSelected = false;

    view.refresh();
  }

  String getActionString() {
    String action = "check_all";

    if (_allMembers != null && _allGroups != null) {
      if (_crowdType == "personal") {
        action = _selectedMembers.length < _allMembers.length ? "check_all" : "uncheck_all";
      } else {
        action = _selectedGroups.length < _allGroups.length ? "check_all" : "uncheck_all";
      }
    }

    return dict.getString(action);
  }

  String getMemberPhoto(String memberId) {
    String memberPhoto = "";

    _allMembers.forEach((member) {
      if (member.id == memberId) {
        memberPhoto = member.photo;
      }
    });

    return memberPhoto;
  }

  List<MemberModel> getMemberList(GroupModel group) {
    return group.membersId.map((memberId) {
      return _allMembers.firstWhere((allMember) => allMember.id == memberId);
    });
  }

  void onGroupSelected(GroupModel group) {
    if (_selectedGroups.indexOf(group) == -1) {
      _selectedGroups.add(group);
      _errorNoParticipantSelected = false;
    } else {
      _selectedGroups.remove(group);
    }

    view.refresh();
  }

  void onMemberSelected(MemberModel member) {
    if (_selectedMembers.indexOf(member) == -1) {
      _selectedMembers.add(member);
      _errorNoParticipantSelected = false;
    } else {
      _selectedMembers.remove(member);
    }

    view.refresh();
  }
}

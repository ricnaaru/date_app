import 'package:date_app/models.dart';
import 'package:date_app/utilities/constants.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/pref_keys.dart' as prefKeys;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataEngine {
  static Future<bool> postMember(MemberModel member) async {
    DatabaseReference membersRef =
    await FirebaseDatabase.instance.reference().child("members").push();

    await membersRef.set(member.toMap());

    DatabaseReference quickMembersRef =
    await FirebaseDatabase.instance.reference().child("quick_members/${member.username}");

    await quickMembersRef.set(<String, dynamic>{
      "PK": membersRef.key,
      "password": member.password,
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(prefKeys.kUserId, membersRef.key);

    return true;
  }

  static Future<bool> postGroup(GroupModel group) async {
    DatabaseReference groupsRef =
    await FirebaseDatabase.instance.reference().child("groups").push();

    await groupsRef.set(group.toMap());

    return true;
  }

  static Future<bool> testPost() async {
    DatabaseReference membersRef =
    await FirebaseDatabase.instance.reference().child("tests").push();

    await membersRef.set(<String, dynamic>{
      "name": ["test1", "test2", "test3"],
      "birthday": [1, 2, 3],
    });

    return true;
  }

  static Future<bool> login(String username, String password) async {
    DataSnapshot quickMembersRef =
        await FirebaseDatabase.instance.reference().child("quick_members/$username").once();

    Map v = quickMembersRef.value;

    if (v == null) return false;

    String primaryKey;
    String realPassword;

    v.forEach((key, value) {
      print("$password != $realPassword => $key");
      if (key == "PK") {
        primaryKey = value;
      } else if (key == "password") {
        realPassword = value;
      }
    });
    print("$password != $realPassword => $primaryKey");
    if (password != realPassword) return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(prefKeys.kUserId, primaryKey);

    return true;
  }

  static Future<List<NewsFeedModel>> getNewsFeed(BuildContext context) async {
    DataSnapshot quickMembersRef =
    await FirebaseDatabase.instance.reference().child("newsfeed").once();

    Map v = quickMembersRef.value;

    if (v == null) return [];

    String language = DateDict.of(context).locale.languageCode;
    List<NewsFeedModel> result = [];

    v.forEach((key, value) {
      String id = key;

      var content = value[language];
      String type = value["type"];

      if (content != null) {
        if (type == "post") {
          result.add(PostModel.fromJson(id, content));
        }
      }
    });

    return result;
  }

  static Future<List<EventModel>> getEvent(BuildContext context) async {
    DataSnapshot quickEventsRef =
    await FirebaseDatabase.instance.reference().child("events").once();

    Map v = quickEventsRef.value;

    if (v == null) return [];

    List<EventModel> events = [];

    v.forEach((key, value) {
      events.add(EventModel.fromJson(key, value));
    });

    return events;
  }

  static Future<List<MemberModel>> getMembers(BuildContext context) async {
    DataSnapshot membersRef =
    await FirebaseDatabase.instance.reference().child("members").once();

    Map v = membersRef.value;

    if (v == null) return [];

    List<MemberModel> members = [];
    v.forEach((key, value) {
      print("members => $key, $value");
      members.add(MemberModel.fromJson(key, value));
    });

    return members;
  }

  static Future<List<GroupModel>> getGroups(BuildContext context) async {
    DataSnapshot groupsRef =
    await FirebaseDatabase.instance.reference().child("groups").once();

    Map v = groupsRef.value;

    if (v == null) return [];

    List<GroupModel> groups = [];

    v.forEach((key, value) {
      groups.add(GroupModel.fromJson(key, value));
    });

    return groups;
  }
}

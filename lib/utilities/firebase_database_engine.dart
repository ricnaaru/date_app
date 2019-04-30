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
    List<Map<String, dynamic>> occupationMap = [];
    for (OccupationModel occupation in member.occupations) {
      occupationMap.add(occupation.toMap());
    }

    await membersRef.set(<String, dynamic>{
      "name": member.name,
      "birthday": kServerDateFormat.format(member.birthday),
      "show_birthday": member.showBirthday,
      "address": member.address,
      "status": member.status,
      "email": member.email,
      "phone_number": member.phoneNumber,
      "occupations": occupationMap,
      "have_been_baptized": member.haveBeenBaptized,
      "church": member.church,
      "date_of_baptize": kServerDateFormat.format(member.dateOfBaptize),
      "join_jpcc_since": kServerDateFormat.format(member.joinJpccSince),
      "class_history": member.classHistory,
      "username": member.username,
      "password": member.password,
    });

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
}

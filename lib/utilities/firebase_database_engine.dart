import 'package:date_app/models.dart';
import 'package:date_app/utilities/localization.dart';
import 'package:date_app/utilities/pref_keys.dart' as prefKeys;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataEngine {
  static Future<bool> postMember(MemberModel member) async {
    DatabaseReference membersRef = FirebaseDatabase.instance.reference().child("members").push();

    await membersRef.set(member.toMap());

    DatabaseReference birthdaysRef =
        FirebaseDatabase.instance.reference().child("birthdays/${membersRef.key}");

    await birthdaysRef.set(<String, dynamic>{
      "date": member.birthday,
      "name": member.name,
    });

    DatabaseReference quickMembersRef =
        FirebaseDatabase.instance.reference().child("quick_members/${member.username}");

    await quickMembersRef.set(<String, dynamic>{
      "PK": membersRef.key,
      "password": member.password,
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(prefKeys.kUserId, membersRef.key);

    return true;
  }

  static Future<bool> postGroup(GroupModel group) async {
    DatabaseReference groupsRef = FirebaseDatabase.instance.reference().child("groups").push();

    await groupsRef.set(group.toMap());

    return true;
  }

  static Future<String> postEventSetting(EventSettingModel event) async {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.reference().child("event_settings").push();

    await eventRef.set(event.toMap());

    if (event.positions != null) {
      DatabaseReference positionRef = eventRef.child("positions");

      for (PositionModel position in event.positions) {
        if ((position.name ?? "").isEmpty) continue;

        DatabaseReference eachPositionRef = positionRef.push();

        eachPositionRef.set({
          "name": position.name,
          "qty": position.qty,
        });
      }
    }

    return eventRef.key;
  }

  static Future<bool> testPost() async {
    DatabaseReference membersRef = FirebaseDatabase.instance.reference().child("tests").push();

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

  static Future<List<EventSettingModel>> getEventSettings(BuildContext context) async {
    DataSnapshot quickEventsRef =
        await FirebaseDatabase.instance.reference().child("event_settings").once();

    Map v = quickEventsRef.value;

    if (v == null) return [];

    List<EventSettingModel> events = [];

    v.forEach((key, value) {
      events.add(EventSettingModel.fromJson(key, value));
    });

    return events;
  }

  static Future<List<BirthdayModel>> getBirthday(BuildContext context) async {
    DataSnapshot quickEventsRef =
        await FirebaseDatabase.instance.reference().child("birthdays").once();

    Map v = quickEventsRef.value;

    if (v == null) return [];

    List<BirthdayModel> birthdays = [];

    v.forEach((key, value) {
      birthdays.add(BirthdayModel.fromJson(key, value));
    });

    return birthdays;
  }

  static Future<List<HolidayModel>> getHoliday(BuildContext context) async {
    DataSnapshot quickEventsRef =
    await FirebaseDatabase.instance.reference().child("holidays").once();

    Map v = quickEventsRef.value;

    if (v == null) return [];

    List<HolidayModel> holidays = [];

    v.forEach((key, value) {
      holidays.add(HolidayModel.fromJson(key, value));
    });

    return holidays;
  }

  static Future<List<EventModel>> getEvent(BuildContext context) async {
    DataSnapshot eventsRef =
    await FirebaseDatabase.instance.reference().child("events").once();

    Map v = eventsRef.value;

    if (v == null) return [];

    List<EventModel> events = [];

    v.forEach((key, value) {
      events.add(EventModel.fromJson(key, value));
    });

    return events;
  }

  static Future<List<MemberModel>> getMembers(BuildContext context) async {
    DataSnapshot membersRef = await FirebaseDatabase.instance.reference().child("members").once();

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
    DataSnapshot groupsRef = await FirebaseDatabase.instance.reference().child("groups").once();

    Map v = groupsRef.value;

    if (v == null) return [];

    List<GroupModel> groups = [];

    v.forEach((key, value) {
      groups.add(GroupModel.fromJson(key, value));
    });

    return groups;
  }

  static Future<List<EventModel>> generatePersonalEvent(EventSettingModel eventSetting) async {
    List<EventModel> events = [];

    if (eventSetting.interval == IntervalType.once) {
      EventModel event = EventModel(
        eventSettingId: eventSetting.id,
        name: eventSetting.name,
        description: eventSetting.description,
        location: eventSetting.location,
        startTime: eventSetting.startTime,
        endTime: eventSetting.endTime,
        startDate: eventSetting.startDate,
        endDate: eventSetting.endDate,
        eventMaster: eventSetting.eventMaster,
      );

      events.add(event);
    } else if (eventSetting.interval == IntervalType.daily ||
        eventSetting.interval == IntervalType.weekly ||
        eventSetting.interval == IntervalType.custom) {
      int durationInterval = eventSetting.endDate.difference(eventSetting.startDate).inDays;
      int daysInterval = eventSetting.interval == IntervalType.daily
          ? 1
          : eventSetting.interval == IntervalType.weekly
              ? 7
              : eventSetting.interval == IntervalType.custom ? eventSetting.customDays : 0;
      DateTime startDate = eventSetting.startDate;

      while (startDate.isBefore(eventSetting.lastGenerateDate)) {
        print("startDate => $startDate");
        EventModel event = EventModel(
          eventSettingId: eventSetting.id,
          name: eventSetting.name,
          description: eventSetting.description,
          location: eventSetting.location,
          startTime: eventSetting.startTime,
          endTime: eventSetting.endTime,
          startDate: startDate,
          endDate: startDate.add(Duration(days: durationInterval)),
          eventMaster: eventSetting.eventMaster,
        );

        events.add(event);

        startDate = startDate.add(Duration(days: daysInterval));
      }
    } else if (eventSetting.interval == IntervalType.monthly ||
        eventSetting.interval == IntervalType.annual) {
      int durationInterval = eventSetting.endDate.difference(eventSetting.startDate).inDays;
      DateTime startDate = eventSetting.startDate;

      while (startDate.compareTo(eventSetting.lastGenerateDate) <= 0) {
        print("startDate => $startDate");
        EventModel event = EventModel(
          eventSettingId: eventSetting.id,
          name: eventSetting.name,
          description: eventSetting.description,
          location: eventSetting.location,
          startTime: eventSetting.startTime,
          endTime: eventSetting.endTime,
          startDate: startDate,
          endDate: startDate.add(Duration(days: durationInterval)),
          eventMaster: eventSetting.eventMaster,
        );

        events.add(event);

        int nextMonth;
        int nextYear;
        int nextDay;

        if (eventSetting.interval == IntervalType.monthly) {
          nextMonth = (startDate.month + 1) > 12 ? 1 : (startDate.month + 1);
          nextYear = startDate.month + 1 > 12 ? startDate.year + 1 : startDate.year;
          nextDay = startDate.day;
        } else if (eventSetting.interval == IntervalType.annual) {
          nextMonth = startDate.month;
          nextYear = startDate.year + 1;
          nextDay = startDate.day;
        }

        startDate = DateTime(nextYear, nextMonth, nextDay);
      }
    }

    for (EventModel event in events) {
      DatabaseReference eventRef =
      FirebaseDatabase.instance.reference().child("events").push();

      await eventRef.set(event.toMap());
    }

    return events;
  }
}

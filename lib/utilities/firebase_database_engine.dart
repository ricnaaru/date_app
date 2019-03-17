import 'package:date_app/utilities/models.dart';
import 'package:firebase_database/firebase_database.dart';

class DataEngine {
  static Future<List<Member>> getMember() async {
    List<Member> members = [];
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("members").once();
    Map<dynamic, dynamic> data = snapshot.value;

    List<String> keys = data.keys.toList().cast<String>();

    keys.sort((var a, var b) => a.compareTo(b));

    for (String key in keys) {
      members.add(Member.fromJson(key, data[key]));
    }

    return members;
  }
  static Future<List<Birthday>> getBirthday() async {
    List<Birthday> birthdays = [];
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("birthdays").once();
    Map<dynamic, dynamic> data = snapshot.value;

    List<String> keys = data.keys.toList().cast<String>();

    keys.sort((var a, var b) => a.compareTo(b));

    for (String key in keys) {
      print("birthday => ${Birthday.fromJson(key, data[key])}");
      birthdays.add(Birthday.fromJson(key, data[key]));
    }

    return birthdays;
  }

  static Future<List<Holiday>> getHoliday() async {
    List<Holiday> holidays = [];
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("holidays").once();
    Map<dynamic, dynamic> data = snapshot.value;

    List<String> keys = data.keys.toList().cast<String>();

    keys.sort((var a, var b) => a.compareTo(b));

    for (String key in keys) {
      holidays.add(Holiday.fromJson(key, data[key]));
    }

    return holidays;
  }

  static Future<List<Group>> getGroup() async {
    List<Group> groups = [];
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("groups").once();
    Map<dynamic, dynamic> data = snapshot.value;

    List<String> keys = data.keys.toList().cast<String>();

    keys.sort((var a, var b) => a.compareTo(b));

    for (String key in keys) {
      groups.add(Group.fromJson(key, data[key]));
    }

    return groups;
  }

  static Future<List<Availability>> getAvailabilities() async {
    List<Availability> availabilities = [];
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("availabilities").once();
    Map<dynamic, dynamic> data = snapshot.value;
    print("data => ${data}");

    List<String> keys = data.keys.toList().cast<String>();

    keys.sort((var a, var b) => a.compareTo(b));

    for (String key in keys) {
      availabilities.add(Availability.fromJson(key, data[key]));
    }

    return availabilities;
  }
}

import 'package:date_app/utilities/datetime_helper.dart';

enum EventCategory { birthday, holiday, date, jpcc, group, personal }

class Event {
  final String id;
  final String name;
  final EventCategory category;

  Event({this.id, this.name, this.category});

  factory Event.fromBirthday(Birthday birthday) {
    return Event(
      id: birthday.id,
      name: birthday.name,
      category: EventCategory.birthday,
    );
  }

  factory Event.fromHoliday(Holiday holiday) {
    return Event(
      id: holiday.id,
      name: holiday.name,
      category: EventCategory.holiday,
    );
  }

  @override
  String toString() {
    return "Event (id: $id, name: $name, category: $category)";
  }
}

class Birthday {
  final String id;
  final String name;
  final DateTime date;

  Birthday({this.id, this.name, this.date});

  factory Birthday.fromJson(String id, Map json) {
    return Birthday(
      id: id,
      name: json['name'] as String,
      date: DateTimeHelper.convertFirebaseDate(json['date_of_birth']),
    );
  }

  @override
  String toString() {
    return "Birthday (id: $id, name: $name, date: $date)";
  }
}

enum HolidayPeriod { once, annual }

class Holiday {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final HolidayPeriod period;

  Holiday({this.id, this.name, this.startDate, this.endDate, this.period});

  factory Holiday.fromJson(String id, Map json) {
    Map<String, HolidayPeriod> holidayTypeDict = {"once": HolidayPeriod.once, "annual": HolidayPeriod.annual};

    return Holiday(
      id: id,
      name: json['name'] as String,
      startDate: DateTimeHelper.convertFirebaseDate(json['start_date']),
      endDate: DateTimeHelper.convertFirebaseDate(json['end_date']),
      period: holidayTypeDict[json['period']],
    );
  }

  @override
  String toString() {
    return "Holiday (id: $id, name: $name, startDate: $startDate, endDate: $endDate, type: $period)";
  }
}

class Member {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime birthday;
  final String photo;

  Member({this.id, this.name, this.email, this.phone, this.birthday, this.photo});

  factory Member.fromJson(String id, Map json) {
    return Member(
      id: id,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      birthday: DateTimeHelper.convertFirebaseDate(json['date_of_birth']),
      photo: json['photo'] as String,
    );
  }

  @override
  String toString() {
    return "Member (id: $id, name: $name, email: $email, phone: $phone, birthday: $birthday, photo: $photo)";
  }
}

class Group {
  final String id;
  final String name;
  final List<Member> members;

  Group({this.id, this.name, this.members});

  factory Group.fromJson(String id, Map json) {
    List<Member> members = [];
    Map rawMembers = json['members'];
    rawMembers.forEach((key, value) {
      members.add(Member.fromJson(key, value));
    });

    return Group(
      id: id,
      name: json['name'] as String,
      members: members,
    );
  }

  @override
  String toString() {
    return "Group (id: $id, name: $name, members: $members)";
  }
}

class Position {
  final String id;
  final String name;
  final int qty;
  final List<Member> members;

  Position({this.id, this.name, this.qty, this.members});

  factory Position.fromJson(String id, Map json) {
    List<Member> members = [];
    Map rawMembers = json['members'];
    rawMembers.forEach((key, value) {
      members.add(Member.fromJson(key, value));
    });

    return Position(
      id: id,
      name: json['name'] as String,
      qty: (json['name'] as num).toInt(),
      members: members,
    );
  }

  @override
  String toString() {
    return "Position (id: $id, name: $name, qty: $qty, members: $members)";
  }
}

class Availability {
  final String id;
  final Member member;
  final List<DateTime> availableDates;

  Availability({this.id, this.member, this.availableDates});

  factory Availability.fromJson(String id, Map json) {
    List<DateTime> availableDates = [];
    Map rawAvailableDates = json['available_dates'];
    Map rawMember = json['member'];

    rawAvailableDates.forEach((key, value) {
      if (value)
      availableDates.add(DateTimeHelper.convertFirebaseDate(int.tryParse(key)));
    });

    return Availability(
      id: id,
      member: Member.fromJson(rawMember.keys.first, rawMember.values.first),
      availableDates: availableDates,
    );
  }

  @override
  String toString() {
    return "Availability (id: $id, member: $member, availableDates: $availableDates)";
  }
}

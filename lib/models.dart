import 'package:date_app/utilities/datetime_helper.dart';
import 'package:flutter/material.dart';

enum OccupationType {
  college,
  job,
  business,
}

enum NewsFeedType {
  post,
  voting,
}

enum ParticipantType { member, group }

enum EventCategory { date, jpcc, group, personal }

enum HolidayIntervalType { once, annual }

enum IntervalType { once, daily, weekly, monthly, annual, custom }

enum EventStatus { waiting, generated, ready }

const Map<String, EventStatus> eventStatusMap = {
  "Waiting": EventStatus.waiting,
  "Generated": EventStatus.generated,
  "Ready": EventStatus.ready,
};

const Map<String, HolidayIntervalType> holidayIntervalTypeMap = {
  "Once": HolidayIntervalType.once,
  "Annual": HolidayIntervalType.annual,
};

const Map<String, IntervalType> intervalTypeMap = {
  "Once": IntervalType.once,
  "Daily": IntervalType.daily,
  "Weekly": IntervalType.weekly,
  "Monthly": IntervalType.monthly,
  "Annual": IntervalType.annual,
  "Custom": IntervalType.custom,
};

const Map<String, EventCategory> eventCategoryMap = {
  "DATE": EventCategory.date,
  "JPCC": EventCategory.jpcc,
  "Group": EventCategory.group,
  "Personal": EventCategory.personal,
};

const Map<String, ParticipantType> participantTypeMap = {
  "Member": ParticipantType.member,
  "Group": ParticipantType.group,
};

abstract class OccupationModel {
  final OccupationType _type;

  OccupationModel(this._type);

  Map<String, dynamic> toMap();
}

abstract class NewsFeedModel {
  final NewsFeedType _type;
  final String _id;

  NewsFeedModel(this._type, this._id);

  String get id => _id;

  NewsFeedType get type => _type;
}

class MemberModel {
  final String id;
  final String name;
  final DateTime birthday;
  final bool showBirthday;
  final String address;
  final String status;
  final String email;
  final String phoneNumber;
  final List<OccupationModel> occupations;
  final bool haveBeenBaptized;
  final String church;
  final DateTime dateOfBaptize;
  final DateTime joinJpccSince;
  final List<String> classHistory;
  final String username;
  final String password;
  final String photo;

  MemberModel({
    this.id,
    this.name,
    this.birthday,
    this.showBirthday,
    this.address,
    this.status,
    this.email,
    this.phoneNumber,
    this.occupations,
    this.haveBeenBaptized,
    this.church,
    this.dateOfBaptize,
    this.joinJpccSince,
    this.classHistory,
    this.username,
    this.password,
    this.photo,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> occupationMap = [];
    for (OccupationModel occupation in this.occupations) {
      occupationMap.add(occupation.toMap());
    }
    return <String, dynamic>{
      "name": this.name,
      "birthday": DateTimeHelper.convertToFirebaseDate(this.birthday),
      "show_birthday": this.showBirthday,
      "address": this.address,
      "status": this.status,
      "email": this.email,
      "phone_number": this.phoneNumber,
      "occupations": occupationMap,
      "have_been_baptized": this.haveBeenBaptized,
      "church": this.church,
      "date_of_baptize": DateTimeHelper.convertToFirebaseDate(this.dateOfBaptize),
      "join_jpcc_since": DateTimeHelper.convertToFirebaseDate(this.joinJpccSince),
      "class_history": this.classHistory,
      "username": this.username,
      "password": this.password,
      "photo": this.photo,
    };
  }

  factory MemberModel.fromJson(String id, Map json) {
    List rawOccupations = json["occupations"];
    List classHistory = List<String>.from(json["class_history"]);
    List<OccupationModel> occupations = [];

    rawOccupations.map((raw) {
      String type = raw["type"];

      if (type == "College") {
        occupations.add(CollegeModel.fromJson(raw));
      } else if (type == "Job") {
        occupations.add(JobModel.fromJson(raw));
      } else if (type == "Business") {
        occupations.add(BusinessModel.fromJson(raw));
      }
    });

    return MemberModel(
      id: id,
      name: json['name'] as String,
      birthday: DateTimeHelper.convertFromFirebaseDate(json['birthday'] as String),
      showBirthday: json['show_birthday'] as bool,
      address: json['address'] as String,
      status: json['status'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      occupations: occupations,
      haveBeenBaptized: json['have_been_baptized'] as bool,
      church: json['church'] as String,
      dateOfBaptize: DateTimeHelper.convertFromFirebaseDate(json['date_of_baptize'] as String),
      joinJpccSince: DateTimeHelper.convertFromFirebaseDate(json['join_jpcc_since'] as String),
      classHistory: classHistory,
      username: json['username'] as String,
      password: json['password'] as String,
      photo: json['photo'] as String,
    );
  }
}

class CollegeModel extends OccupationModel {
  final String university;
  final String major;
  final String degree;
  final int semester;
  final DateTime classYear;

  CollegeModel({
    this.university,
    this.major,
    this.degree,
    this.semester,
    this.classYear,
  }) : super(OccupationType.college);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': "College",
      'university': university,
      'major': major,
      'degree': degree,
      'semester': semester,
      'class_year': DateTimeHelper.convertToFirebaseDate(classYear),
    };
  }

  factory CollegeModel.fromJson(Map json) {
    return CollegeModel(
      university: json["university"] as String,
      major: json["major"] as String,
      degree: json["degree"] as String,
      semester: json["semester"] as int,
      classYear: DateTimeHelper.convertFromFirebaseDate(json['class_year'] as String),
    );
  }
}

class JobModel extends OccupationModel {
  final String company;
  final String companyAddress;
  final String jobTitle;
  final String jobDescription;
  final DateTime since;

  JobModel({
    this.company,
    this.companyAddress,
    this.jobTitle,
    this.jobDescription,
    this.since,
  }) : super(OccupationType.job);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': "Job",
      'company': company,
      'company_address': companyAddress,
      'job_title': jobTitle,
      'job_description': jobDescription,
      'working_since': DateTimeHelper.convertToFirebaseDate(since),
    };
  }

  factory JobModel.fromJson(Map json) {
    return JobModel(
      company: json["company"] as String,
      companyAddress: json["company_address"] as String,
      jobTitle: json["job_title"] as String,
      jobDescription: json["job_description"] as String,
      since: DateTimeHelper.convertFromFirebaseDate(json['working_since'] as String),
    );
  }
}

class BusinessModel extends OccupationModel {
  final String businessName;
  final String businessDescription;
  final String businessAddress;
  final DateTime since;

  BusinessModel({
    this.businessName,
    this.businessDescription,
    this.businessAddress,
    this.since,
  }) : super(OccupationType.business);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': "Business",
      'business_name': businessName,
      'business_description': businessDescription,
      'business_address': businessAddress,
      'open_since': DateTimeHelper.convertToFirebaseDate(since),
    };
  }

  factory BusinessModel.fromJson(Map json) {
    return BusinessModel(
      businessName: json["business_name"] as String,
      businessDescription: json["business_description"] as String,
      businessAddress: json["business_address"] as String,
      since: DateTimeHelper.convertFromFirebaseDate(json['open_since'] as String),
    );
  }
}

class PostModel extends NewsFeedModel {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String description;
  final String actionName;
  final String goTo;

  PostModel({
    String id,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.description,
    this.actionName,
    this.goTo,
  }) : super(NewsFeedType.post, id);

  factory PostModel.fromJson(String id, Map json) {
    return PostModel(
      id: id,
      imageUrl: json['image_url'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      actionName: json['action_name'] as String,
      goTo: json['go_to'] as String,
    );
  }

  @override
  String toString() {
    return "PostModel:\n"
        "id: $id\n"
        "imageUrl: $imageUrl\n"
        "title: $title\n"
        "subtitle: $subtitle\n"
        "description: $description\n"
        "actionName: $actionName\n"
        "goTo: $goTo\n";
  }
}

class GroupModel {
  final String id;
  final String name;
  final String photo;
  final List<String> membersId;

  GroupModel({this.id, this.name, this.photo, this.membersId});

  factory GroupModel.fromJson(String id, Map json) {
    List<String> membersId = List<String>.from(json['members_id']);

    return GroupModel(
      id: id,
      name: json['name'] as String,
      photo: json['photo'] as String,
      membersId: membersId,
    );
  }

  @override
  String toString() {
    return "Group (id: $id, name: $name, photo: $photo, members: $membersId)";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'photo': photo,
      'membersId': membersId,
    };
  }
}

class ParticipantModel {
  final String id;
  final String name;
  final String photo;
  final ParticipantType type;
  final String sourceId;

  ParticipantModel({this.id, this.name, this.photo, this.type, this.sourceId});

  factory ParticipantModel.fromJson(String id, Map json) {
    return ParticipantModel(
      id: id,
      name: json['name'] as String,
      photo: json['photo'] as String,
      type: participantTypeMap[json['type'] as String],
      sourceId: json['source_id'] as String,
    );
  }

  @override
  String toString() {
    return "ParticipantModel (id: $id, name: $name, type: $type, sourceId: $sourceId)";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'photo': photo,
      'type': participantTypeMap.keys
          .firstWhere((k) => participantTypeMap[k] == type, orElse: () => null),
      'source_id': sourceId,
    };
  }
}

class PositionModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final int qty;
  final List<String> participantsId;

  PositionModel(
      {this.id, this.name, this.code, this.description, this.qty, List<String> participantsId})
      : this.participantsId = participantsId ?? [];

  factory PositionModel.fromJson(String id, Map json) {
    return PositionModel(
      id: id,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String,
      qty: (json['qty'] as num).toInt(),
      participantsId: List<String>.from((json['participants_id'] ?? []) as List),
    );
  }

  @override
  String toString() {
    return "PositionModel (id: $id, name: $name, code: $code, description: $description, qty: $qty, participantsId: $participantsId)";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'code': code,
      'description': description,
      'qty': qty,
      'participants_id': participantsId,
    };
  }
}

class EventSettingModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final EventCategory category;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<ParticipantModel> participants;
  final IntervalType interval;
  final int customDays;
  final List<PositionModel> positions;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime lastGenerateDate;
  final String eventMaster;
  final EventStatus eventStatus;

  EventSettingModel({
    this.id,
    this.name,
    this.description,
    this.location,
    this.category,
    this.startTime,
    this.endTime,
    this.participants,
    this.interval,
    this.customDays,
    this.positions,
    this.startDate,
    this.endDate,
    this.lastGenerateDate,
    this.eventMaster,
    this.eventStatus,
  });

  EventSettingModel copyWith(
      {String id,
      String name,
      String description,
      String location,
      EventCategory category,
      TimeOfDay startTime,
      TimeOfDay endTime,
      List<ParticipantModel> participants,
      IntervalType interval,
      int customDays,
      List<PositionModel> positions,
      DateTime startDate,
      DateTime endDate,
      DateTime lastGenerateDate,
      String eventMaster,
      EventStatus eventStatus}) {
    return new EventSettingModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        location: location ?? this.location,
        category: category ?? this.category,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        participants: participants ?? this.participants,
        interval: interval ?? this.interval,
        customDays: customDays ?? this.customDays,
        positions: positions ?? this.positions,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        lastGenerateDate: lastGenerateDate ?? this.lastGenerateDate,
        eventMaster: eventMaster ?? this.eventMaster,
        eventStatus: eventStatus ?? this.eventStatus);
  }

  factory EventSettingModel.fromJson(String id, Map json) {
    Map rawParticipants = json["participants"];
    Map rawPositions = json["positions"];
    List<ParticipantModel> participants = [];
    List<PositionModel> positions = [];

    if (rawParticipants != null)
      rawParticipants.forEach((key, value) {
        ParticipantModel participant = ParticipantModel.fromJson(key, value);
        participants.add(participant);
      });

    if (rawPositions != null)
      rawPositions.forEach((key, value) {
        PositionModel position = PositionModel.fromJson(key, value);
        positions.add(position);
      });

    TimeOfDay startTime = DateTimeHelper.convertFromFirebaseTime(json['start_time'] as String);
    TimeOfDay endTime = DateTimeHelper.convertFromFirebaseTime(json['end_time'] as String);

    return EventSettingModel(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      category: eventCategoryMap[json['category'] as String],
      startTime: startTime,
      endTime: endTime,
      participants: participants,
      interval: intervalTypeMap[json['interval'] as String],
      customDays: (json['custom_days'] as num ?? 0).toInt(),
      positions: positions,
      startDate: DateTimeHelper.convertFromFirebaseDate(json['start_date'] as String),
      endDate: DateTimeHelper.convertFromFirebaseDate(json['end_date'] as String),
      lastGenerateDate:
          DateTimeHelper.convertFromFirebaseDate(json['last_generate_date'] as String),
      eventMaster: json['event_master'] as String,
      eventStatus: eventStatusMap[json['status'] as String],
    );
  }

  Map<String, dynamic> toMap() {
    Map participantsMap = Map();

    if (participants != null) {
      participants.forEach((participant) {
        String key = participant.id;
        Map value = participant.toMap();

        participantsMap.putIfAbsent(key, () => value);
      });
    }

    Map<String, dynamic> result = Map();

    result.putIfAbsent("name", () => name);
    if ((description ?? "") != "") result.putIfAbsent("description", () => description);
    if ((location ?? "") != "") result.putIfAbsent("location", () => location);
    result.putIfAbsent(
        "category",
        () => eventCategoryMap.keys
            .firstWhere((k) => eventCategoryMap[k] == category, orElse: () => null));
    result.putIfAbsent("start_time", () => DateTimeHelper.convertToFirebaseTime(startTime));
    result.putIfAbsent("end_time", () => DateTimeHelper.convertToFirebaseTime(endTime));
    result.putIfAbsent("participants", () => participantsMap);
    result.putIfAbsent(
        "interval",
        () => intervalTypeMap.keys
            .firstWhere((k) => intervalTypeMap[k] == interval, orElse: () => null));
    if ((customDays ?? 0) != 0) result.putIfAbsent("custom_days", () => customDays);
    result.putIfAbsent("start_date", () => DateTimeHelper.convertToFirebaseDate(startDate));
    result.putIfAbsent("end_date", () => DateTimeHelper.convertToFirebaseDate(endDate));
    result.putIfAbsent(
        "last_generate_date", () => DateTimeHelper.convertToFirebaseDate(lastGenerateDate));
    result.putIfAbsent("event_master", () => eventMaster);
    result.putIfAbsent(
        "event_status",
        () => eventStatusMap.keys
            .firstWhere((k) => eventStatusMap[k] == eventStatus, orElse: () => null));

    return result;
  }

  @override
  String toString() {
    return "EventSettingModel (id: $id, "
        "name: $name, "
        "description: $description, "
        "location: $location, "
        "category: $category, "
        "startTime: $startTime, "
        "endTime: $endTime, "
        "participants: $participants, "
        "interval: $interval, "
        "positions: $positions, "
        "startDate: $startDate, "
        "endDate: $endDate, "
        "lastGenerateDate: $lastGenerateDate, "
        "eventMaster: $eventMaster)";
  }
}

class AvailabilityModel {
  final String id;
  final String participantId;
  final List<DateTime> availableDates;

  AvailabilityModel({this.id, this.participantId, this.availableDates});

  factory AvailabilityModel.fromJson(String id, Map json) {
    List<DateTime> availableDates = List<DateTime>.from(json['available_dates']);

    return AvailabilityModel(
      id: id,
      participantId: json['participant_id'] as String,
      availableDates: availableDates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "participant_id": this.participantId,
      "available_dates": this.availableDates,
    };
  }

  @override
  String toString() {
    return "Availability (id: $id, participantId: $participantId, availableDates: $availableDates)";
  }
}

class BirthdayModel {
  final String id;
  final String name;
  final DateTime date;

  BirthdayModel({this.id, this.name, this.date});

  factory BirthdayModel.fromJson(String id, Map json) {
    return BirthdayModel(
      id: id,
      name: json['name'] as String,
      date: DateTimeHelper.convertFromFirebaseDate(json['date'] as String),
    );
  }

  @override
  String toString() {
    return "BirthdayModel (id: $id, name: $name, date: $date)";
  }
}

class HolidayModel {
  final String id;
  final String name;
  final DateTime endDate;
  final DateTime startDate;
  final HolidayIntervalType interval;

  HolidayModel({this.id, this.name, this.endDate, this.startDate, this.interval});

  factory HolidayModel.fromJson(String id, Map json) {
    return HolidayModel(
      id: id,
      name: json['name'] as String,
      startDate: DateTimeHelper.convertFromFirebaseDate(json['start_date'] as String),
      endDate: DateTimeHelper.convertFromFirebaseDate(json['end_date'] as String),
      interval: holidayIntervalTypeMap[json['interval'] as String],
    );
  }

  @override
  String toString() {
    return "HolidayModel (id: $id, name: $name, startDate: $startDate, endDate: $endDate, interval: $interval)";
  }
}

class EventModel {
  final String id;
  final String eventSettingId;
  final String name;
  final String description;
  final String location;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime startDate;
  final DateTime endDate;
  final String eventMaster;

  EventModel({
    this.id,
    this.eventSettingId,
    this.name,
    this.description,
    this.location,
    this.startTime,
    this.endTime,
    this.startDate,
    this.endDate,
    this.eventMaster,
  });

  EventModel copyWith({
    String id,
    String eventSettingId,
    String name,
    String description,
    String location,
    TimeOfDay startTime,
    TimeOfDay endTime,
    DateTime startDate,
    DateTime endDate,
    String eventMaster,
  }) {
    return new EventModel(
      id: id ?? this.id,
      eventSettingId: eventSettingId ?? this.eventSettingId,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      eventMaster: eventMaster ?? this.eventMaster,
    );
  }

  factory EventModel.fromJson(String id, Map json) {
    Map rawParticipants = json["participants"];
    Map rawPositions = json["positions"];
    List<ParticipantModel> participants = [];
    List<PositionModel> positions = [];

    if (rawParticipants != null)
      rawParticipants.forEach((key, value) {
        ParticipantModel participant = ParticipantModel.fromJson(key, value);
        participants.add(participant);
      });

    if (rawPositions != null)
      rawPositions.forEach((key, value) {
        PositionModel position = PositionModel.fromJson(key, value);
        positions.add(position);
      });

    TimeOfDay startTime = DateTimeHelper.convertFromFirebaseTime(json['start_time'] as String);
    TimeOfDay endTime = DateTimeHelper.convertFromFirebaseTime(json['end_time'] as String);

    return EventModel(
      id: id,
      eventSettingId: json['event_setting_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      startTime: startTime,
      endTime: endTime,
      startDate: DateTimeHelper.convertFromFirebaseDate(json['start_date'] as String),
      endDate: DateTimeHelper.convertFromFirebaseDate(json['end_date'] as String),
      eventMaster: json['event_master'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = Map();

    result.putIfAbsent("event_setting_id", () => eventSettingId);
    result.putIfAbsent("name", () => name);
    if ((description ?? "") != "") result.putIfAbsent("description", () => description);
    if ((location ?? "") != "") result.putIfAbsent("location", () => location);
    result.putIfAbsent("start_time", () => DateTimeHelper.convertToFirebaseTime(startTime));
    result.putIfAbsent("end_time", () => DateTimeHelper.convertToFirebaseTime(endTime));
    result.putIfAbsent("start_date", () => DateTimeHelper.convertToFirebaseDate(startDate));
    result.putIfAbsent("end_date", () => DateTimeHelper.convertToFirebaseDate(endDate));
    result.putIfAbsent("event_master", () => eventMaster);

    return result;
  }

  @override
  String toString() {
    return "EventModel (id: $id, "
        "eventSettingId: $eventSettingId, "
        "name: $name, "
        "description: $description, "
        "location: $location, "
        "startTime: $startTime, "
        "endTime: $endTime, "
        "startDate: $startDate, "
        "endDate: $endDate, "
        "eventMaster: $eventMaster)";
  }
}

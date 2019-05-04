import 'package:date_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> occupationMap = [];
    for (OccupationModel occupation in this.occupations) {
      occupationMap.add(occupation.toMap());
    }
    return <String, dynamic>{
      "name": this.name,
      "birthday": kServerDateFormat.format(this.birthday),
      "show_birthday": this.showBirthday,
      "address": this.address,
      "status": this.status,
      "email": this.email,
      "phone_number": this.phoneNumber,
      "occupations": occupationMap,
      "have_been_baptized": this.haveBeenBaptized,
      "church": this.church,
      "date_of_baptize": kServerDateFormat.format(this.dateOfBaptize),
      "join_jpcc_since": kServerDateFormat.format(this.joinJpccSince),
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
    DateFormat dateParser = DateFormat("yyyy-MM-dd");

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
      birthday: dateParser.parse(json['birthday'] as String),
      showBirthday: json['show_birthday'] as bool,
      address: json['address'] as String,
      status: json['status'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      occupations: occupations,
      haveBeenBaptized: json['have_been_baptized'] as bool,
      church: json['church'] as String,
      dateOfBaptize: dateParser.parse(json['date_of_baptize'] as String),
      joinJpccSince: dateParser.parse(json['join_jpcc_since'] as String),
      classHistory: classHistory,
      username: json['username'] as String,
      password: json['password'] as String,
      photo: json['photo'] as String,
    );
  }
}

enum OccupationType {
  college,
  job,
  business,
}

abstract class OccupationModel {
  final OccupationType _type;

  OccupationModel(this._type);

  Map<String, dynamic> toMap();
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
      'class_year': kServerDateFormat.format(classYear),
    };
  }

  factory CollegeModel.fromJson(Map json) {
    DateFormat dateParser = DateFormat("yyyy-MM-dd");
    return CollegeModel(
      university: json["university"] as String,
      major: json["major"] as String,
      degree: json["degree"] as String,
      semester: json["semester"] as int,
      classYear: dateParser.parse(json['class_year'] as String),
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
      'working_since': kServerDateFormat.format(since),
    };
  }

  factory JobModel.fromJson(Map json) {
    DateFormat dateParser = DateFormat("yyyy-MM-dd");
    return JobModel(
      company: json["company"] as String,
      companyAddress: json["company_address"] as String,
      jobTitle: json["job_title"] as String,
      jobDescription: json["job_description"] as String,
      since: dateParser.parse(json['working_since'] as String),
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
      'open_since': kServerDateFormat.format(since),
    };
  }

  factory BusinessModel.fromJson(Map json) {
    DateFormat dateParser = DateFormat("yyyy-MM-dd");
    return BusinessModel(
      businessName: json["business_name"] as String,
      businessDescription: json["business_description"] as String,
      businessAddress: json["business_address"] as String,
      since: dateParser.parse(json['open_since'] as String),
    );
  }
}

enum NewsFeedType {
  post,
  voting,
}

abstract class NewsFeedModel {
  final NewsFeedType _type;
  final String _id;

  NewsFeedModel(this._type, this._id);

  String get id => _id;

  NewsFeedType get type => _type;
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

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'photo': photo,
      'membersId': membersId,
    };
  }
}

enum ParticipantType { member, group }

const Map<String, ParticipantType> participantTypeMap = {
  "Member": ParticipantType.member,
  "Group": ParticipantType.group,
};

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
}

class PositionModel {
  final String id;
  final String name;
  final int qty;
  final List<String> participantsId;

  PositionModel({this.id, this.name, this.qty, List<String> participantsId})
      : this.participantsId = participantsId ?? [];

  factory PositionModel.fromJson(String id, Map json) {
    return PositionModel(
      id: id,
      name: json['name'] as String,
      qty: (json['qty'] as num).toInt(),
      participantsId: List<String>.from((json['participants_id'] ?? []) as List),
    );
  }

  @override
  String toString() {
    return "PositionModel (id: $id, name: $name, qty: $qty, participantsId: $participantsId)";
  }
}

enum EventCategory { birthday, holiday, date, jpcc, group, personal }

const Map<String, EventCategory> eventCategoryMap = {
  "Birthday": EventCategory.birthday,
  "Holiday": EventCategory.holiday,
  "DATE": EventCategory.date,
  "JPCC": EventCategory.jpcc,
  "Group": EventCategory.group,
  "Personal": EventCategory.personal,
};

enum IntervalType { once, daily, weekly, monthly, annual, custom }

const Map<String, IntervalType> intervalTypeMap = {
  "Once": IntervalType.once,
  "Daily": IntervalType.daily,
  "Weekly": IntervalType.weekly,
  "Monthly": IntervalType.monthly,
  "Annual": IntervalType.annual,
  "Custom": IntervalType.custom,
};

class EventModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final EventCategory category;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<ParticipantModel> participants;
  final IntervalType interval;
  final List<PositionModel> positions;
  final bool shuffled;
  final DateTime startDate;
  final DateTime endDate;

  EventModel({
    this.id,
    this.name,
    this.description,
    this.location,
    this.category,
    this.startTime,
    this.endTime,
    this.participants,
    this.interval,
    this.positions,
    this.shuffled,
    this.startDate,
    this.endDate,
  });

  EventModel copyWith(
      {String id,
      String name,
      String description,
      String location,
      EventCategory category,
      TimeOfDay startTime,
      TimeOfDay endTime,
      List<ParticipantModel> participants,
      IntervalType interval,
      List<PositionModel> positions,
      bool shuffled,
      DateTime startDate,
      DateTime endDate}) {
    return new EventModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        location: location ?? this.location,
        category: category ?? this.category,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        participants: participants ?? this.participants,
        interval: interval ?? this.interval,
        positions: positions ?? this.positions,
        shuffled: shuffled ?? this.shuffled,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate);
  }

  factory EventModel.fromJson(String id, Map json) {
    Map rawParticipants = json["participants"];
    Map rawPositions = json["positions"];
    List<ParticipantModel> participants = [];
    List<PositionModel> positions = [];
    DateFormat timeParser = DateFormat("HH:mm:ss");
    DateFormat dateParser = DateFormat("yyyy-MM-dd");

    rawParticipants.forEach((key, value) {
      ParticipantModel participant = ParticipantModel.fromJson(key, value);
      participants.add(participant);
    });
    rawPositions.forEach((key, value) {
      PositionModel position = PositionModel.fromJson(key, value);
      positions.add(position);
    });

    TimeOfDay startTime = TimeOfDay.fromDateTime(timeParser.parse(json['start_time'] as String));
    TimeOfDay endTime = TimeOfDay.fromDateTime(timeParser.parse(json['end_time'] as String));

    return EventModel(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      category: eventCategoryMap[json['category'] as String],
      startTime: startTime,
      endTime: endTime,
      participants: participants,
      interval: intervalTypeMap[json['interval'] as String],
      positions: positions,
      shuffled: json['shuffled'] as bool,
      startDate: dateParser.parse(json['start_date'] as String),
      endDate: dateParser.parse(json['end_date'] as String),
    );
  }

  @override
  String toString() {
    return "EventModel (id: $id, "
        "name: $name, "
        "description: $description, "
        "location: $location, "
        "category: $category, "
        "startTime: $startTime, "
        "endTime: $endTime, "
        "participants: $participants, "
        "interval: $interval, "
        "positions: $positions, "
        "shuffled: $shuffled, "
        "startDate: $startDate, "
        "endDate: $endDate)";
  }
}

import 'package:date_app/utilities/constants.dart';

class MemberModel {
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
  final Map<String, bool> classHistory;
  final String username;
  final String password;

  MemberModel({
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
  });
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
      'university': university,
      'major': major,
      'degree': degree,
      'semester': semester,
      'class_year': kServerDateFormat.format(classYear),
    };
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
      'company': company,
      'company_address': companyAddress,
      'job_title': jobTitle,
      'job_description': jobDescription,
      'working_since': kServerDateFormat.format(since),
    };
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
      'business_name': businessName,
      'business_description': businessDescription,
      'business_address': businessAddress,
      'open_since': kServerDateFormat.format(since),
    };
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

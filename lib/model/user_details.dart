import 'package:image_picker/image_picker.dart';

class UsersDetails {
  final int? statusCode;
  final bool? success;
  final List<String>? messages;
  final List<Data>? data;

  UsersDetails({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
  });

  UsersDetails.fromJson(Map<String, dynamic> json)
      : statusCode = json['statusCode'] as int?,
        success = json['success'] as bool?,
        messages = (json['messages'] as List?)
            ?.map((dynamic e) => e as String)
            .toList(),
        data = (json['data'] as List?)
            ?.map((dynamic e) => Data.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'success': success,
        'messages': messages,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class Data {
  final int? id;
  final String? username;
  final int? mobileno;
  final String? profilepic;
  final dynamic adhar;
  final dynamic languages;
  final dynamic expirience;
  final String? role;
  final int? userstatus;
  final dynamic isonline;
  final String? imageurl;
  final dynamic adharno;
  final dynamic location;
  final String? dateofbirth;
  final String? placeofbirth;
  XFile? adharpic;
  XFile? profiledp;
  Data(
      {this.id,
      this.username,
      this.mobileno,
      this.profilepic,
      this.adhar,
      this.languages,
      this.expirience,
      this.role,
      this.userstatus,
      this.isonline,
      this.imageurl,
      this.adharno,
      this.location,
      this.dateofbirth,
      this.placeofbirth,
      this.adharpic,
      this.profiledp});

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        username = json['username'] as String?,
        mobileno = json['mobileno'] as int?,
        profilepic = json['profilepic'] as String?,
        adhar = json['adhar'],
        languages = json['languages'],
        expirience = json['expirience'],
        role = json['role'] as String?,
        userstatus = json['userstatus'] as int?,
        isonline = json['isonline'],
        imageurl = json['imageurl'] as String?,
        adharno = json['adharno'],
        location = json['location'],
        dateofbirth = json['dateofbirth'] as String?,
        placeofbirth = json['placeofbirth'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'mobileno': mobileno,
        'profilepic': profilepic,
        'adhar': adhar,
        'languages': languages,
        'expirience': expirience,
        'role': role,
        'userstatus': userstatus,
        'isonline': isonline,
        'imageurl': imageurl,
        'adharno': adharno,
        'location': location,
        'dateofbirth': dateofbirth,
        'placeofbirth': placeofbirth
      };
}

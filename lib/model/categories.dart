import 'package:flutter/material.dart';

class Categories {
  Categories({
    required this.statusCode,
    required this.success,
    required this.messages,
    required this.data,
  });
  late final int statusCode;
  late final bool success;
  late final List<dynamic> messages;
  late final List<Data> data;

  Categories.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = List.castFrom<dynamic, dynamic>(json['messages']);
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['statusCode'] = statusCode;
    _data['success'] = success;
    _data['messages'] = messages;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data with ChangeNotifier {
  Data({
    this.id,
    this.title,
    this.filename,
    this.mimetype,
    this.directcalling,
    this.parentid,
    this.subcat,
  });
  late final int? id;
  late final String? title;
  late final String? filename;
  late final String? mimetype;
  late final int? directcalling;
  late final Null parentid;
  late final List<Subcat>? subcat;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    filename = json['filename'];
    mimetype = json['mimetype'];
    directcalling = json['directcalling'];
    parentid = null;
    subcat = List.from(json['subcat']).map((e) => Subcat.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    // _data['id'] = id;
    _data['title'] = title;
    _data['filename'] = filename;
    // _data['mimetype'] = mimetype;
    _data['directcalling'] = directcalling;
    // _data['parentid'] = parentid;
    // _data['subcat'] = subcat.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Subcat with ChangeNotifier {
  Subcat({
    this.id,
    this.title,
    this.filename,
    this.mimetype,
    this.directcalling,
    this.parentid,
    this.subcat,
  });
  late final int? id;
  late final String? title;
  late final String? filename;
  late final String? mimetype;
  late final int? directcalling;
  late final int? parentid;
  late final List<dynamic>? subcat;

  Subcat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    filename = json['filename'];
    mimetype = json['mimetype'];
    directcalling = json['directcalling'];
    parentid = json['parentid'];
    subcat = List.castFrom<dynamic, dynamic>(json['subcat']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    //_data['id'] = id;
    _data['title'] = title;
    _data['filename'] = filename;
    //_data['mimetype'] = mimetype;
    _data['directcalling'] = directcalling;
    //_data['parentid'] = parentid;
    //_data['subcat'] = subcat;
    return _data;
  }
}

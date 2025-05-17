import 'package:flutter_ui/utils/http/utils.dart';

class UserModel {
  String? name;
  String? email;
  String? location;
  String? dob;
  int? affiliationId;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? token;
  String? phoneNumber;

  UserModel({
    this.name,
    this.email,
    this.location,
    this.dob,
    this.affiliationId,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.token,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'location': location,
      'dob': dob,
      'affiliationId': affiliationId,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'id': id,
      'token': token,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: $cast(json['name'] as String),
      email: $cast(json['email'] as String),
      location: $cast(json['location'] as String),
      dob: $cast(json['dob'] as String),
      affiliationId: $cast(json['affiliation_id'] as int),
      updatedAt: $cast(json['updatedAt'] as String),
      createdAt: $cast(json['createdAt'] as String),
      id: $cast(json['id'] as int),
      token: $cast(json['token'] as String),
      phoneNumber: $cast(json['phone_number'] as String),
    );
  }
}

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
      name: $cast(json['name']),
      email: $cast(json['email']),
      location: $cast(json['location']),
      dob: $cast(json['dob']),
      affiliationId: $cast(json['affiliation_id']),
      updatedAt: $cast(json['updatedAt']),
      createdAt: $cast(json['createdAt']),
      id: $cast(json['id']),
      token: $cast(json['token']),
      phoneNumber: $cast(json['phone_number']),
    );
  }
}

import 'package:flutter_ui/model/user_model/user_model.dart';

abstract class UserRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String affiliationId,
    required String name,
    required String email,
    required String password,
    required String location,
    required String phoneNumber,
    required String dob,
  });
}

// "name" : "dsada",
// "email" : "asa@gmail.com",
// "location" : "sadasd",
// "dob" : "2024-12-12",
// "password": "12345678",
// "affiliation_id" : 1,
// "phone_number" : "2123132"

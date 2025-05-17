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

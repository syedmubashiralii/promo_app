import 'package:flutter_ui/model/user_model/user_model.dart';
import 'package:flutter_ui/repository/user_repository/user_repository.dart';
import 'package:flutter_ui/utils/api_constants.dart';
import 'package:flutter_ui/utils/http/http_client.dart';
import 'package:flutter_ui/utils/http/utils.dart';

class UserRepositoryImpl implements UserRepository {
  final HttpClient httpClient;

  UserRepositoryImpl({required this.httpClient});
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    return httpClient.post(
      path: ApiConstants.login,
      body: {"email": email, "password": password},
    ).then(
      (value) => $mapIt(
        value,
        (it) => UserModel.fromJson(it["data"]['user'] as JsonObject),
      )!,
    );
  }

  @override
  Future<UserModel> register({
    required String affiliationId,
    required String name,
    required String email,
    required String password,
    required String location,
    required String phoneNumber,
    required String dob,
  }) async {
    return httpClient.post(
      path: ApiConstants.register,
      body: {
        "email": email,
        "password": password,
        "name": name,
        "location": location,
        "phone_number": phoneNumber,
        "affiliation_id": affiliationId,
        "dob": dob
      },
    ).then(
      (value) => $mapIt(
        value,
        (it) => UserModel.fromJson(it["data"] as JsonObject),
      )!,
    );
  }
}

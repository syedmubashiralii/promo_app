import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_ui/model/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs_storage.dart';

abstract class IStorage {
  Future<void> init();

  Future<bool> clear(String key);
  Future<bool> setUser(UserModel user);
  UserModel? get user;
  Future<bool> clearAll();
  Future<bool> setUserAuthToken(String authToken);
  String? get authenticationToken;
}

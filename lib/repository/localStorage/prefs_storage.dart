part of 'storage.dart';

class PrefsStorage implements IStorage {
  static late SharedPreferences _prefs;

  static const String _keyUser = 'user';
  static const authUser = 'authUser';

  @override
  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  @override
  Future<bool> setUser(UserModel user) =>
      _prefs.setString(_keyUser, jsonEncode(user.toJson()));

  @override
  UserModel? get user {
    final userString = _prefs.getString(_keyUser);
    if (userString != null) {
      final userJson = jsonDecode(userString);
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  @override
  Future<bool> clear(String key) async {
    if (kDebugMode) {
      log(key, name: 'Local Storage Clear: $key', time: DateTime.now());
    }

    return await _prefs.remove(key);
  }

  @override
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  @override
  Future<bool> setUserAuthToken(String tokenUser) async {
    if (kDebugMode) {
      log(
        tokenUser,
        name: 'Local Storage Write: $authUser',
        time: DateTime.now(),
      );
    }

    return await _prefs.setString(authUser, tokenUser);
  }

  @override
  String? get authenticationToken => _prefs.getString(authUser);
}

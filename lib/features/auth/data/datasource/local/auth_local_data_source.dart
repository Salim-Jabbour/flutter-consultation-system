import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  const AuthLocalDataSource();

  //set user token
  Future<void> setUserToken(String token);
  //get the current token
  Future<String?> getUserToken();

  Future<void> setUserId(String userId);
  Future<String?> getUserId();

  //set user role
  Future<void> setUserRole(String role);
  //get current user role
  Future<String?> getUserRole();

  Future<void> setUserName(String name);
  Future<String?> getUserName();

  //clear user data (role & token)
  Future<void> clearAllUserData();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._prefs);

  final _keyToken = 'token';
  final _keyUserId = 'userId';
  final _keyRole = 'role';
  final _keyName = 'name';

  final SharedPreferences _prefs;

  @override
  Future<String?> getUserToken() async {
    return _prefs.getString(_keyToken);
  }

  @override
  Future<void> setUserToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  @override
  Future<String?> getUserId() async {
    return _prefs.getString(_keyUserId);
  }

  @override
  Future<void> setUserId(String userId) async {
    await _prefs.setString(_keyUserId, userId);
  }

  @override
  Future<String?> getUserRole() async {
    return _prefs.getString(_keyRole);
  }

  @override
  Future<void> setUserRole(String role) async {
    await _prefs.setString(_keyRole, role);
  }

  @override
  Future<void> setUserName(String name) async {
    await _prefs.setString(_keyName, name);
  }

  @override
  Future<String?> getUserName() async {
    return _prefs.getString(_keyName);
  }

  @override
  Future<void> clearAllUserData() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyRole);
    await _prefs.remove(_keyName);
    await _prefs.remove(_keyUserId);
    await _prefs.clear();
  }
}

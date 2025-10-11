import 'package:shared_preferences/shared_preferences.dart';
import 'package:xrp_monitor_flutter_admin/constants/enums.dart';

class LocalStorageService {
  LocalStorageService._internal();

  static final LocalStorageService _instance = LocalStorageService._internal();
  late final SharedPreferences _prefs;

  static LocalStorageService get instance => _instance;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getAccessToken() {
    return _prefs.getString(StorageKey.token.name);
  }

  String? getRefreshToken() {
    return _prefs.getString(StorageKey.refreshToken.name);
  }


  Future<void> setUserToken(String token) async {
    await _prefs.setString(StorageKey.token.name, token);
  }

  Future<void> setUserRefreshToken(String token) async {
    await _prefs.setString(StorageKey.refreshToken.name, token);
  }

  Future<void> setOperatorToken(String token) async {
    await _prefs.setString(StorageKey.token.name, token);
  }

  Future<void> removeAllToken() async {
    await _prefs.remove(StorageKey.token.name);
  }

  Future<void> removeAccessToken() async {
    await _prefs.remove(StorageKey.token.name);
  }


  Future<void> removeLocalStorage() async {
    await _prefs.remove(StorageKey.token.name);
  }

  String? getKeyName(String keyName) {
    return _prefs.getString(keyName);
  }

  Future<void> setKeyName(String keyName, String value) async {
    await _prefs.setString(keyName, value);
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  SharedPreferences? _sharedPreferences;

  static const String keyJwtToken = 'jwt_token';
  static const String keyUserRole = 'user_role';
  static const String keyIsFirstRun = 'is_first_run';

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // SecureStorage
  Future<void> saveSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearAllSecure() async {
    await _secureStorage.deleteAll();
  }

  // SharedPreferences
  Future<void> saveBool(String key, bool value) async {
    if (_sharedPreferences == null) await init();
    await _sharedPreferences!.setBool(key, value);
  }

  Future<bool?> readBool(String key) async {
    if (_sharedPreferences == null) await init();
    return _sharedPreferences!.getBool(key);
  }
}

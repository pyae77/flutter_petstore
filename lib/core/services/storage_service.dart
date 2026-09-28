import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Secure Storage Keys
  static const String _keySessionToken = 'session_token';
  static const String _keyUsername = 'username';
  static const String _keyUserData = 'user_data';
  static const String _keyIsFirstTime = 'is_first_time';

  // ---------------------------------------------------------------------------
  // First Time Check Methods
  // ---------------------------------------------------------------------------
  Future<bool> isFirstTime() async {
    final value = await _secureStorage.read(key: _keyIsFirstTime);
    return value == null; 
  }

  Future<void> setFirstTimeCompleted() async {
    await _secureStorage.write(key: _keyIsFirstTime, value: 'false');
  }

  // ---------------------------------------------------------------------------
  // Write Methods
  // ---------------------------------------------------------------------------
  Future<void> saveAuthData({
    required String token,
    required String username,
  }) async {
    await Future.wait([
      _secureStorage.write(key: _keySessionToken, value: token),
      _secureStorage.write(key: _keyUsername, value: username),
    ]);
  }

  Future<void> saveUserData(String userDataJson) async {
    await _secureStorage.write(key: _keyUserData, value: userDataJson);
  }

  // ---------------------------------------------------------------------------
  // Read Methods
  // ---------------------------------------------------------------------------
  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: _keySessionToken);
  }

  Future<String?> getUsername() async {
    return await _secureStorage.read(key: _keyUsername);
  }

  Future<String?> getUserData() async {
    return await _secureStorage.read(key: _keyUserData);
  }

  // ---------------------------------------------------------------------------
  // Delete / Clear Methods
  // ---------------------------------------------------------------------------
  Future<void> clearAuthData() async {
    await Future.wait([
      _secureStorage.delete(key: _keySessionToken),
      _secureStorage.delete(key: _keyUsername),
    ]);
  }

  Future<void> clearUserData() async {
    await _secureStorage.delete(key: _keyUserData);
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
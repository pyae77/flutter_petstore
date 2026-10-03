import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pet_store_app/core/constants/api_constants.dart'; // ApiConstants import
import 'package:pet_store_app/core/services/storage_service.dart';
import 'package:pet_store_app/data/data_source/remote/user_remote_data_source.dart';
import 'package:pet_store_app/data/model/user_model.dart';
import 'package:pet_store_app/domain/entity/user_entity.dart';
import 'package:pet_store_app/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final StorageService storageService;

  UserRepositoryImpl(this.remoteDataSource, this.storageService);

  String _getPrefixedUsername(String rawUsername) {
    if (rawUsername.startsWith(ApiConstants.userPrefix)) {
      return rawUsername;
    }
    return '${ApiConstants.userPrefix}_$rawUsername';
  }

  int _getPrefixedId() {
    return int.parse(
      '${ApiConstants.staticPrefix}${DateTime.now().millisecondsSinceEpoch % 10000}',
    );
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final uniqueUsername = _getPrefixedUsername(user.userName);
    final uniqueId = user.id == 0 ? _getPrefixedId() : user.id;

    final userModel = UserModel(
      id: uniqueId,
      userName: uniqueUsername,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
      phone: user.phone,
      userStatus: user.userStatus,
    );

    await remoteDataSource.createUser(userModel);
    await storageService.saveUserData(jsonEncode(userModel.toJson()));
  }

  @override
  Future<UserEntity> login(String username, String password) async {
    final uniqueUsername = _getPrefixedUsername(username);

    final sessionToken = await remoteDataSource.login(uniqueUsername, password);

    UserModel userModel;

    try {
      userModel = await remoteDataSource.getUserByUsername(uniqueUsername);
    } catch (e) {
      debugPrint('User not found on server. Auto-creating prefixed user...');

      final newModel = UserModel(
        id: _getPrefixedId(),
        userName: uniqueUsername,
        firstName: username,
        lastName: '',
        email: '$uniqueUsername@test.com',
        password: password,
        phone: '09123456789',
        userStatus: 1,
      );

      await remoteDataSource.createUser(newModel);
      userModel = newModel;
    }

    await storageService.saveAuthData(
      token: sessionToken,
      username: uniqueUsername,
    );
    await storageService.saveUserData(jsonEncode(userModel.toJson()));

    return _toEntity(userModel);
  }

  Future<UserEntity> getUserByUsername(String username) async {
    final uniqueUsername = _getPrefixedUsername(username);
    final remoteModel = await remoteDataSource.getUserByUsername(
      uniqueUsername,
    );
    return _toEntity(remoteModel);
  }

  Future<void> updateUser(String username, UserEntity user) async {
    final uniqueUsername = _getPrefixedUsername(username);

    final userModel = UserModel(
      id: user.id,
      userName: uniqueUsername,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
      phone: user.phone,
      userStatus: user.userStatus,
    );

    await remoteDataSource.updateUser(uniqueUsername, userModel);
    await storageService.saveUserData(jsonEncode(userModel.toJson()));
  }

  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {}
    await storageService.clearAuthData();
    await storageService.clearUserData();
  }

  UserEntity _toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      userName: model.userName,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      password: model.password,
      phone: model.phone,
      userStatus: model.userStatus,
    );
  }
}

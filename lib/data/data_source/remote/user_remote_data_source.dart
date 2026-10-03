
import 'package:pet_store_app/core/services/dio_client.dart';

import '../../model/user_model.dart';


abstract class UserRemoteDataSource {
  Future<UserModel> getUserByUsername(String username);
  Future<void> createUser(UserModel user);
  Future<void> updateUser(String username, UserModel user);
  Future<void> deleteUser(String username);
  Future<String> login(String username, String password);
  Future<void> logout();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getUserByUsername(String username) async {
    final response = await dio.instance.get('/user/$username');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> createUser(UserModel user) async {
    await dio.instance.post('/user', data: user.toJson());
  }

  @override
  Future<void> updateUser(String username, UserModel user) async {
    await dio.instance.put('/user/$username', data: user.toJson());
  }

  @override
  Future<void> deleteUser(String username) async {
    await dio.instance.delete('/user/$username');
  }

  @override
  Future<String> login(String username, String password) async {
    final response = await dio.instance.get(
      '/user/login',
      queryParameters: {'username': username, 'password': password},
    );
    return response.data['message'] as String;
  }

  @override
  Future<void> logout() async {
    await dio.instance.get('/user/logout');
  }
}
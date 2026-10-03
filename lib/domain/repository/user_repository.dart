import 'package:pet_store_app/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(UserEntity user);
  Future<UserEntity> login(String username, String password);
  Future<UserEntity> getUserByUsername(String username);
  Future<void> updateUser(String username, UserEntity user);
  Future<void> logout();
}
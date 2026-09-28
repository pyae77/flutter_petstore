import 'package:my_test_app/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(UserEntity user);
  Future<UserEntity> login(String username, String password);
}
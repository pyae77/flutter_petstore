// domain/use_cases/login_use_case.dart
import 'package:my_test_app/domain/entity/user_entity.dart';
import 'package:my_test_app/domain/repository/user_repository.dart';

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String username, String password) {
    return repository.login(username, password);
  }
}
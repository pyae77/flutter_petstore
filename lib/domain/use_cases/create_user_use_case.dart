
import 'package:pet_store_app/domain/entity/user_entity.dart';
import 'package:pet_store_app/domain/repository/user_repository.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<void> call(UserEntity user) async {
    return await repository.createUser(user);
  }
}
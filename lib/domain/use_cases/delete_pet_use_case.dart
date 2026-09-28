import 'package:my_test_app/domain/repository/pet_repository.dart';

class DeletePetUseCase {
  final PetRepository repository;
  DeletePetUseCase(this.repository);
  Future<void> call(int petId, {String? apiKey}) => repository.deletePet(petId, apiKey: apiKey);
}
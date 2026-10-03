import 'package:pet_store_app/data/model/pet_model.dart';
import 'package:pet_store_app/domain/repository/pet_repository.dart';

class UpdatePetUseCase {
  final PetRepository repository;
  UpdatePetUseCase(this.repository);
  Future<PetModel> call(PetModel pet) => repository.updatePet(pet);
}
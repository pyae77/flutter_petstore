import 'package:pet_store_app/data/model/pet_model.dart';
import 'package:pet_store_app/domain/repository/pet_repository.dart';

class AddPetUseCase {
  final PetRepository repository;
  AddPetUseCase(this.repository);
  Future<PetModel> call(PetModel pet) => repository.addPet(pet);
}
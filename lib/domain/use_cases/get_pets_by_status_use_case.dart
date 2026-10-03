import 'package:pet_store_app/data/model/pet_model.dart';
import 'package:pet_store_app/domain/repository/pet_repository.dart';

class GetPetsByStatusUseCase {
  final PetRepository repository;
  GetPetsByStatusUseCase(this.repository);
  Future<List<PetModel>> call(List<String> status) => repository.getPetsByStatus(status);
}
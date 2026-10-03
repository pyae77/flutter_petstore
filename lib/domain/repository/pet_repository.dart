
import 'dart:io';
import 'package:pet_store_app/data/model/pet_model.dart';

import '../../data/model/pet_upload_image_response_model.dart';

abstract class PetRepository {
  Future<PetUploadImageResponseModel> uploadImage(int petId, String? metadata, File file);
  Future<PetModel> addPet(PetModel pet);
  Future<PetModel> updatePet(PetModel pet);
  Future<List<PetModel>> getPetsByStatus(List<String> status);
  Future<PetModel> getPetById(int petId);
  Future<void> updatePetWithForm(int petId, String? name, String? status);
  Future<void> deletePet(int petId, {String? apiKey});
}


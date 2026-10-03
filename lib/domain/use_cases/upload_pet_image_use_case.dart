import 'dart:io';

import 'package:pet_store_app/domain/repository/pet_repository.dart';

import '../../data/model/pet_upload_image_response_model.dart';

class UploadPetImageUseCase {
  final PetRepository repository;
  UploadPetImageUseCase(this.repository);
  Future<PetUploadImageResponseModel> call(int petId, String? metadata, File file) =>
      repository.uploadImage(petId, metadata, file);
}
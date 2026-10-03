import 'dart:io';

import 'package:pet_store_app/data/data_source/remote/pet_remote_data_source.dart';
import 'package:pet_store_app/data/model/pet_model.dart';
import 'package:pet_store_app/domain/repository/pet_repository.dart';

import '../model/pet_upload_image_response_model.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remoteDataSource;

  PetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PetUploadImageResponseModel> uploadImage(int petId, String? metadata, File file) =>
      remoteDataSource.uploadImage(petId, metadata, file);

  @override
  Future<PetModel> addPet(PetModel pet) => remoteDataSource.addPet(pet);

  @override
  Future<PetModel> updatePet(PetModel pet) => remoteDataSource.updatePet(pet);

  @override
  Future<List<PetModel>> getPetsByStatus(List<String> status) =>
      remoteDataSource.getPetsByStatus(status);

  @override
  Future<PetModel> getPetById(int petId) => remoteDataSource.getPetById(petId);

  @override
  Future<void> updatePetWithForm(int petId, String? name, String? status) =>
      remoteDataSource.updatePetWithForm(petId, name, status);

  @override
  Future<void> deletePet(int petId, {String? apiKey}) =>
      remoteDataSource.deletePet(petId, apiKey: apiKey);
}
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pet_store_app/core/services/dio_client.dart';
import 'package:pet_store_app/data/model/pet_model.dart';
import 'package:pet_store_app/data/model/pet_upload_image_response_model.dart';

abstract class PetRemoteDataSource {
  Future<PetUploadImageResponseModel> uploadImage(
    int petId,
    String? additionalMetadata,
    File file,
  );

  
  Future<PetModel> addPet(PetModel pet);


  Future<PetModel> updatePet(PetModel pet);

  Future<List<PetModel>> getPetsByStatus(List<String> status);

  Future<PetModel> getPetById(int petId);

  Future<void> updatePetWithForm(int petId, String? name, String? status);


  Future<void> deletePet(int petId, {String? apiKey});
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final DioClient dio;

  PetRemoteDataSourceImpl({required this.dio});

  @override
  Future<PetUploadImageResponseModel> uploadImage(
    int petId,
    String? additionalMetadata,
    File file,
  ) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      'additionalMetadata': ?additionalMetadata,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await dio.instance.post(
      '/pet/$petId/uploadImage',
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );

    return PetUploadImageResponseModel.fromJson(response.data);
  }
 
  @override
  Future<PetModel> addPet(PetModel pet) async {
    final response = await dio.instance.post(
      '/pet',
      data: pet.toJson(),
    );
    return PetModel.fromJson(response.data);
  }

  @override
  Future<PetModel> updatePet(PetModel pet) async {
    final response = await dio.instance.put(
      '/pet',
      data: pet.toJson(),
    );
    return PetModel.fromJson(response.data);
  }

  @override
  Future<List<PetModel>> getPetsByStatus(List<String> status) async {
    final response = await dio.instance.get(
      '/pet/findByStatus',
      queryParameters: {
        'status': status.join(','),
      },
    );

    final List list = response.data;
   return list.map((json)=>PetModel.fromJson(json)).toList();
  }

  @override
  Future<PetModel> getPetById(int petId) async {
    final response = await dio.instance.get('/pet/$petId');
    return PetModel.fromJson(response.data);
  }

  @override
  Future<void> updatePetWithForm(int petId, String? name, String? status) async {
    final formData = FormData.fromMap({
      'name': ?name,
      'status': ?status,

    });

    await dio.instance.post(
      '/pet/$petId',
      data: formData,
      options: Options(
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
    );
  }

  @override
  Future<void> deletePet(int petId, {String? apiKey}) async {
    await dio.instance.delete(
      '/pet/$petId',
      options: Options(
        headers: {
          'api_key': ?apiKey,
        },
      ),
    );
  }

  
}
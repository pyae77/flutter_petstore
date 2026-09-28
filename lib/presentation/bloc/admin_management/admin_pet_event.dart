// presentation/bloc/admin_pet_event.dart
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:my_test_app/data/model/pet_model.dart';

abstract class AdminPetEvent extends Equatable {
  const AdminPetEvent();
  @override
  List<Object?> get props => [];
}

class FetchAdminPetsEvent extends AdminPetEvent {
  final List<String> status;
  const FetchAdminPetsEvent({this.status = const ['available']});
  @override
  List<Object?> get props => [status];
}

class AddNewPetEvent extends AdminPetEvent {
  final PetModel pet;
  final File? imageFile;
  const AddNewPetEvent(this.pet, {this.imageFile});
  @override
  List<Object?> get props => [pet,imageFile];
}

class UpdateExistingPetEvent extends AdminPetEvent {
  final PetModel pet;
  const UpdateExistingPetEvent(this.pet);
  @override
  List<Object?> get props => [pet];
}

class DeletePetByIdEvent extends AdminPetEvent {
  final int petId;
  final String? apiKey;
  const DeletePetByIdEvent(this.petId, {this.apiKey});
  @override
  List<Object?> get props => [petId, apiKey];
}

class UploadPetImageEvent extends AdminPetEvent {
  final int petId;
  final File imageFile;
  final String? metadata;
  const UploadPetImageEvent({required this.petId, required this.imageFile, this.metadata});
  @override
  List<Object?> get props => [petId, imageFile, metadata];
}
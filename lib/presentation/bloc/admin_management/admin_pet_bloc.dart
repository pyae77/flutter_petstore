import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_store_app/domain/use_cases/add_pet_use_case.dart';
import 'package:pet_store_app/domain/use_cases/delete_pet_use_case.dart';
import 'package:pet_store_app/domain/use_cases/get_pets_by_status_use_case.dart';
import 'package:pet_store_app/domain/use_cases/update_pet_use_case.dart';
import 'package:pet_store_app/domain/use_cases/upload_pet_image_use_case.dart';
import 'admin_pet_event.dart';
import 'admin_pet_state.dart';

class AdminPetBloc extends Bloc<AdminPetEvent, AdminPetState> {
  final GetPetsByStatusUseCase getPetsByStatusUseCase;
  final AddPetUseCase addPetUseCase;
  final UpdatePetUseCase updatePetUseCase;
  final DeletePetUseCase deletePetUseCase;
  final UploadPetImageUseCase uploadPetImageUseCase;

  AdminPetBloc({
    required this.getPetsByStatusUseCase,
    required this.addPetUseCase,
    required this.updatePetUseCase,
    required this.deletePetUseCase,
    required this.uploadPetImageUseCase,
  }) : super(AdminPetInitialState()) {
    on<FetchAdminPetsEvent>(_onFetchAdminPets);
    on<AddNewPetEvent>(_onAddNewPet);
    on<UpdateExistingPetEvent>(_onUpdateExistingPet);
    on<DeletePetByIdEvent>(_onDeletePetById);
    on<UploadPetImageEvent>(_onUploadPetImage);
  }

  // Fetch Pets
  Future<void> _onFetchAdminPets(
    FetchAdminPetsEvent event,
    Emitter<AdminPetState> emit,
  ) async {
    try {
      emit(AdminPetLoadingState());
      final pets = await getPetsByStatusUseCase(event.status);
      emit(AdminPetLoadedState(pets));
    } catch (e) {
      emit(AdminPetErrorState(e.toString()));
    }
  }

  // Add New Pet + Upload Image
  
  Future<void> _onAddNewPet(
  AddNewPetEvent event,
  Emitter<AdminPetState> emit,
) async {
  try {
    emit(AdminPetLoadingState());

    final createdPet = await addPetUseCase(event.pet);

   
    if (event.imageFile != null && createdPet.id != null) {
      await uploadPetImageUseCase(
        createdPet.id!,
        'Pet image uploaded from admin panel', 
        event.imageFile!,
      );
    }

    emit(const AdminPetActionSuccessState('Successfully added pet with image!'));

  
    final pets = await getPetsByStatusUseCase(['available', 'pending', 'sold']);
    emit(AdminPetLoadedState(pets));

  } catch (e) {
    emit(AdminPetErrorState(e.toString()));
  }
}


  Future<void> _onUploadPetImage(
  UploadPetImageEvent event,
  Emitter<AdminPetState> emit,
) async {
  try {
    emit(AdminPetLoadingState());


    await uploadPetImageUseCase(
      event.petId,
      event.metadata,
      event.imageFile,
    );

    emit(const AdminPetActionSuccessState('Image uploaded successfully!'));

    
    final pets = await getPetsByStatusUseCase(['available', 'pending', 'sold']);
    emit(AdminPetLoadedState(pets));

  } catch (e) {
    emit(AdminPetErrorState(e.toString()));
  }
}
  // Update Pet
  Future<void> _onUpdateExistingPet(
    UpdateExistingPetEvent event,
    Emitter<AdminPetState> emit,
  ) async {
    try {
      emit(AdminPetLoadingState());
      await updatePetUseCase(event.pet);
      emit(const AdminPetActionSuccessState('Successfully updated pet!'));
      add(const FetchAdminPetsEvent());
    } catch (e) {
      emit(AdminPetErrorState(e.toString()));
    }
  }

  // Delete Pet
  Future<void> _onDeletePetById(
    DeletePetByIdEvent event,
    Emitter<AdminPetState> emit,
  ) async {
    try {
      emit(AdminPetLoadingState());
      await deletePetUseCase(event.petId, apiKey: event.apiKey);
      emit(const AdminPetActionSuccessState('Successfully deleted pet!'));
      add(const FetchAdminPetsEvent());
    } catch (e) {
      emit(AdminPetErrorState(e.toString()));
    }
  }
}
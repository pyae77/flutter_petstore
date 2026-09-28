// presentation/bloc/admin_pet_state.dart
import 'package:equatable/equatable.dart';
import 'package:my_test_app/data/model/pet_model.dart';

abstract class AdminPetState extends Equatable {
  const AdminPetState();
  @override
  List<Object?> get props => [];
}

class AdminPetInitialState extends AdminPetState {}
class AdminPetLoadingState extends AdminPetState {}

class AdminPetLoadedState extends AdminPetState {
  final List<PetModel> pets;
  const AdminPetLoadedState(this.pets);
  @override
  List<Object?> get props => [pets];
}

class AdminPetActionSuccessState extends AdminPetState {
  final String message;
  const AdminPetActionSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class AdminPetErrorState extends AdminPetState {
  final String message;
  const AdminPetErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
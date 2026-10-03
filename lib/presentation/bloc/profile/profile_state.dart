// profile_state.dart
import 'package:equatable/equatable.dart';
import 'package:pet_store_app/domain/entity/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final UserEntity user;
  const ProfileLoadedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileErrorState extends ProfileState {
  final String message;
  const ProfileErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileLogoutSuccessState extends ProfileState {}
// profile_event.dart
import 'package:equatable/equatable.dart';
import 'package:pet_store_app/domain/entity/user_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String username;
  final UserEntity user;

  const UpdateProfileEvent({required this.username, required this.user});

  @override
  List<Object?> get props => [username, user];
}

class LogoutEvent extends ProfileEvent {}
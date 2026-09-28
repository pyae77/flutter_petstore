// profile_event.dart
import 'package:equatable/equatable.dart';
import 'package:my_test_app/data/model/user_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String username;
  final UserModel user;

  const UpdateProfileEvent({required this.username, required this.user});

  @override
  List<Object?> get props => [username, user];
}

class LogoutEvent extends ProfileEvent {}
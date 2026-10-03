import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_store_app/core/services/storage_service.dart';
import 'package:pet_store_app/domain/repository/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final StorageService storageService;

  ProfileBloc({
    required this.userRepository,
    required this.storageService,
  }) : super(ProfileInitialState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      final username = await storageService.getUsername() ?? '';
      if (username.isNotEmpty) {
        final user = await userRepository.getUserByUsername(username);
        emit(ProfileLoadedState(user: user));
      } else {
        emit(const ProfileErrorState(message: 'User session not found'));
      }
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      await userRepository.updateUser(event.username, event.user);
      await storageService.saveAuthData(
        token: await storageService.getSessionToken() ?? '',
        username: event.user.userName ?? event.username,
      );
      emit(ProfileLoadedState(user: event.user));
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      await userRepository.logout();
      await storageService.clearAuthData();
      emit(ProfileLogoutSuccessState());
    } catch (e) {
      await storageService.clearAuthData();
      emit(ProfileLogoutSuccessState());
    }
  }
}
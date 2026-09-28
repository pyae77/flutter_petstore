import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_test_app/core/services/storage_service.dart';
import 'package:my_test_app/data/data_source/remote/user_remote_data_source.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRemoteDataSource userRemoteDataSource;
  final StorageService storageService;

  ProfileBloc({
    required this.userRemoteDataSource,
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
        final user = await userRemoteDataSource.getUserByUsername(username);
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
      await userRemoteDataSource.updateUser(event.username, event.user);
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
      await userRemoteDataSource.logout(); // API Logout call
      await storageService.clearAuthData(); // Local Secure Storage Clear
      emit(ProfileLogoutSuccessState());
    } catch (e) {
    
      await storageService.clearAuthData();
      emit(ProfileLogoutSuccessState());
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_store_app/core/services/storage_service.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final StorageService storageService;

  SplashBloc({required this.storageService}) : super(SplashInitial()) {
    on<SplashAppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(
    SplashAppStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 3));

    final bool isFirstTime = await storageService.isFirstTime();
    final String? token = await storageService.getSessionToken();

    if (isFirstTime) {
      await storageService.setFirstTimeCompleted();
      emit(SplashFirstTime());
    } else if (token != null && token.isNotEmpty) {
      emit(SplashAuthenticated());
    } else {
      emit(SplashUnauthenticated());
    }
  }
}
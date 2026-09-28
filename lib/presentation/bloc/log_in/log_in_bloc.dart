import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_test_app/domain/use_cases/log_in_use_case.dart';
import 'package:my_test_app/presentation/bloc/log_in/log_in_event.dart';
import 'package:my_test_app/presentation/bloc/log_in/log_in_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginInitial()) {
    
    // Toggle Password Visibility Event
    on<PasswordIconEvent>((event, emit) {
      final currentVisibility = state.isPasswordVisible;
      emit(LoginInitial(isPasswordVisible: !currentVisibility));
    });

    // Submit Login Event
    on<SubmitLoginEvent>((event, emit) async {
      final currentVisibility = state.isPasswordVisible;
      
      emit(LoginLoading(isPasswordVisible: currentVisibility));
      try {
        final user = await loginUseCase(event.username, event.password);
        emit(LoginSuccess(user, isPasswordVisible: currentVisibility));
      } catch (e) {
        emit(LoginFailure(e.toString(), isPasswordVisible: currentVisibility));
      }
    });
  }
}
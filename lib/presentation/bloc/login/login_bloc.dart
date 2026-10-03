import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_store_app/core/utils/validators.dart';
import 'package:pet_store_app/domain/use_cases/login_use_case.dart';
import 'package:pet_store_app/presentation/bloc/login/login_event.dart';
import 'package:pet_store_app/presentation/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginInitial()) {
    on<UsernameChanged>((event, emit) {
      emit(state.toEditingState().copyWith(username: event.value));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.toEditingState().copyWith(password: event.value));
    });

    on<TogglePasswordVisibility>((event, emit) {
      emit(
        state.toEditingState().copyWith(
          isPasswordVisible: !state.isPasswordVisible,
        ),
      );
    });

    on<SubmitLoginEvent>((event, emit) async {
      final username = state.username.trim();
      final password = state.password.trim();

      final usernameError = AppValidators.validateRequired(
        username,
        fieldName: 'username',
      );
      if (usernameError != null) {
        emit(
          LoginFailure(
            usernameError,
            username: username,
            password: password,
            isPasswordVisible: state.isPasswordVisible,
          ),
        );
        return;
      }

      final passwordError = AppValidators.validatePassword(password);
      if (passwordError != null) {
        emit(
          LoginFailure(
            passwordError,
            username: username,
            password: password,
            isPasswordVisible: state.isPasswordVisible,
          ),
        );
        return;
      }

      emit(
        LoginLoading(
          username: username,
          password: password,
          isPasswordVisible: state.isPasswordVisible,
        ),
      );

      try {
        final user = await loginUseCase(username, password);
        emit(
          LoginSuccess(
            user,
            username: username,
            password: password,
            isPasswordVisible: state.isPasswordVisible,
          ),
        );
      } catch (e) {
        emit(
          LoginFailure(
            e.toString(),
            username: username,
            password: password,
            isPasswordVisible: state.isPasswordVisible,
          ),
        );
      }
    });
  }
}

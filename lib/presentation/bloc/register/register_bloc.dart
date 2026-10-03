import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_store_app/core/utils/validators.dart';
import 'package:pet_store_app/domain/entity/user_entity.dart';
import 'package:pet_store_app/domain/use_cases/create_user_use_case.dart';
import 'package:pet_store_app/presentation/bloc/register/register_state.dart';
import 'register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CreateUserUseCase createUserUseCase;

  RegisterBloc(this.createUserUseCase) : super(const RegisterInitial()) {
    on<UsernameChanged>((event, emit) {
      emit(state.toEditingState().copyWith(username: event.value));
    });

    on<FirstNameChanged>((event, emit) {
      emit(state.toEditingState().copyWith(firstName: event.value));
    });

    on<LastNameChanged>((event, emit) {
      emit(state.toEditingState().copyWith(lastName: event.value));
    });

    on<EmailChanged>((event, emit) {
      emit(state.toEditingState().copyWith(email: event.value));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.toEditingState().copyWith(password: event.value));
    });

    on<PhoneChanged>((event, emit) {
      emit(state.toEditingState().copyWith(phone: event.value));
    });

    on<SubmitRegisterEvent>((event, emit) async {
      final username = state.username.trim();
      final firstName = state.firstName.trim();
      final lastName = state.lastName.trim();
      final email = state.email.trim();
      final password = state.password.trim();
      final phone = state.phone.trim();

      void emitValidationFailure(String message) {
        emit(
          RegisterFailure(
            message,
            username: username,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phone: phone,
          ),
        );
      }

      final usernameError = AppValidators.validateRequired(
        username,
        fieldName: 'username',
      );
      if (usernameError != null) {
        emitValidationFailure(usernameError);
        return;
      }

      final firstNameError = AppValidators.validateRequired(
        firstName,
        fieldName: 'first name',
      );
      if (firstNameError != null) {
        emitValidationFailure(firstNameError);
        return;
      }

      final lastNameError = AppValidators.validateRequired(
        lastName,
        fieldName: 'last name',
      );
      if (lastNameError != null) {
        emitValidationFailure(lastNameError);
        return;
      }

      final emailError = AppValidators.validateEmail(email);
      if (emailError != null) {
        emitValidationFailure(emailError);
        return;
      }

      final passwordError = AppValidators.validatePassword(password);
      if (passwordError != null) {
        emitValidationFailure(passwordError);
        return;
      }

      final phoneError = AppValidators.validatePhone(phone);
      if (phoneError != null) {
        emitValidationFailure(phoneError);
        return;
      }

      emit(
        RegisterLoading(
          username: username,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          phone: phone,
        ),
      );

      try {
        final user = UserEntity(
          id: 0,
          userName: username,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          phone: phone,
          userStatus: 1,
        );
        await createUserUseCase(user);
        emit(
          RegisterSuccess(
            username: username,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phone: phone,
          ),
        );
      } catch (e) {
        emit(
          RegisterFailure(
            e.toString(),
            username: username,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phone: phone,
          ),
        );
      }
    });
  }
}

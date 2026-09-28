import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_test_app/domain/use_cases/create_user_use_case.dart';
import 'package:my_test_app/presentation/bloc/register/register_state.dart';
import 'register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CreateUserUseCase createUserUseCase;

  RegisterBloc(this.createUserUseCase) : super(RegisterInitial()) {
    on<SubmitRegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        await createUserUseCase(event.user);
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}
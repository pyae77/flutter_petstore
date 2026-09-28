import 'package:my_test_app/domain/entity/user_entity.dart';

abstract class LoginState {
  final bool isPasswordVisible;

  const LoginState({this.isPasswordVisible = false});
}

class LoginInitial extends LoginState {
  const LoginInitial({super.isPasswordVisible = false});
}

class LoginLoading extends LoginState {
  const LoginLoading({super.isPasswordVisible = false});
}

class LoginSuccess extends LoginState {
  final UserEntity user; 

  const LoginSuccess(this.user, {super.isPasswordVisible = false});
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message, {super.isPasswordVisible = false});
}
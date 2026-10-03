import 'package:pet_store_app/domain/entity/user_entity.dart';

abstract class LoginState {
  final String username;
  final String password;
  final bool isPasswordVisible;
  final String? errorMessage;

  const LoginState({
    this.username = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.errorMessage,
  });

  LoginInitial toEditingState() => LoginInitial(
    username: username,
    password: password,
    isPasswordVisible: isPasswordVisible,
  );

  LoginState copyWith({
    String? username,
    String? password,
    bool? isPasswordVisible,
    String? errorMessage,
  });
}

class LoginInitial extends LoginState {
  const LoginInitial({
    super.username = '',
    super.password = '',
    super.isPasswordVisible = false,
    super.errorMessage,
  });

  @override
  LoginInitial copyWith({
    String? username,
    String? password,
    bool? isPasswordVisible,
    String? errorMessage,
  }) {
    return LoginInitial(
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginLoading extends LoginState {
  const LoginLoading({
    super.username = '',
    super.password = '',
    super.isPasswordVisible = false,
    super.errorMessage,
  });

  @override
  LoginLoading copyWith({
    String? username,
    String? password,
    bool? isPasswordVisible,
    String? errorMessage,
  }) {
    return LoginLoading(
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginSuccess extends LoginState {
  final UserEntity user;

  const LoginSuccess(
    this.user, {
    super.username = '',
    super.password = '',
    super.isPasswordVisible = false,
    super.errorMessage,
  });

  @override
  LoginSuccess copyWith({
    UserEntity? user,
    String? username,
    String? password,
    bool? isPasswordVisible,
    String? errorMessage,
  }) {
    return LoginSuccess(
      user ?? this.user,
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(
    this.message, {
    super.username = '',
    super.password = '',
    super.isPasswordVisible = false,
    super.errorMessage,
  });

  @override
  LoginFailure copyWith({
    String? message,
    String? username,
    String? password,
    bool? isPasswordVisible,
    String? errorMessage,
  }) {
    return LoginFailure(
      message ?? this.message,
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

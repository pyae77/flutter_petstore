abstract class RegisterState {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String? errorMessage;

  const RegisterState({
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.phone = '',
    this.errorMessage,
  });

  RegisterInitial toEditingState() => RegisterInitial(
    username: username,
    firstName: firstName,
    lastName: lastName,
    email: email,
    password: password,
    phone: phone,
  );

  RegisterState copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phone,
    String? errorMessage,
  });
}

class RegisterInitial extends RegisterState {
  const RegisterInitial({
    super.username = '',
    super.firstName = '',
    super.lastName = '',
    super.email = '',
    super.password = '',
    super.phone = '',
    super.errorMessage,
  });

  @override
  RegisterInitial copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phone,
    String? errorMessage,
  }) {
    return RegisterInitial(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RegisterLoading extends RegisterState {
  const RegisterLoading({
    super.username = '',
    super.firstName = '',
    super.lastName = '',
    super.email = '',
    super.password = '',
    super.phone = '',
    super.errorMessage,
  });

  @override
  RegisterLoading copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phone,
    String? errorMessage,
  }) {
    return RegisterLoading(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess({
    super.username = '',
    super.firstName = '',
    super.lastName = '',
    super.email = '',
    super.password = '',
    super.phone = '',
    super.errorMessage,
  });

  @override
  RegisterSuccess copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phone,
    String? errorMessage,
  }) {
    return RegisterSuccess(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure(
    this.message, {
    super.username = '',
    super.firstName = '',
    super.lastName = '',
    super.email = '',
    super.password = '',
    super.phone = '',
    super.errorMessage,
  });

  @override
  RegisterFailure copyWith({
    String? message,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phone,
    String? errorMessage,
  }) {
    return RegisterFailure(
      message ?? this.message,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

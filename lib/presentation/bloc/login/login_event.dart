abstract class LoginEvent {}

class UsernameChanged extends LoginEvent {
  final String value;

  UsernameChanged(this.value);
}

class PasswordChanged extends LoginEvent {
  final String value;

  PasswordChanged(this.value);
}

class TogglePasswordVisibility extends LoginEvent {}

class SubmitLoginEvent extends LoginEvent {}
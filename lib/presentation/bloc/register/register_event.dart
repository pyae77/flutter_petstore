abstract class RegisterEvent {}

class UsernameChanged extends RegisterEvent {
  final String value;
  UsernameChanged(this.value);
}

class FirstNameChanged extends RegisterEvent {
  final String value;
  FirstNameChanged(this.value);
}

class LastNameChanged extends RegisterEvent {
  final String value;
  LastNameChanged(this.value);
}

class EmailChanged extends RegisterEvent {
  final String value;
  EmailChanged(this.value);
}

class PasswordChanged extends RegisterEvent {
  final String value;
  PasswordChanged(this.value);
}

class PhoneChanged extends RegisterEvent {
  final String value;
  PhoneChanged(this.value);
}

class SubmitRegisterEvent extends RegisterEvent {}


abstract class LoginEvent {}

class SubmitLoginEvent extends LoginEvent {
  final String username;
  final String password;

  SubmitLoginEvent({required this.username, required this.password});
}
class PasswordIconEvent extends LoginEvent{
  
}
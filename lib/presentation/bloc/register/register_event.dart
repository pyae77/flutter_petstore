

import 'package:my_test_app/domain/entity/user_entity.dart';

abstract class RegisterEvent {}

class SubmitRegisterEvent extends RegisterEvent {
  final UserEntity user;
  SubmitRegisterEvent(this.user);
}



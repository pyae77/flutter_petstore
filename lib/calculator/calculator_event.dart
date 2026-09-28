import 'package:equatable/equatable.dart';

abstract class CalculatorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ဂဏန်း နှိပ်လိုက်သည့် Event
class NumberPressed extends CalculatorEvent {
  final String number;
  NumberPressed(this.number);

  @override
  List<Object?> get props => [number];
}

// သင်္ကေတ နှိပ်လိုက်သည့် Event
class OperatorPressed extends CalculatorEvent {
  final String operator;
  OperatorPressed(this.operator);

  @override
  List<Object?> get props => [operator];
}

// Action ( = သို့မဟုတ် C ) နှိပ်လိုက်သည့် Event
class ActionPressed extends CalculatorEvent {
  final String action; // '=' or 'C'
  ActionPressed(this.action);

  @override
  List<Object?> get props => [action];
}
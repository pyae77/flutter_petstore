import 'package:equatable/equatable.dart';

class CalculatorState extends Equatable{
  final String expression;
  final String result;
  const CalculatorState({required this.expression,required this.result});

  @override
  // TODO: implement props
  List<Object?> get props => [expression,result];
 
}
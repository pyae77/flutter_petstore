import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super( CalculatorState(expression: '', result: '0')) {
    on<NumberPressed>(_onNumberPressed);
    on<OperatorPressed>(_onOperatorPressed);
    on<ActionPressed>(_onActionPressed);
  }

  // ဂဏန်း နှိပ်သည့်အခါ
  void _onNumberPressed(NumberPressed event, Emitter<CalculatorState> emit) {
    final newExpression = state.expression + event.number;
    final autoResult = _calculateLiveResult(newExpression);

    emit(CalculatorState(
      expression: newExpression,
      result: autoResult,
    ));
  }

  // Operator (+, -, *, /) နှိပ်သည့်အခါ
  void _onOperatorPressed(OperatorPressed event, Emitter<CalculatorState> emit) {
    if (state.expression.isEmpty) return;

    String currentExp = state.expression;
    // အနောက်ဆုံးက Operator ဖြစ်နေရင် အသစ်နဲ့ အစားထိုးမယ်
    if (['+', '-', '*', '/'].contains(currentExp.substring(currentExp.length - 1))) {
      currentExp = currentExp.substring(0, currentExp.length - 1);
    }

    final newExpression = '$currentExp${event.operator}';
    
    emit(CalculatorState(
      expression: newExpression,
      result: state.result,
    ));
  }

  // Action (C သို့မဟုတ် Backspace) နှိပ်သည့်အခါ
  void _onActionPressed(ActionPressed event, Emitter<CalculatorState> emit) {
    if (event.action == 'C') {
      emit( CalculatorState(expression: '', result: '0'));
    }
  }

  // 💡 Real-time Auto Calculate လုပ်ပေးသည့် Helper Logic
  String _calculateLiveResult(String exp) {
    try {
      // ဥပမာ "8-9" ကို ခွဲထုတ်ပြီး Auto တွက်ပေးခြင်း
      // (အနုတ် သင်္ကေတအတွက် Logic ထိန်းထားခြင်း)
      for (String op in ['+', '-', '*', '/']) {
        if (exp.contains(op) && !exp.startsWith(op)) {
          List<String> parts = exp.split(op);
          if (parts.length == 2 && parts[1].isNotEmpty) {
            double num1 = double.parse(parts[0]);
            double num2 = double.parse(parts[1]);
            double res = 0;

            switch (op) {
              case '+': res = num1 + num2; break;
              case '-': res = num1 - num2; break;
              case '*': res = num1 * num2; break;
              case '/': res = num2 != 0 ? num1 / num2 : 0; break;
            }

            return res % 1 == 0 ? res.toInt().toString() : res.toString();
          }
        }
      }
      return exp; // Operator မပါသေးရင် ရိုက်ထားတဲ့ ဂဏန်းအတိုင်း ပြမယ်
    } catch (e) {
      return state.result;
    }
  }
}
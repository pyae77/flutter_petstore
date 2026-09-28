import 'package:flutter/material.dart';
import 'calculator_bloc.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalculatorBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Display Screen Section
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(24.0),
                  child: // Display Section
BlocBuilder<CalculatorBloc, CalculatorState>(
  builder: (context, state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 1. ရိုက်နေသမျှ Step by Step ပေါ်မည့်နေရာ (ဥပမာ - 8-9)
        Text(
          state.expression.isEmpty ? '0' : state.expression,
          style: const TextStyle(color: Colors.grey, fontSize: 32),
        ),
        const SizedBox(height: 10),
        // 2. Real-time Auto ထွက်လာမည့် Result (ဥပမာ - -1)
        Text(
          state.result,
          style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
        ),
      ],
    );
  },
)
                ),
              ),

              // Keypad Buttons Section
              Column(
                children: [
                  _buildRow(context, ['C', '', '', '/']),
                  _buildRow(context, ['7', '8', '9', '*']),
                  _buildRow(context, ['4', '5', '6', '-']),
                  _buildRow(context, ['1', '2', '3', '+']),
                  _buildRow(context, ['0', '.', '=']),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<String> buttons) {
    return Row(
      children: buttons.map((btn) {
        if (btn.isEmpty) return Expanded(child: Container());
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (btnContext) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: _getButtonColor(btn),
                  ),
                  onPressed: () {
                    final bloc = btnContext.read<CalculatorBloc>();
                    if (['+', '-', '*', '/'].contains(btn)) {
                      bloc.add(OperatorPressed(btn));
                    } else if (['C', '='].contains(btn)) {
                      bloc.add(ActionPressed(btn));
                    } else {
                      bloc.add(NumberPressed(btn));
                    }
                  },
                  child: Text(
                    btn,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getButtonColor(String text) {
    if (['+', '-', '*', '/', '='].contains(text)) {
      return Colors.orange;
    } else if (text == 'C') {
      return Colors.grey;
    }
    return Colors.grey[850]!;
  }
}
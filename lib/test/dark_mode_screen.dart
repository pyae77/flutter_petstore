import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_test_app/test/dark_mode_bloc.dart';
import 'package:my_test_app/test/dark_mode_event.dart';
import 'package:my_test_app/test/dark_mode_state.dart';

class DarkModeScreen extends StatelessWidget {
  const DarkModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DarkModeBloc(),

      child: BlocBuilder<DarkModeBloc,DarkModeState>(
        builder: (context,state)=> Scaffold(
          body: Column(
            children: [
              ElevatedButton(onPressed: (){
                 context.read<DarkModeBloc>().add(DarkModeEvent());

              }, child: Text('Dark Mode',selectionColor: state.isDarkMode?Colors.amber:Colors.black,)),       ],
          ),
        ),
      ),
    );
  }
}
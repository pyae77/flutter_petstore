import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_test_app/test/dark_mode_event.dart';
import 'package:my_test_app/test/dark_mode_state.dart';

class DarkModeBloc extends Bloc<DarkModeEvent,DarkModeState> {
  DarkModeBloc():super(DarkModeState(isDarkMode: false)){
    on<DarkModeEvent>((event, emit) => emit(DarkModeState(isDarkMode: !state.isDarkMode)),);
  }
} 
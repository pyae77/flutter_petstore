import 'package:bloc/bloc.dart';
import 'package:my_test_app/presentation/bloc/main_home/main_home_event.dart';
import 'package:my_test_app/presentation/bloc/main_home/main_home_state.dart';

class MainHomeBloc extends Bloc<MainHomeEvent, MainHomeState> {
  MainHomeBloc() : super( MainHomeState(tabIndex: 0)) {
    on<TabChangedEvent>((event, emit) {
      emit(MainHomeState(tabIndex: event.tabIndex));
    });
  }}

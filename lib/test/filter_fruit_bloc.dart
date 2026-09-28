import 'package:bloc/bloc.dart';
import 'package:my_test_app/test/filter_fruit_event.dart';
import 'package:my_test_app/test/filter_fruit_state.dart';

class FilterFruitBloc extends Bloc<FilterFruitEvent,FilterFruitState> {
  FilterFruitBloc():super(FilterFruitState(fruits: [])){
  on<SelectFruitEvent>(_selectFruit);
  on<SelectAllFruitsEvent>(_selectAllFruits);
  on<ClearAllFruitsEvent>(_clearAllFruits);
  }
  void _selectFruit(SelectFruitEvent event,Emitter<FilterFruitState>emit){
   emit(FilterFruitState(fruits: event.fruits));
  }
  void _selectAllFruits(SelectAllFruitsEvent event,Emitter<FilterFruitState>emit){
   emit(FilterFruitState(fruits: event.fruits));
  }
  void _clearAllFruits(ClearAllFruitsEvent event,Emitter<FilterFruitState> emit){
    emit(FilterFruitState(fruits: []));
  }
}
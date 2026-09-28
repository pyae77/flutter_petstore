import 'package:bloc/bloc.dart';
import 'package:my_test_app/domain/repository/pet_repository.dart';
import 'package:my_test_app/presentation/bloc/store_screen/pet_event.dart';
import 'package:my_test_app/presentation/bloc/store_screen/pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final PetRepository repository;

  PetBloc({required this.repository}) : super(const PetState()) {
    on<FetchPetsByStatusEvent>(_onFetchPetsByStatus);
    on<SearchPetByNameEvent>(_onSearchPetByName);
    on<LoadMorePetsEvent>(_onLoadMorePets);
  }

  Future<void> _onFetchPetsByStatus(
    FetchPetsByStatusEvent event,
    Emitter<PetState> emit,
  ) async {
    emit(state.copyWith(
      status: PetStatus.loading,
      selectedStatus: event.status,
    ));

    try {
      final result = await repository.getPetsByStatus([event.status]);
      
      const initialLimit = 10;
      final paginatedList = result.take(initialLimit).toList();

      emit(state.copyWith(
        status: PetStatus.success,
        pets: result,
        searchResults: result,
        filteredPets: paginatedList,
        pageLimit: initialLimit,
        hasMore: result.length > initialLimit,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PetStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchPetByName(SearchPetByNameEvent event, Emitter<PetState> emit) {
    if (event.query.isEmpty) {
      const initialLimit = 10;
      final paginatedList = state.pets.take(initialLimit).toList();

      emit(state.copyWith(
        searchResults: state.pets,
        filteredPets: paginatedList,
        pageLimit: initialLimit,
        hasMore: state.pets.length > initialLimit,
      ));
      return;
    }

    final query = event.query.toLowerCase();
    final searchList = state.pets.where((pet) {
      return pet.name.toLowerCase().contains(query);
    }).toList();

    const initialLimit = 10;
    final paginatedList = searchList.take(initialLimit).toList();

    emit(state.copyWith(
      searchResults: searchList,
      filteredPets: paginatedList,
      pageLimit: initialLimit,
      hasMore: searchList.length > initialLimit,
    ));
  }

  Future<void> _onLoadMorePets(
  LoadMorePetsEvent event,
  Emitter<PetState> emit,
) async {
  if (!state.hasMore || state.isLoadingMore) return;

  emit(state.copyWith(isLoadingMore: true));

  final currentLength = state.filteredPets.length;
  final sourceList = state.searchResults;

  if (currentLength >= sourceList.length) {
    emit(state.copyWith(hasMore: false, isLoadingMore: false));
    return;
  }

  
  await Future.delayed(const Duration(milliseconds: 300));

  final nextLimit = currentLength + 10;
  final updatedList = sourceList.take(nextLimit).toList();

  emit(state.copyWith(
    filteredPets: updatedList,
    pageLimit: nextLimit,
    hasMore: sourceList.length > nextLimit,
    isLoadingMore: false,
  ));
}
}
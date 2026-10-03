import 'package:pet_store_app/data/model/pet_model.dart';

enum PetStatus { initial, loading, success, failure }

class PetState {
  final PetStatus status;
  final List<PetModel> pets;       
  final List<PetModel> searchResults;  
  final List<PetModel> filteredPets;
  final String selectedStatus;
  final String errorMessage;
  final int pageLimit;                
  final bool hasMore;    
  final bool isLoadingMore;             

  const PetState({
    this.status = PetStatus.initial,
    this.pets = const [],
    this.searchResults = const [],
    this.filteredPets = const [],
    this.selectedStatus = 'available',
    this.errorMessage = '',
    this.pageLimit = 10,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  PetState copyWith({
    PetStatus? status,
    List<PetModel>? pets,
    List<PetModel>? searchResults,
    List<PetModel>? filteredPets,
    String? selectedStatus,
    String? errorMessage,
    int? pageLimit,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PetState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      searchResults: searchResults ?? this.searchResults,
      filteredPets: filteredPets ?? this.filteredPets,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      pageLimit: pageLimit ?? this.pageLimit,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
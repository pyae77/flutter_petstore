abstract class PetEvent {
  const PetEvent();
}

class FetchPetsByStatusEvent extends PetEvent {
  final String status;
  const FetchPetsByStatusEvent(this.status);
}

class SearchPetByNameEvent extends PetEvent {
  final String query;
  const SearchPetByNameEvent(this.query);
}

class LoadMorePetsEvent extends PetEvent {
  const LoadMorePetsEvent();
}
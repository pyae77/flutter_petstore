abstract class FilterFruitEvent {

}
class SelectFruitEvent extends FilterFruitEvent{
   final List<String> fruits;

  SelectFruitEvent({required this.fruits});

}
class SelectAllFruitsEvent extends FilterFruitEvent{
  final List<String> fruits;

  SelectAllFruitsEvent({required this.fruits});

}
class ClearAllFruitsEvent extends FilterFruitEvent{

}
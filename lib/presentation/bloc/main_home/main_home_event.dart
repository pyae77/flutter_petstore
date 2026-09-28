abstract class MainHomeEvent {}

class TabChangedEvent extends MainHomeEvent {
  final int tabIndex;
  TabChangedEvent(this.tabIndex);
}
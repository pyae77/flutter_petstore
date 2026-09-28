import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingPageChangedEvent extends OnboardingEvent {
  final int pageIndex;

  const OnboardingPageChangedEvent(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}
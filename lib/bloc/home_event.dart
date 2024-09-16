part of "home_bloc.dart";

@immutable  
abstract class HomeEvent {}

class GenerateButtonClickedEvent extends HomeEvent{
  final String text;

  GenerateButtonClickedEvent({required this.text});
}

class RegenerateButtonClickedEvent extends HomeEvent{}
part of "home_bloc.dart";

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {
  final TextEditingController textEditingController = TextEditingController();
  HomeInitialState();
}

class HomeSuccessState extends HomeState {
  final AudioPlayer audioPlayer = AudioPlayer();
  final bool isPlaying = false;
  final Uint8List audioBytes;
  final String storyText;
  HomeSuccessState({required this.audioBytes,required this.storyText});
}

class HomeErrorState extends HomeState {
  final String text;
  HomeErrorState({required this.text});
}

class HomeLoadingState extends HomeState {}

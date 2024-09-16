import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:storyweb/svcs/tts_svc.dart';
import 'package:storyweb/utils/gemini_model.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<GenerateButtonClickedEvent>(generateButtonClickedEvent);
    on<RegenerateButtonClickedEvent>(regenerateButtonClickedEvent);
  }

  void regenerateButtonClickedEvent(event, emit) {
    emit(HomeInitialState());
  }

  void generateButtonClickedEvent(event, emit) async {
    try {
      emit(HomeLoadingState());
      GenerativeModel model = GeminiModelSingleton.getModel();
      final prompt = [
        Content.text(
            "Write a story revolving around the given idea -> ${event.text} the story should be ranging from 100-500 words give me resposne back in plain string and also dont use any new line character and fancy stuff just some delimeters like , . ! are  allowed and also the story shoould not be more than 500 words at any cost")
      ];
      final response = await model.generateContent(prompt);
      Uint8List audioBytes = await TTSSvc().convertTextToSpeech(response.text!);
      emit(HomeSuccessState(audioBytes: audioBytes, storyText: response.text!));
    } catch (e) {
      debugPrint(e.toString());
      emit(HomeErrorState(text: event.text));
    }
  }
}

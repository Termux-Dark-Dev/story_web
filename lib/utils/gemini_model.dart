import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:storyweb/utils/env_loader.dart';



class GeminiModelSingleton {
  static GenerativeModel? _model;

  GeminiModelSingleton._();

  static GenerativeModel getModel() {
    _model ??= GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: Env.geminiApiKey);

    return _model!;
  }
}

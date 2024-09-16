import "dart:typed_data";
import "package:http/http.dart" as http;
import "package:storyweb/utils/env_loader.dart";


class TTSSvc {
  Future<Uint8List> convertTextToSpeech(String incomingtext) async {
    const String apiUrl = 'https://api.voicerss.org/';
    String apiKey = Env.voicerssApiKey;
    const String language = 'en-us';
    const String codec = 'mp3';
    const String format = '48khz_16bit_stereo';
    const String rate = '0';
    Uint8List? audioBytes;

    // Prepare the request body with necessary parameters
    Map<String, String> requestBody = {
      'key': apiKey,
      'hl': language,
      'src': incomingtext, // Pass text directly here
      'c': codec,
      'f': format,
      'rate': rate,
    };

    try {
      final response = await http.post(Uri.parse(apiUrl), body: requestBody);
      if (response.statusCode == 200) {
        audioBytes = response.bodyBytes;
        return audioBytes;
      } else {
        throw Exception("Error fetching audio: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception caught: $e");
    }
  }
}

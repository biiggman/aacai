import 'package:aacademic/main.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static speak(String text) async {
    final FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage(currentLanguage);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.speak(text);
  }
}

class TextToSpeechSentence {
  static speak(String text) async {
    final FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage(currentLanguage);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }
}

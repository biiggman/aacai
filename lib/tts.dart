import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';

  
class TextToSpeech extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();
  static const routeName = '/tts';


  final TextEditingController textEditingController = TextEditingController();

  speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);

  }


  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: textEditingController,
            ),
            ElevatedButton(
              child:Text("Start Text To Speech") ,
              onPressed: () =>speak(textEditingController.text),
            )
          ], //<Widget>[]
        ), //Column
      ),//Padding
    );
  }
}
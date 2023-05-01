import 'package:aacademic/utils/tts.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final List<RawMaterialButton> buttons;
  final List<String> buttonsName;

  const CustomAppBar(
      {super.key,
      required this.height,
      required this.buttons,
      required this.buttonsName});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  //speaks list as a sentence
  void _speakSentence() {
    setState(() {
      String sentence = widget.buttonsName.join(', ');
      TextToSpeechSentence.speak(sentence);
    });
  }

  //removes newest entry in list
  void _backspace() {
    if (widget.buttons.isEmpty) {
      null;
    } else {
      setState(() {
        widget.buttons.length = widget.buttons.length - 1;
        widget.buttonsName.length = widget.buttonsName.length - 1;
      });
    }
  }

  //clears list
  void _clearList() {
    setState(() {
      widget.buttons.clear();
      widget.buttonsName.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: widget.buttons.isNotEmpty
      //icons only appear when a button is selected
          ? <Widget>[
              IconButton(
                onPressed: _speakSentence,
                icon: const Icon(Icons.play_arrow_rounded),
                color: Colors.black,
              ),
              IconButton(
                onPressed: _backspace,
                icon: const Icon(Icons.backspace),
                color: Colors.black,
              ),
              IconButton(
                onPressed: _clearList,
                icon: const Icon(Icons.clear),
                color: Colors.black,
              ),
            ]
          : null,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var button in widget.buttons)
              IconButton(
                icon: button.child!,
                color: Colors.white,
                constraints: const BoxConstraints(minWidth: 75, minHeight: 75),
                onPressed: () {},
              ),
          ],
        ),
      ),
    );
  }
}

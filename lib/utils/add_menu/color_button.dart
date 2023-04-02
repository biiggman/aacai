import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorButton extends StatefulWidget {
  final Color color;

  final Function(Color) onColorSelected;

  const ColorButton(
      {super.key, required this.color, required this.onColorSelected});

  @override
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  Color? _color;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Pick a Color"),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: _color ?? Colors.white,
                  onColorChanged: (color) {
                    setState(() {
                      _color = color;
                    });
                    widget.onColorSelected(color);
                  },
                ),
              ),
            );
          },
        );
      }, child: const Text("Choose a Color"),
    );
  }
}

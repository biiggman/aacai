import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ColorButton extends StatefulWidget {
  final Color color;

  final Function(Color) onColorSelected;

  const ColorButton(
      {super.key, required this.color, required this.onColorSelected});

  @override
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  bool _isSelected = false;

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
    });

    if (_isSelected) {
      widget.onColorSelected(widget.color);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: _toggleSelection,
      fillColor: widget.color,
      shape: CircleBorder(
        side: BorderSide(
          color: _isSelected ? Colors.black : Colors.transparent,
          width: 2,
        ) 
      )
    );
  }
}

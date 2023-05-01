import 'package:aacademic/utils/UI_templates.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorButton extends StatefulWidget {
  final Color color;

  final Function(Color) onColorSelected;

  //color button widget requires a color
  const ColorButton(
      {super.key, required this.color, required this.onColorSelected});

  @override
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  Color? _color;

  //sets variable color to whatever color the widget is
  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text("color_button_title".tr(), textAlign: TextAlign.center),
              titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purple),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: _color ?? Colors.white,
                  onColorChanged: (color) {
                    setState(() {
                      _color = color;
                    });
                    widget.onColorSelected(color);
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        );
      },
      child: buttonDeco(
          displayText: 'color_button_deco_displaytext'.tr(), vertInset: 10),
    );
  }
}

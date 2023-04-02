import 'dart:io';
import 'package:flutter/material.dart';

class PreviewButton extends StatefulWidget {
  final Color previewColor;
  final File? selectedImage;

  const PreviewButton(
      {super.key, required this.previewColor, required this.selectedImage});

  @override
  _PreviewButtonState createState() => _PreviewButtonState();
}

class _PreviewButtonState extends State<PreviewButton> {
  @override
  Widget build(BuildContext context) {
    final previewColor = widget.previewColor;
    return RawMaterialButton(
      onPressed: () {},
      shape: RoundedRectangleBorder(
          side: BorderSide(color: previewColor, width: 2),
          borderRadius: BorderRadius.circular(18)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: widget.selectedImage != null
          ? Image.file(widget.selectedImage!,
          fit: BoxFit.contain)
          : const SizedBox(),
      )
    );
  }
}

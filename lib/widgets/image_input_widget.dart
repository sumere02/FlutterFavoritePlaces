import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";
import "dart:io";

class ImageInputWidget extends StatefulWidget {
  const ImageInputWidget({required this.setImage,super.key});
  final void Function(File) setImage;

  @override
  State<ImageInputWidget> createState() {
    return _ImageInputWidget();
  }
}

class _ImageInputWidget extends State<ImageInputWidget> {
  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.setImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: const Icon(
        Icons.camera_alt,
      ),
      label: const Text(
        "Take Picture",
      ),
      onPressed: _takePicture,
    );
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: content,
    );
  }
}

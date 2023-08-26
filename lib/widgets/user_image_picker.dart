import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onImageSelect});

  final void Function(File image) onImageSelect;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
      widget.onImageSelect(_pickedImageFile!);
    });
  }

  void _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
      widget.onImageSelect(_pickedImageFile!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _pickImageFromCamera,
              icon: const Icon(Icons.camera),
              label: Text(
                'Take a pic',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            TextButton.icon(
              onPressed: _pickImageFromGallery,
              icon: const Icon(Icons.image),
              label: Text(
                'Select image',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        )
      ],
    );
  }
}

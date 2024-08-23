import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tymesavingfrontend/common/styles/app_padding.dart';
import 'package:tymesavingfrontend/components/common/button/primary_button.dart';
import 'package:tymesavingfrontend/components/common/button/secondary_button.dart';
import 'package:tymesavingfrontend/components/common/heading.dart';
import 'package:tymesavingfrontend/utils/display_error.dart';

class ImageUploadPage extends StatefulWidget {
  final String title;
  final void Function(BuildContext, String) confirmFunction;

  const ImageUploadPage(
      {super.key,
      this.title = 'Image Upload Page',
      required this.confirmFunction});

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (!mounted) return;
      setState(() {
        _image = pickedFile;
      });
    } catch (e) {
      ErrorDisplay.showErrorToast("Error picking image $e", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: Heading(title: widget.title),
      body: SingleChildScrollView(
        padding: AppPaddingStyles.pagePaddingIncludeSubText,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DottedBorder(
              dashPattern: const [6, 6, 6, 6],
              color: colorScheme.onBackground,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              radius: const Radius.circular(30),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _image == null
                      ? const Center(
                          child: Text('No image selected'),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.file(File(_image!.path)),
                        )),
            ),
            const SizedBox(height: 30),
            if (_image != null)
              PrimaryButton(
                onPressed: () {
                  // upload image to server
                  widget.confirmFunction(context, _image!.path);
                },
                title: 'Confirm Image Upload',
              ),
            const SizedBox(height: 30),
            Text("Choose option to upload image",
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 30),
            PrimaryButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              title: 'Pick Image from Gallery',
            ),
            const SizedBox(height: 30),
            SecondaryButton(
              onPressed: () => _pickImage(ImageSource.camera),
              title: 'Take a Photo',
            ),
          ],
        ),
      ),
    );
  }
}

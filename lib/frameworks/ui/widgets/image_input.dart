import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_chat/common/helpers/image_helper.dart';
import 'package:firebase_chat/frameworks/ui/widgets/utility/show_dialogs.dart';

/// Provides picking an image from the [source] (the camera or the gallery) and save it
/// in the [appDir] directory
class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  const ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> with ShowDialogs {
  // ignore: unused_field
  static const String mainTag = '## ImageInput';
  File? _storedImage; // where it stored after picking from the source
  File? _savedImage; // where it saved in the [appDir] directory

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Row(children: [
      Container(
        height: 100,
        width: deviceSize.width * 0.4,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        alignment: Alignment.center,
        child: _savedImage != null
            ? Image.file(
                _savedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : const Text(
                'Not Image Taken',
                textAlign: TextAlign.center,
              ),
      ),
      Expanded(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextButton.icon(
                icon:const  Icon(Icons.camera),
                label: Text(
                  'Take Picture from Camera',
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => _pickImage(), //from Camera
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                icon: const Icon(Icons.collections),
                label: Text(
                  'Take Picture from Gallery',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => _pickImage(source: 'gallery'), // from Gallery
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  /// The method pick an image from the [source] and save it
  /// in the [appDir] directory
  Future<void> _pickImage({String source = 'camera'}) async {
    try {
      _storedImage = await ImageHelper.selectImage(imgSource: source);
      if (_storedImage == null) {
        throw "An image didn't choose";
      }
      _savedImage = await ImageHelper.saveImage(_storedImage!);
      widget.onSelectImage(_savedImage); //callback was set in the calling side
    } on Exception catch (error) {
      showError(
        context,
        title: 'While the image was selecting and saving an error occured!',
        error: error as String,
      );
    } finally {
      setState(() {});
    }
  }
}

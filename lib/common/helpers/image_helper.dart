import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

// ignore: avoid_classes_with_only_static_members
class ImageHelper {
  static const String mainTag = '## ImageHelper';

  static Future<File> selectImage({String imgSource = 'camera'}) async {
    log('$mainTag selectImage() ENTRANCE');
    final picker = ImagePicker();
    ImageSource imageSource;

    switch (imgSource) {
      case 'camera':
        {
          imageSource = ImageSource.camera;
          break;
        }
      case 'gallery':
        {
          imageSource = ImageSource.gallery;
          break;
        }
      default:
        {
          imageSource = ImageSource.camera;
        }
    }
    try {
      final pickedFile = await picker.getImage(
        source: imageSource,
        maxWidth: 1400,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        throw 'Image was not picked';
      }
    } on Exception {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  static Future<File> saveImage(File storedImage) async {
    try {
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(storedImage.path);
      final savedImage = await storedImage.copy('${appDir.path}/$fileName');
      await storedImage.delete();
      return savedImage;
    } on Exception {
      rethrow;
    }
  }
}

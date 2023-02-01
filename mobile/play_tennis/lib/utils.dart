import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static Future<File?> pickMedia({
    required bool isGallery,
    required Future<File?> Function(File file)? cropImage,
  }) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) {
      return Future<File?>.value(null);
    }

    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);

      return cropImage(file);
    }
  }

  static Future<File?> cropSquareImage(File imageFile) async {
    var res = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square
        ],
        uiSettings: [
          iosUiSettings(),
          androidUiSettings(),
        ]);

    if (res == null) {
      return Future<File?>.value(null);
    }

    return File(res.path);
  }

  static IOSUiSettings iosUiSettings() {
    return IOSUiSettings(
      aspectRatioLockEnabled: false,
      title: "Обрезать изображение",
      cancelButtonTitle: "Отмена",
      doneButtonTitle: "Готово",
    );
  }

  static AndroidUiSettings androidUiSettings() {
    return AndroidUiSettings(toolbarTitle: "Обрезать изображение");
  }
}

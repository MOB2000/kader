import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  ImagePickerHelper._();

  static final ImagePickerHelper instance = ImagePickerHelper._();

  Future<File?> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }

    return null;
  }
}

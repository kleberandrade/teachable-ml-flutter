import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraHelper {
  static Future<File> pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }
    return image;
  }
}

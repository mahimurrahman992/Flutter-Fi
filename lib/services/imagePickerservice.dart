
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickImage() async {
    if (kIsWeb) {
      return _pickImageWeb();
    } else {
      return _pickImageMobile();
    }
  }

  Future<Uint8List?> _pickImageMobile() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image == null) return null;
      return await image.readAsBytes();
    } catch (e) {
      print('Mobile image picker error: $e');
      return null;
    }
  }

  Future<Uint8List?> _pickImageWeb() async {
    try {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      await uploadInput.onChange.first;
      if (uploadInput.files!.isEmpty) return null;
      
      final html.File file = uploadInput.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      
      await reader.onLoadEnd.first;
      return reader.result as Uint8List?;
    } catch (e) {
      print('Web image picker error: $e');
      return null;
    }
  }
}
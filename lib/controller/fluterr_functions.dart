import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FlutterFunctions extends ChangeNotifier {
  XFile? imageFile;

  List<XFile>? imageFileList = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> onImageButtonPress(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      imageFile = pickedFile;
      imageFileList!.add(pickedFile!);
      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }

  Future<void> addUserId(ImageSource source, {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      imageFileList!.add(pickedFile!);
      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }
}

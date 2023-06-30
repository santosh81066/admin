import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class FlutterFunctions extends ChangeNotifier {
  XFile? imageFile;
  DateTime? dateTime;
  String? date;
  String? time;
  TimeOfDay? selectedTime;
  List<XFile>? imageFileList = [];
  final ImagePicker _picker = ImagePicker();
  String _selectedValue = 'calling';
  String get selectedValue => _selectedValue;
  String? pdfFilePath;
  void setSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 30)))
        .then((value) {
      if (value == null) {
        return;
      }

      dateTime = value;
      date = DateFormat('dd/MM/yyyy').format(dateTime!).toString();

      print(date);
    });
    notifyListeners();
  }

  Future<void> selectTime(BuildContext context) async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      selectedTime = value;
      //time = DateFormat('HH:mm').format(selectedTime).toString();
    });
    // print(
    //     '${date} ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}');

    notifyListeners();
  }

  Future<void> onImageButtonPress(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: source, imageQuality: 30);
      imageFile = pickedFile;

      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }

  Future<void> addUserId(ImageSource source, {BuildContext? context}) async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: source, imageQuality: 30);
      imageFileList!.add(pickedFile!);
      notifyListeners();
    } catch (e) {
      print("$e");
    }
  }

  Future<void> pickPDFFileFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      pdfFilePath = result.files.single.path!;
    }

    print(pdfFilePath);
    notifyListeners();
  }
}

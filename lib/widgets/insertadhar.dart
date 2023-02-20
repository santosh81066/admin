import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:purohithulu_admin/widgets/text_widget.dart';

import '../controller/fluterr_functions.dart';

class InsertAdhar extends StatelessWidget {
  const InsertAdhar(
      {super.key,
      this.catergoryType,
      this.categoryName,
      this.buttonName,
      this.imageIcon,
      this.handlerone,
      this.insertCategory,
      this.label,
      this.index});
  final TextEditingController? catergoryType;
  final String? categoryName;
  final String? buttonName;
  final String? label;
  final Function? imageIcon;
  final Function? handlerone;
  final Function? insertCategory;
  final int? index;
  @override
  Widget build(BuildContext context) {
    var flutterFunctions = Provider.of<FlutterFunctions>(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(5.0),
              child: TextWidget(
                controller: catergoryType!,
                hintText: categoryName,
              ),
            )),
            flutterFunctions.imageFileList!.isNotEmpty
                ? SizedBox(
                    width: 30,
                    child: Image.file(
                        File(flutterFunctions.imageFileList![index!].path)))
                : TextButton.icon(
                    onPressed: () {
                      imageIcon!();
                    },
                    icon: const Icon(Icons.image),
                    label: Text(label!)),
            flutterFunctions.imageFileList!.isNotEmpty
                ? TextButton(
                    onPressed: () {
                      imageIcon!();
                    },
                    child: const Text("Change Icon"))
                : Container()
          ],
        ),
      ],
    );
  }
}

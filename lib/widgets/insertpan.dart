import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:purohithulu_admin/widgets/text_widget.dart';

import '../controller/fluterr_functions.dart';

class InsertPan extends StatelessWidget {
  const InsertPan(
      {super.key,
      this.panType,
      this.panName,
      this.buttonName,
      this.imageIcon,
      this.handlerone,
      this.insertCategory,
      this.label,
      this.index});
  final TextEditingController? panType;
  final String? panName;
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
                controller: panType!,
                hintText: panName,
              ),
            )),
            flutterFunctions.imageFileList!.length == 2
                ? Container(
                    width: 30,
                    child: Image.file(
                        File(flutterFunctions.imageFileList![index!].path)))
                : TextButton.icon(
                    onPressed: () {
                      imageIcon!();
                    },
                    icon: Icon(Icons.image),
                    label: Text(label!)),
            flutterFunctions.imageFileList!.length == 2
                ? TextButton(
                    onPressed: () {
                      imageIcon!();
                    },
                    child: Text("Change Icon"))
                : Container()
          ],
        ),
      ],
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:animated_switch/animated_switch.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:purohithulu_admin/controller/fluterr_functions.dart';
import 'package:purohithulu_admin/widgets/button.dart';
import 'package:purohithulu_admin/widgets/text_widget.dart';
import 'package:purohithulu_admin/controller/apicalls.dart';

class InsertCategory extends StatelessWidget {
  const InsertCategory(
      {super.key,
      this.catergoryType,
      this.categoryName,
      this.buttonName,
      this.categories,
      this.imageIcon,
      this.handlerone,
      this.scaffoldMessengerKey,
      this.parentid});
  final TextEditingController? catergoryType;
  final String? categoryName;
  final String? buttonName;
  final StreamController? categories;
  final Function? imageIcon;
  final Function? handlerone;
  final String? parentid;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState scaffoldKey =
        scaffoldMessengerKey!.currentState as ScaffoldMessengerState;
    var flutterFunctions = Provider.of<FlutterFunctions>(context);
    var apicalls = Provider.of<ApiCalls>(context);
    String newparentid = '';
    if (parentid != null) {
      newparentid = parentid!;
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(5.0),
          child: TextWidget(
            controller: catergoryType!,
            hintText: categoryName,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            flutterFunctions.imageFile != null
                ? SizedBox(
                    width: 30,
                    child: Image.file(File(flutterFunctions.imageFile!.path)))
                : TextButton.icon(
                    onPressed: () {
                      imageIcon!();
                    },
                    icon: Icon(Icons.image),
                    label: Text("Select Category Icon")),
            flutterFunctions.imageFile != null
                ? TextButton(
                    onPressed: () {
                      imageIcon!();
                    },
                    child: Text("Change Icon"))
                : Container(),
            DropdownButton<String>(
              value: context.watch<FlutterFunctions>().selectedValue,
              onChanged: (String? newValue) {
                context.read<FlutterFunctions>().setSelectedValue(newValue!);
              },
              items: <String>['calling', 'booking', 'events']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        Consumer<ApiCalls>(
          builder: (context, value, child) {
            return value.isloading
                ? CircularProgressIndicator()
                : Button(
                    onTap: () async {
                      await value
                          .insertCategory(catergoryType!.text.trim(), context,
                              newparentid, flutterFunctions.selectedValue)
                          .then((value) => scaffoldKey.showSnackBar(SnackBar(
                                content: Text('${apicalls.messages}'),
                                duration: Duration(seconds: 5),
                              )));
                      Future.delayed(Duration.zero).then((val) {
                        return value.getCatogories(context);
                      });
                    },
                    buttonname: buttonName,
                  );
          },
        )
      ],
    );
  }
}

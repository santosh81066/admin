import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/widgets/text_widget.dart';

import '../controller/apicalls.dart';
import '../controller/fluterr_functions.dart';
import 'button.dart';
import 'insertadhar.dart';
import 'insertpan.dart';

class AddUser extends StatelessWidget {
  const AddUser(
      {Key? key,
      this.mobileNo,
      this.userName,
      this.languages,
      this.adhar,
      this.adharId,
      this.languagesHint,
      this.mobileHint,
      this.userNameHint,
      this.pan,
      this.panId,
      this.buttonName,
      this.scaffoldMessengerKey})
      : super(key: key);
  final TextEditingController? mobileNo;
  final TextEditingController? userName;
  final TextEditingController? languages;
  final TextEditingController? adhar;
  final TextEditingController? pan;
  final String? panId;
  final String? adharId;
  final String? mobileHint;
  final String? userNameHint;
  final String? languagesHint;
  final String? buttonName;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState scaffoldKey =
        scaffoldMessengerKey!.currentState as ScaffoldMessengerState;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextWidget(controller: mobileNo!, hintText: mobileHint!),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextWidget(controller: userName!, hintText: userNameHint),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextWidget(controller: languages!, hintText: languagesHint),
        ),
        InsertAdhar(
          adharName: adharId,
          adharType: adhar,
          imageIcon: () {
            Provider.of<FlutterFunctions>(context, listen: false)
                .addUserId(ImageSource.gallery);
          },
          label: 'select adhar image',
          index: 0,
        ),
        InsertPan(
          panName: panId,
          panType: pan,
          imageIcon: () {
            Provider.of<FlutterFunctions>(context, listen: false)
                .addUserId(ImageSource.gallery);
          },
          label: 'select pan image',
          index: 1,
        ),
        const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Please select your services below')),
        Consumer<ApiCalls>(
          builder: (context, value, child) {
            return ListView.builder(
              physics: const ScrollPhysics(parent: null),
              shrinkWrap: true,
              itemBuilder: (cont, index) {
                return CheckboxListTile(
                  value: value.selected_box.contains(index),
                  onChanged: (val) {
                    // print(val);
                    value.selectedCat(value.categories[index]['id']);
                    value.updateId(index);
                  },
                  title: Text(value.categories[index]['title']),
                );
              },
              itemCount: value.categories.length,
            );
          },
        ),
        Consumer<ApiCalls>(
          builder: (context, value, child) {
            return value.isloading == true
                ? const CircularProgressIndicator(
                    backgroundColor: Colors.yellow,
                  )
                : Button(
                    onTap: () async {
                      value
                          .register(
                              mobileNo!.text.trim(),
                              userName!.text.trim(),
                              adhar!.text.trim(),
                              pan!.text.trim(),
                              languages!.text.trim(),
                              context)
                          .then((response) {
                        switch (response) {
                          case 400:
                            scaffoldKey.showSnackBar(SnackBar(
                              content: Text('${value.messages}'),
                              duration: Duration(seconds: 5),
                            ));
                            Navigator.pop(context);
                            break;
                          case 201:
                            scaffoldKey.showSnackBar(SnackBar(
                              content: Text('${value.messages}'),
                              duration: Duration(seconds: 5),
                            ));
                            Navigator.pop(context);
                            break;
                        }
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

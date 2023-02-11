import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/controller/apicalls.dart';
import 'package:purohithulu_admin/widgets/app_drawer.dart';
import 'package:purohithulu_admin/widgets/text_widget.dart';

import '../controller/auth.dart';
import '../widgets/button.dart';

class Location extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  const Location({super.key, this.scaffoldMessengerKey});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  void initState() {
    Provider.of<ApiCalls>(context, listen: false).getLocation(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController locationctrl = TextEditingController();
    final ScaffoldMessengerState scaffoldKey =
        widget.scaffoldMessengerKey!.currentState as ScaffoldMessengerState;
    String locationhint = 'please enter location';
    String button = 'Add Location';
    String deleteButton = 'Delete Location';
    return Scaffold(
      appBar: AppBar(),
      drawer: const AppDrawer(),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(controller: locationctrl, hintText: locationhint),
            Consumer<ApiCalls>(
              builder: (context, value, child) {
                return value.isloading == true && button == 'Add Location'
                    ? const CircularProgressIndicator()
                    : Button(
                        buttonname: button,
                        onTap: value.isloading == true
                            ? null
                            : () async {
                                await value.insertLocation(
                                    context, locationctrl.text.trim());
                                if (scaffoldKey != null) {
                                  scaffoldKey.showSnackBar(SnackBar(
                                    content: Text(value.messages!),
                                    duration: Duration(seconds: 5),
                                  ));
                                }
                                // value
                                //     .adminLogin(controller.text.trim(),
                                //         password.text.trim())
                                //     .then((response) {
                                //   print(value.messages);
                                //   switch (response) {
                                //     case 401:
                                //       scaffoldKey.showSnackBar(SnackBar(
                                //         content: Text('${value.messages}'),
                                //         duration: Duration(seconds: 5),
                                //       ));
                                //       break;
                                //     case 201:
                                //       scaffoldKey.showSnackBar(SnackBar(
                                //         content: Text('${value.messages}'),
                                //         duration: Duration(seconds: 5),
                                //       ));
                                //   }
                                // });
                              },
                      );
              },
            ),
            Consumer<ApiCalls>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    DropdownButton<String>(
                      elevation: 16,
                      isExpanded: true,
                      hint: Text('please select location'),
                      items: value.location == null
                          ? []
                          : value.location!.data.map((v) {
                              return DropdownMenuItem<String>(
                                  onTap: () {
                                    value.locationId = v.id;
                                  },
                                  value: v.location,
                                  child: Text(v.location));
                            }).toList(),
                      onChanged: (val) {
                        //print(cat.text);
                        value.sub = val;
                        value.notifyListeners();
                        print(value.sub);
                      },
                      value: value.sub,
                    ),
                    value.isloading2 == true
                        ? const CircularProgressIndicator()
                        : Button(
                            buttonname: deleteButton,
                            onTap: value.isloading2 == true
                                ? null
                                : () async {
                                    await value.deletelocation(context);
                                    value.location!.data.removeWhere(
                                      (v) => v.id == value.locationId,
                                    );
                                    value.sub = null;
                                    if (scaffoldKey != null) {
                                      scaffoldKey.showSnackBar(SnackBar(
                                        content: Text(value.messages!),
                                        duration: Duration(seconds: 5),
                                      ));
                                    }
                                  },
                          )
                  ],
                );
              },
            )
          ],
        ),
      )),
    );
  }
}

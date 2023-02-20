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
                              },
                      );
              },
            ),
          ],
        ),
      )),
    );
  }
}

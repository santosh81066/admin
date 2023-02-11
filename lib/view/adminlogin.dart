import 'package:flutter/material.dart';
import '../controller/auth.dart';
import '../widgets/text_widget.dart';
import '../widgets/button.dart';
import 'package:provider/provider.dart';

class Adminlogin extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  const Adminlogin({super.key, this.scaffoldMessengerKey});

  @override
  State<Adminlogin> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Adminlogin> {
  TextEditingController controller = TextEditingController();
  TextEditingController password = TextEditingController();

  String button = 'Login';
  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState scaffoldKey =
        widget.scaffoldMessengerKey!.currentState as ScaffoldMessengerState;
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 50, color: Colors.blueAccent),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: TextWidget(
                      hintText: 'Please Enter Your controller',
                      controller: controller),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: TextWidget(
                    hintText: 'Please Enter Your Password',
                    controller: password,
                    ofsecuretext: true,
                  ),
                )
              ],
            ),
          ),
          Consumer<Auth>(
            builder: (context, value, child) {
              return value.isloading == true
                  ? const CircularProgressIndicator()
                  : Button(
                      buttonname: button,
                      onTap: value.isloading == true
                          ? null
                          : () {
                              value
                                  .adminLogin(controller.text.trim(),
                                      password.text.trim())
                                  .then((response) {
                                print(value.messages);
                                switch (response) {
                                  case 401:
                                    scaffoldKey.showSnackBar(SnackBar(
                                      content: Text('${value.messages}'),
                                      duration: Duration(seconds: 5),
                                    ));
                                    break;
                                  case 201:
                                    scaffoldKey.showSnackBar(SnackBar(
                                      content: Text('${value.messages}'),
                                      duration: Duration(seconds: 5),
                                    ));
                                }
                              });
                            },
                    );
            },
          )
        ],
      )),
    );
  }
}

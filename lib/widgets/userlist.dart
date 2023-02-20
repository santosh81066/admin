import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:animated_switch/animated_switch.dart';
import '../controller/apicalls.dart';

class UserList extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final int? userid;
  final int? status;
  const UserList(
      {super.key, this.userid, this.status, this.scaffoldMessengerKey});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState scaffoldKey =
        widget.scaffoldMessengerKey!.currentState as ScaffoldMessengerState;
    var apiCalls = Provider.of<ApiCalls>(context, listen: false);
    return AnimatedSwitch(
      value: widget.status == 0 ? false : true,
      onChanged: (bool state) {
        if (isSwitched) {
          print(state);
          apiCalls.toggleAorD(widget.userid!, context, state).then((response) {
            print(response);
            switch (response) {
              case 400:
                scaffoldKey.showSnackBar(SnackBar(
                  content: Text('${apiCalls.messages}'),
                  duration: Duration(seconds: 5),
                ));
                break;
              case 201:
                scaffoldKey.showSnackBar(SnackBar(
                  content: Text('${apiCalls.messages}'),
                  duration: Duration(seconds: 5),
                ));
            }
          });
          apiCalls.getUsers(context);
        } else {
          isSwitched = true;
        }
        //print(apiCalls.messages);
      },
      width: MediaQuery.of(context).size.width * 1 / 4,
      textOn: "Activated",
      textOff: "Deactivated",
      textStyle: TextStyle(color: Colors.white, fontSize: 20),
    );
  }
}

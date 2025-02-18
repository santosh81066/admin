import 'package:flutter/material.dart';
import 'package:purohithulu_admin/widgets/app_drawer.dart';

import '../widgets/adduser.dart';

class Register extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  const Register({super.key, this.scaffoldMessengerKey});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController mobileNo = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController languages = TextEditingController();
  TextEditingController adhar = TextEditingController();
  TextEditingController pan = TextEditingController();
  TextEditingController expirience = TextEditingController();
  List<TextEditingController> price = [];
  String adharId = 'Enter image name';
  String languagesHint = 'known languages of user';
  String mobileHint = 'Enter user mobile no';
  String userNameHint = 'Enter user name';

  String panId = 'Enter image name';
  String buttonName = 'Add user';
  @override
  void dispose() {
    mobileNo.dispose();
    userName.dispose();
    languages.dispose();
    adhar.dispose();
    pan.dispose();
    expirience.dispose();
    for (var controller in price) {
      controller.dispose();
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const AppDrawer(),
      body: AddUser(
        mobileNo: mobileNo,
        userName: userName,
        languages: languages,
        adhar: adhar,
        profilepic: pan,
        mobileHint: mobileHint,
        userNameHint: userNameHint,
        languagesHint: languagesHint,
        adharId: adharId,
        description: expirience,
        panId: panId,
        buttonName: buttonName,
        scaffoldMessengerKey: widget.scaffoldMessengerKey,
      ),
    );
  }
}

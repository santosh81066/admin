import 'package:flutter/material.dart';
import 'package:purohithulu_admin/widgets/app_drawer.dart';

import '../widgets/adduser.dart';

class Register extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  const Register({super.key, this.scaffoldMessengerKey});

  @override
  Widget build(BuildContext context) {
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
        scaffoldMessengerKey: scaffoldMessengerKey,
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/widgets/button.dart';
import 'package:purohithulu_admin/widgets/insertcategory.dart';
import 'package:purohithulu_admin/widgets/text_widget.dart';
import 'package:purohithulu_admin/controller/fluterr_functions.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/apicalls.dart';
import '../widgets/app_drawer.dart';
import '../widgets/createpackage.dart';

class Welcomescreen extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  const Welcomescreen({super.key, this.scaffoldMessengerKey});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  TextEditingController price = TextEditingController();
  TextEditingController noOfMinutes = TextEditingController();
  TextEditingController packageName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController address = TextEditingController();
  String amt = 'please enter amount';
  String viewButtonName = 'View Events';
  String savePackageButton = 'Save Event';

  String noOfMin = 'Date And Time';
  String hintPname = 'please enter Event name';
  bool isinit = true;

  @override
  void didChangeDependencies() {
    if (isinit) {
      Provider.of<ApiCalls>(context, listen: false).getCatogories(context);
    }
    isinit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var apiCalls = Provider.of<ApiCalls>(context, listen: false);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreatePackage(
              price: price,
              amt: amt,
              button: savePackageButton,
              viewButton: viewButtonName,
              packageName: packageName,
              hintPname: hintPname,
              address: address,
              description: description,
            ),
          ],
        ),
      ),
    );
  }
}

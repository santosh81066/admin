import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/model/expansionitem.dart';
import 'package:purohithulu_admin/widgets/app_drawer.dart';
import 'package:purohithulu_admin/widgets/userlist.dart';

import '../controller/apicalls.dart';
import '../utlis/purohitapi.dart';

import '../widgets/adduser.dart';
import '../widgets/button.dart';
import '../widgets/text_widget.dart';

class Users extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  const Users({super.key, this.scaffoldMessengerKey});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  bool isopen = false;
  List<TextEditingController> _adhar = [];
  List<TextEditingController> _pan = [];

  String saveButton = 'Save';
  bool isSwitched = false;
  var textValue = 'Switch is OFF';
  TextEditingController mobileNo = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController languages = TextEditingController();
  TextEditingController adhar = TextEditingController();
  TextEditingController pan = TextEditingController();
  String adharId = 'Mobile No_adhar';
  String languagesHint = 'known languages of user';
  String mobileHint = 'Enter user mobile no';
  String userNameHint = 'Enter user name';

  String panId = 'Enter user pan';
  String buttonName = 'Add user';
  @override
  void initState() {
    Provider.of<ApiCalls>(context, listen: false).getUsers(context);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Add user'),
                    content: SingleChildScrollView(
                      child: Container(
                        width: double.maxFinite,
                        child: AddUser(
                          mobileNo: mobileNo,
                          userName: userName,
                          languages: languages,
                          adhar: adhar,
                          pan: pan,
                          mobileHint: mobileHint,
                          userNameHint: userNameHint,
                          languagesHint: languagesHint,
                          adharId: adharId,
                          panId: panId,
                          buttonName: buttonName,
                          scaffoldMessengerKey: widget.scaffoldMessengerKey,
                        ),
                      ),
                    ),
                  );
                },
              );
              //Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Consumer<ApiCalls>(
        builder: (con, value, child) {
          return ListView.builder(
            itemCount: value.users!.length,
            itemBuilder: (cont, index) {
              _adhar.add(
                  TextEditingController(text: value.users![index]['adharno']));
              _pan.add(
                  TextEditingController(text: value.users![index]['panno']));
              return ExpansionTile(
                title: Text(value.users![index]['username'].toString()),
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            // width: 30,
                            child: UserList(
                                scaffoldMessengerKey:
                                    widget.scaffoldMessengerKey,
                                userid: value.users![index]['id'],
                                status: value.users![index]['userstatus']),
                          ),
                        ],
                      ),
                      Center(
                        child: InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(20.0),
                          minScale: 0.1,
                          maxScale: 5,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 1 / 5,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                                "${PurohitApi().baseUrl}${PurohitApi().userIdCard}${value.users![index]['adhar']}${PurohitApi().userid}${value.users![index]['id']}",
                                headers: {"Authorization": value.token!}),
                          ),
                        ),
                      ),
                      const Divider(),
                      Center(
                        child: InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(20.0),
                          minScale: 0.1,
                          maxScale: 5,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 1 / 5,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                                "${PurohitApi().baseUrl}${PurohitApi().userIdCard}${value.users![index]['profilepic']}${PurohitApi().userid}${value.users![index]['id']}",
                                headers: {"Authorization": value.token!}),
                          ),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TextWidget(
                          //initialvalue: value.users![index]['adharno']==null?'pan is required': value.users![index]['panno'],
                          hintText: 'Please Enter adhar',
                          controller: _adhar[index],
                        ),
                      ),
                      const Divider(),
                      Button(
                        buttonname: saveButton,
                        fontSize: 15,
                        onTap: () {
                          print('button pressed');
                          value.updateUser(
                              value.users![index]['id'],
                              con,
                              _adhar[index].text.trim(),
                              _pan[index].text.trim());
                        },
                      ),
                    ],
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

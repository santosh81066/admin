import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/controller/auth.dart';

import 'package:purohithulu_admin/model/user_details.dart';
import 'package:purohithulu_admin/widgets/app_drawer.dart';
import 'package:purohithulu_admin/widgets/userlist.dart';

import '../controller/apicalls.dart';

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
  TextEditingController searchController = TextEditingController(text: '');

  String saveButton = 'Save';
  bool isSwitched = false;
  var textValue = 'Switch is OFF';
  @override
  void dispose() {
    for (final controller in _adhar) {
      controller.dispose();
    }
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
        Provider.of<ApiCalls>(context, listen: false).getUsers(context));

    Provider.of<ApiCalls>(context, listen: false).getCatogories(context);
    Provider.of<ApiCalls>(context, listen: false).getLocation(context);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context, listen: false);
    var apicalls = Provider.of<ApiCalls>(context);
    List<Data>? filteredUsers;
    // if (apicalls.userDetails != null) {
    //   filteredUsers = apicalls.userDetails!.data!.where((user) {
    //     final name = user.username?.toLowerCase() ?? '';
    //     final mobile = user.mobileno?.toString().toLowerCase() ?? '';
    //     final role = user.role?.toLowerCase() ?? '';
    //     final selectUser = apicalls.selectUser?.toLowerCase() ?? '';
    //     final selectName = apicalls.selectName?.toLowerCase() ?? '';
    //     if (role.trim().startsWith(selectUser) && role == name) {
    //       print(
    //           'selectUser: $selectUser, role: $role, name: $name, mobile: $mobile');
    //       return true;
    //     }
    //     return false;
    //   }).toList();
    // }
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              onChanged: (value) {
                apicalls.onSelectName(value);
                print(apicalls.selectName);
              },
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by mobile number',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              ),
            ),
          ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'u',
                  child: Text('User'),
                ),
                PopupMenuItem(
                  value: 'p',
                  child: Text('Purohith'),
                ),
                // add more items as needed
              ];
            },
            onSelected: (String users) {
              apicalls.selectUsers(users);
              print(apicalls.selectUser);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('registerUser');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: apicalls.userDetails != null && apicalls.userDetails!.data != null
          ? Consumer<ApiCalls>(
              builder: (con, value, child) {
                return ListView.builder(
                  itemCount: value.userDetails!.data!.length,
                  itemBuilder: (cont, index) {
                    _adhar.add(TextEditingController(
                        text: apicalls.userDetails!.data![index].adharno));

                    try {
                      if (apicalls.selectUser != null) {
                        final role = apicalls.userDetails!.data![index].role;

                        if ((apicalls.selectUser != role)) {
                          return Container();
                        }
                      }
                      if (apicalls.selectName != null) {
                        final username = apicalls
                                .userDetails!.data![index].username
                                ?.toLowerCase() ??
                            '';
                        final mobile = apicalls
                                .userDetails!.data![index].mobileno
                                ?.toString()
                                .toLowerCase() ??
                            '';
                        final adhar = apicalls.userDetails!.data![index].adharno
                                ?.toLowerCase() ??
                            '';
                        if (apicalls.selectName != null &&
                            !(username.contains(apicalls.selectName!) ||
                                mobile.contains(apicalls.selectName!) ||
                                adhar.contains(apicalls.selectName!))) {
                          return Container();
                        }
                      }

                      return ExpansionTile(
                        onExpansionChanged: (exp) {
                          if (exp) {
                            if (value.userDetails!.data![index].profiledp ==
                                null) {
                              value.getprofiledp(context, index);
                              if (value.userDetails!.data![index].adharpic ==
                                      null &&
                                  value.userDetails!.data![index].role == 'p') {
                                value.getadhardp(context, index);
                              }
                            }
                          }
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value.userDetails!.data![index].username
                                .toString()),
                            Text(value.userDetails!.data![index].mobileno
                                .toString()),
                          ],
                        ),
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
                                        userid: apicalls
                                            .userDetails!.data![index].id,
                                        status: apicalls.userDetails!
                                            .data![index].userstatus),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Text(value.userDetails!.data![index]
                                          .dateofbirth ==
                                      null
                                  ? ''
                                  : " Date of birth : ${value.userDetails!.data![index].dateofbirth!}"),
                              Text(value.userDetails!.data![index]
                                          .placeofbirth ==
                                      null
                                  ? ''
                                  : " Place of birth : ${value.userDetails!.data![index].placeofbirth}"),
                              value.isloading == true
                                  ? CircularProgressIndicator()
                                  : SizedBox(
                                      height: 200,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(8.0),
                                          ),
                                          image: DecorationImage(
                                            image: value
                                                        .userDetails!
                                                        .data![index]
                                                        .profiledp !=
                                                    null
                                                ? FileImage(File(value
                                                    .userDetails!
                                                    .data![index]
                                                    .profiledp!
                                                    .path))
                                                : Image.asset(
                                                        "assets/logo.jpeg")
                                                    .image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                              value.isloading == true
                                  ? const CircularProgressIndicator()
                                  : value.userDetails!.data![index].adharpic ==
                                          null
                                      ? Container()
                                      : Center(
                                          child: InteractiveViewer(
                                            boundaryMargin:
                                                const EdgeInsets.all(20.0),
                                            minScale: 0.1,
                                            maxScale: 5,
                                            child: SizedBox(
                                              height: 200,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(8.0),
                                                  ),
                                                  image: DecorationImage(
                                                    image: value
                                                                .userDetails!
                                                                .data![index]
                                                                .adharpic !=
                                                            null
                                                        ? FileImage(File(value
                                                            .userDetails!
                                                            .data![index]
                                                            .adharpic!
                                                            .path))
                                                        : Image.asset(
                                                                "assets/logo.jpeg")
                                                            .image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                              const Divider(),
                              value.userDetails!.data![index].role == 'p'
                                  ? Padding(
                                      padding: EdgeInsets.all(5),
                                      child: TextWidget(
                                        //initialvalue: value.users![index]['adharno']==null?'pan is required': value.users![index]['panno'],
                                        hintText: 'Please Enter adhar',
                                        controller: _adhar[index],
                                      ),
                                    )
                                  : Container(),
                              const Divider(),
                              Button(
                                buttonname: saveButton,
                                fontSize: 15,
                                onTap: () {
                                  print('button pressed');
                                  value.updateUser(
                                    value.userDetails!.data![index].id!,
                                    con,
                                    _adhar[index].text.trim(),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      );
                    } catch (e) {
                      if (e is SocketException && e.message.contains('401')) {
                        auth.restoreAccessToken();
                      }
                    }
                    return null;
                  },
                );
              },
            )
          : Container(
              child: Center(
              child: Text('No users to display'),
            )),
    );
  }
}

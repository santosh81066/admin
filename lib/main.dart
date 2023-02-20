import 'package:flutter/material.dart';
import 'package:purohithulu_admin/controller/auth.dart';
import 'package:purohithulu_admin/controller/fluterr_functions.dart';
import 'package:purohithulu_admin/model/categories.dart';
import 'package:purohithulu_admin/providers/category.dart';

import 'package:purohithulu_admin/view/adminlogin.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/view/catogories.dart';
import 'package:purohithulu_admin/view/editcat.dart';
import 'package:purohithulu_admin/view/location.dart';
import 'package:purohithulu_admin/view/registeruser.dart';
import 'package:purohithulu_admin/view/users.dart';
import 'package:purohithulu_admin/view/viewpackage.dart';
import 'package:purohithulu_admin/view/createPackage.dart';
import 'controller/apicalls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProvider(
            create: (context) => FlutterFunctions(),
          ),
          ChangeNotifierProxyProvider<Auth, Category>(
            create: (context) => Category(),
            update: (context, value, previous) {
              return previous!..update(value.accessToken!);
            },
          ),
          ChangeNotifierProxyProvider<Auth, ApiCalls>(
            create: (context) => ApiCalls(),
            update: (context, value, previous) {
              return previous!..update(value.accessToken!);
            },
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.red,
          ),
          home: Consumer<Auth>(builder: (context, value, _) {
            print("from material app");
            return value.isAuth
                ? Users(
                    scaffoldMessengerKey: scaffoldMessengerKey,
                  )
                : FutureBuilder(
                    future: value.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              )
                            : Adminlogin(
                                scaffoldMessengerKey: scaffoldMessengerKey,
                              ),
                  );
          }),
          routes: {
            'viewPackage': (context) => const ViewPackage(),
            'users': (context) => Users(
                  scaffoldMessengerKey: scaffoldMessengerKey,
                ),
            'createPackage': (context) => Welcomescreen(
                  scaffoldMessengerKey: scaffoldMessengerKey,
                ),
            'insertCat': (context) => Catogories(
                  scaffoldMessengerKey: scaffoldMessengerKey,
                ),
            'EditCat': (context) => EditCat(
                  scaffoldMessengerKey: scaffoldMessengerKey,
                ),
            'location': (context) => Location(
                  scaffoldMessengerKey: scaffoldMessengerKey,
                ),
            'registerUser': (context) => Register(
                  scaffoldMessengerKey: scaffoldMessengerKey,
                ),
          },
        ));
  }
}

// import 'dart:convert';
// import 'dart:core';
// import 'package:flutter/material.dart';
// import 'package:http/retry.dart';
// import 'package:provider/provider.dart';
// import 'package:purohithulu/model/user_details.dart';
// import 'package:http/http.dart' as http;
// //import 'package:dson/dson.dart';
// import '../controller/auth.dart';
// import '../utlis/purohitapi.dart';

// class Users extends ChangeNotifier {
//   //List<UserDetails> _users = [];
//   List<UserDetails> _users = [];
//   Map? user;
//   String? authToken;
//   void update(String token) {
//     authToken = token;
//   }

//   List<UserDetails> get users {
//     return [..._users];
//   }

//   Future<void> getUsers(BuildContext context) async {
//     final url = '${PurohitApi().baseUrl}${PurohitApi().users}';
//     final List<UserDetails> loadedUsers = [];
//     try {
//       final client = RetryClient(
//         http.Client(),
//         retries: 4,
//         when: (response) {
//           return response.statusCode == 401 ? true : false;
//         },
//         onRetry: (req, res, retryCount) async {
//           //print('retry started $token');

//           if (retryCount == 0 && res?.statusCode == 401) {
//             var accessToken = await Provider.of<Auth>(context, listen: false)
//                 .restoreAccessToken();
//             // Only this block can run (once) until done

//             req.headers['Authorization'] = accessToken;
//           }
//         },
//       );
//       var response = await client.get(
//         Uri.parse(url),
//         headers: {'Authorization': authToken!},
//       );

//       // final extractedData = json.decode(response.body) as Map<String, dynamic>;
//       // print(extractedData);
//       // if (extractedData['data'] == null) {
//       //   return;
//       // }
//       //List<dynamic> data = extractedData['data'];
//       // UserDetails.fromMap
// // //UserDetails usrs =UserDetails()..userId=extractedData['data']['id']..mobileno= extractedData['data']['mobileno']..adhar=extractedData['data']['adhar']..pan= extractedData['data']['pan']..adharno= extractedData['data']['adharno']..panno= extractedData['data']['panno']..userStatus= extractedData['data']['userstatus'];
// //       for (var map in data) {
// //         loadedUsers.add(
// //           UserDetails(
// //             userId: map['id'],
// //             mobileno: map['mobileno'],
// //             userStatus: map['userstatus'],
// //             adhar: map['adhar'],
// //             pan: map['pan'],
// //             adharno: map['adharno'],
// //             panno: map['panno'],
// //           ),
// //         );
// //       }
// //       _users = loadedUsers.reversed.toList();
//       //print(users);
//       user = json.decode(response.body);

//       if (user!['data'] != null) {
//         loadedUsers.add(UserDetails(
//             userId: user!['data']['id'].toString(),
//             mobileno: user!['data']['mobileno'],
//             userStatus: user!['data']['userstatus'],
//             adhar: user!['data']['adhar'],
//             pan: user!['data']['pan'],
//             adharno: user!['data']['adharno'],
//             panno: user!['data']['panno']));
//       }
//       _users = loadedUsers.reversed.toList();
//       notifyListeners();
//     } catch (e) {
//       print(e);
//     }
//   }
// }

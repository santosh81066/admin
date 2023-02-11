// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:http/retry.dart';
// import 'package:provider/provider.dart';

// import '../controller/auth.dart';
// import '../utlis/purohitapi.dart';

// class UserDetails extends ChangeNotifier {
//   final String? userId;
//   final String? mobileno;
//   bool? userStatus;
//   final String? adhar;
//   final String? pan;
//   final String? adharno;
//   final String? panno;
//   UserDetails(
//       {this.userId,
//       this.mobileno,
//       this.userStatus = false,
//       this.adhar,
//       this.pan,
//       this.adharno,
//       this.panno});
//   void _setUsrStatusValue(bool newValue) {
//     userStatus = newValue;
//     notifyListeners();
//   }

//   Future<void> toggleUserStatus(
//       String token, BuildContext context, bool usrstatus) async {
//     final oldStatus = userStatus;
//     userStatus = usrstatus;
//     notifyListeners();
//     final url = '${PurohitApi().baseUrl}${PurohitApi().updateUser}/$userId';
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
//       var response = await client.patch(Uri.parse(url),
//           headers: {'Authorization': token}, body: {"userstatus": userStatus});

//       var userstatus = json.decode(response.body);
//       if (response.statusCode >= 400) {
//         _setUsrStatusValue(oldStatus!);
//       }
//       print(userstatus);

//       //print(users);
//       notifyListeners();
//     } catch (e) {
//       print(e);
//     }
//   }
// }

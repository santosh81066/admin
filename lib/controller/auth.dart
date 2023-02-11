import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../utlis/purohitapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  var isloading = false;

  int? sessionId;
  String? accessToken;
  DateTime? accessTokenExpiryDate;
  String? refreshToken;
  DateTime? refreshTokenExpiryDate;
  Timer? authTimer;
  String? messages;
  String? get accesstoken {
    if (accessTokenExpiryDate != null &&
        accessTokenExpiryDate!.isAfter(DateTime.now()) &&
        accessToken != null) {
      return accessToken;
    }
    return null;
  }

  String? get refreshtoken {
    if (refreshTokenExpiryDate != null &&
        refreshTokenExpiryDate!.isAfter(DateTime.now()) &&
        refreshToken != null) {
      return refreshToken;
    }
    return null;
  }

  bool get authorized {
    return accesstoken != null;
  }

  loading() {
    isloading = !isloading;
    print(isloading);
    notifyListeners();
  }

  bool get isAuth {
    return refreshtoken != null;
  }

  Future<bool> tryAutoLogin() async {
    print('try auto login started');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractData['refreshExpiry']);
    final accessExpiry = DateTime.parse(extractData['accessTokenExpiry']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    sessionId = extractData['sessionId'];
    refreshToken = extractData['refreshToken'];
    accessToken = extractData['accessToken'];
    refreshTokenExpiryDate = expiryDate;
    accessTokenExpiryDate = accessExpiry;
    var timeToExpiry =
        accessTokenExpiryDate!.difference(DateTime.now()).inSeconds;
    notifyListeners();
    //autologout();

    print(accessToken);
    return true;
  }

  Future<String> restoreAccessToken() async {
    print('restoreAccessToken is started');
    final url = '${PurohitApi().baseUrl}${PurohitApi().login}/$sessionId';
    final prefs = await SharedPreferences.getInstance();
    try {
      loading();
      var response = await http.patch(Uri.parse(url),
          headers: {
            'Authorization': accessToken!,
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode({"refresh_token": refreshToken}));
      print(response.statusCode);
      var userDetails = json.decode(response.body);
      switch (response.statusCode) {
        case 401:
          logout();
          tryAutoLogin();
          loading();
          break;
        case 201:
          sessionId = userDetails['data']['session_id'];
          accessToken = userDetails['data']['access_token'];
          accessTokenExpiryDate = DateTime.now().add(
              Duration(seconds: userDetails['data']['access_token_expiry']));
          refreshToken = userDetails['data']['refresh_token'];
          refreshTokenExpiryDate = DateTime.now().add(
              Duration(seconds: userDetails['data']['refresh_token_expiry']));

          final userData = json.encode({
            'sessionId': sessionId,
            'refreshToken': refreshToken,
            'refreshExpiry': refreshTokenExpiryDate!.toIso8601String(),
            'accessToken': accessToken,
            'accessTokenExpiry': accessTokenExpiryDate!.toIso8601String()
          });
          prefs.setString('userData', userData);
          loading();
      }
      print('from restore access token:$userDetails');

      notifyListeners();
    } catch (e) {
      print(e);
    }
    return accessToken!;
  }

  Future adminLogin(String username, String password) async {
    final url = PurohitApi().baseUrl + PurohitApi().login;
    try {
      loading();

      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({'username': username, 'password': password}));
      loading();
      var userDetails = json.decode(response.body);
      var statuscode = response.statusCode;
      print(userDetails);
      switch (response.statusCode) {
        case 401:
          messages = userDetails['messages'].toString();
          break;
        case 201:
          messages = userDetails['messages'].toString();
          sessionId = userDetails['data']['session_id'];
          accessToken = userDetails['data']['access_token'];
          accessTokenExpiryDate = DateTime.now().add(
            Duration(seconds: userDetails['data']['access_token_expires_in']),
          );
          refreshToken = userDetails['data']['refresh_token'];
          refreshTokenExpiryDate = DateTime.now().add(
            Duration(seconds: userDetails['data']['refresh_token_expires_in']),
          );

          //print('this is from Auth response is:$accessToken');
          notifyListeners();
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode({
            'sessionId': sessionId,
            'refreshToken': refreshToken,
            'refreshExpiry': refreshTokenExpiryDate!.toIso8601String(),
            'accessToken': accessToken,
            'accessTokenExpiry': accessTokenExpiryDate!.toIso8601String()
          });

          //autologout();

          prefs.setString('userData', userData);
          break;
      }
      return statuscode;
    } catch (e) {}
  }

  Future<void> logout() async {
    print('logout started');
    final url = '${PurohitApi().baseUrl}${PurohitApi().login}/$sessionId';
    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': accessToken!
      },
    );

    var userStatus = json.decode(response.body);
    print(userStatus);

    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    print(userStatus);
    refreshToken = null;
    refreshTokenExpiryDate = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}

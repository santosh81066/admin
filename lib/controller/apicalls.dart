import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purohithulu_admin/controller/auth.dart';
import 'package:purohithulu_admin/model/location.dart';
import 'package:purohithulu_admin/utlis/purohitapi.dart';
import 'package:flutter/foundation.dart';
//import 'package:purohithulu_admin/view/location.dart';
import 'package:purohithulu_admin/widgets/insertcategory.dart';
import 'package:purohithulu_admin/controller/fluterr_functions.dart';
import 'package:provider/provider.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiCalls extends ChangeNotifier {
  String? token;
  List categories = [];
  Map? categoryTypes;
  List? packages = [];
  Map? package;
  List? users = [];
  Map? user;
  String? sub;
  String? initialvalue;
  String? messages;
  Location? location;
  List<int> selected_box = [];
  List<int> selectedCatId = [];
  int? locationId;
  //Location? location;
  void updatesubcat(String cat) {
    sub = cat;
    notifyListeners();
  }

  void update(String token) {
    this.token = token;
  }

  findById(int id) {
    return categories.firstWhere((cat) => cat['id'] == id);
  }

  bool calling = false;

  void selectedCat(int val) {
    if (selectedCatId.contains(val)) {
      selectedCatId.remove(val);
    } else {
      selectedCatId.add(val);
    }
    print(selectedCatId);
    notifyListeners();
  }

  void updateId(int val) {
    if (selected_box.contains(val)) {
      selected_box.remove(val);
    } else {
      selected_box.add(val);
    }
    print(selected_box);
    notifyListeners();
  }

  var isloading = false;
  var isloading2 = false;

  loading() {
    isloading = !isloading;
    notifyListeners();
  }

  loading2() {
    isloading2 = !isloading2;
    notifyListeners();
  }

  Future<void> insertCategory(
      String category, BuildContext context, String parentid) async {
    print("insert:$calling");
    var flutterFunctions =
        Provider.of<FlutterFunctions>(context, listen: false);
    var isCalling = calling == false ? 0 : 1;
    var data = {
      "categorytype": category,
      "filename": category,
      "calling": isCalling
    };
    var url = PurohitApi().baseUrl + PurohitApi().insertcategory + parentid;
    Map<String, String> obj = {"attributes": json.encode(data).toString()};
    try {
      loading();
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (reponse) {
          return reponse.statusCode == 401 ? true : false;
        },
        onRetry: (request, response, retryCount) async {
          if (retryCount == 0 && response?.statusCode == 401) {
            var accesstoken = await Provider.of<Auth>(context, listen: false)
                .restoreAccessToken();
            request.headers['Authorization'] = accesstoken;
            print(accesstoken);
          }
        },
      );
      var response = await http.MultipartRequest('Post', Uri.parse(url))
        ..files.add(await http.MultipartFile.fromPath(
            "imagefile", flutterFunctions.imageFile!.path,
            contentType: MediaType("image", "jpg")))
        ..headers['Authorization'] = token!
        ..fields.addAll(obj);
      final send = await client.send(response);
      final res = await http.Response.fromStream(send);
      var usrData = json.decode(res.body);
      loading();
      messages = usrData['messages'].toString();
    } catch (e) {
      print(e);
    }
  }

  Future<void> createPackage(int ctypeId, String amount, String noOfHours,
      BuildContext context, String packageName) async {
    final url =
        '${PurohitApi().baseUrl}${PurohitApi().createPackage}${ctypeId.toString()}';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token!
        },
        body: json.encode({
          "amount": amount,
          "noOfHours": noOfHours,
          "packageName": packageName
        }));
    print(url);
    var userDetails = json.decode(response.body);
    switch (response.statusCode) {
      case 201:
        messages = userDetails['messages'].toString();
        break;
      case 500:
        messages = userDetails['messages'].toString();
        break;
      case 401:
        Future.delayed(Duration.zero).then((value) {
          Provider.of<Auth>(context).logout();
          messages = userDetails['messages'].toString();
        });

        break;
    }
  }

  Future<void> getCatogories(BuildContext cont) async {
    final url = PurohitApi().baseUrl + PurohitApi().getcategory;

    try {
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 ? true : false;
        },
        onRetry: (req, res, retryCount) async {
          //print('retry started $token');

          if (retryCount == 0 && res?.statusCode == 401) {
            var accessToken = await Provider.of<Auth>(cont, listen: false)
                .restoreAccessToken();
            // Only this block can run (once) until done

            req.headers['Authorization'] = accessToken;
          }
        },
      );
      var response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      categoryTypes = json.decode(response.body);
      if (categoryTypes!['data'] != null) {
        categories = categoryTypes!['data'];
      }
      //print(categoryTypes);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPackages(BuildContext context) async {
    final url = '${PurohitApi().baseUrl}${PurohitApi().createPackage}';
    try {
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 ? true : false;
        },
        onRetry: (req, res, retryCount) async {
          //print('retry started $token');

          if (retryCount == 0 && res?.statusCode == 401) {
            var accessToken = await Provider.of<Auth>(context, listen: false)
                .restoreAccessToken();
            // Only this block can run (once) until done

            req.headers['Authorization'] = accessToken;
          }
        },
      );
      var response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token!
        },
      );
      package = json.decode(response.body);

      if (package!['data'] != null) {
        packages = package!['data'];
      }
      print(packages);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUsers(BuildContext context) async {
    final url = '${PurohitApi().baseUrl}${PurohitApi().users}';
    try {
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 ? true : false;
        },
        onRetry: (req, res, retryCount) async {
          //print('retry started $token');

          if (retryCount == 0 && res?.statusCode == 401) {
            var accessToken = await Provider.of<Auth>(context, listen: false)
                .restoreAccessToken();
            // Only this block can run (once) until done

            req.headers['Authorization'] = accessToken;
          }
        },
      );
      var response = await client.get(
        Uri.parse(url),
        headers: {'Authorization': token!},
      );

      user = json.decode(response.body);

      if (user!['data'] != null) {
        users = user!['data'];
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUser(
      int userid, BuildContext context, String adharno, String panno) async {
    final url = '${PurohitApi().baseUrl}${PurohitApi().updateUser}/$userid';

    try {
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 ? true : false;
        },
        onRetry: (req, res, retryCount) async {
          //print('retry started $token');

          if (retryCount == 0 && res?.statusCode == 401) {
            var accessToken = await Provider.of<Auth>(context, listen: false)
                .restoreAccessToken();
            // Only this block can run (once) until done

            req.headers['Authorization'] = accessToken;
          }
        },
      );
      var response = await client.patch(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token!
          },
          body: json.encode({"adharno": adharno, "panno": panno}));

      var userDetails = json.decode(response.body);
      switch (response.statusCode) {
        case 200:
          Future.delayed(Duration.zero)
              .then((value) => messages = userDetails['messages'].toString());
      }
      // print(userStatus);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future toggleAorD(int userid, BuildContext context, bool userstatus) async {
    final url = '${PurohitApi().baseUrl}${PurohitApi().updateUser}/$userid';
    try {
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 ? true : false;
        },
        onRetry: (req, res, retryCount) async {
          //print('retry started $token');

          if (retryCount == 0 && res?.statusCode == 401) {
            var accessToken = await Provider.of<Auth>(context, listen: false)
                .restoreAccessToken();
            // Only this block can run (once) until done

            req.headers['Authorization'] = accessToken;
          }
        },
      );
      var response = await client.patch(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token!
          },
          body: json.encode({"userstatus": userstatus}));

      var userDetails = json.decode(response.body);
      //print(userDetails);
      switch (response.statusCode) {
        case 201:
          Future.delayed(Duration.zero)
              .then((value) => messages = userDetails['messages'].toString());
          break;
        case 400:
          messages = userDetails['messages'].toString();
      }
      //print(messages);
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePackage(int packageId, BuildContext context) async {
    final url = '${PurohitApi().baseUrl}${PurohitApi().packageId}$packageId';
    try {
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 ? true : false;
        },
        onRetry: (req, res, retryCount) async {
          //print('retry started $token');

          if (retryCount == 0 && res?.statusCode == 401) {
            var accessToken = await Provider.of<Auth>(context, listen: false)
                .restoreAccessToken();
            // Only this block can run (once) until done

            req.headers['Authorization'] = accessToken;
          }
        },
      );
      var response = await client.delete(
        Uri.parse(url),
        headers: {'Authorization': token!},
      );
      print(url);
      var userDetails = json.decode(response.body);
      switch (response.statusCode) {
        case 201:
          Future.delayed(Duration.zero)
              .then((value) => messages = userDetails['messages'].toString());
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future register(String mobileno, String username, String adhar, String pan,
      String languages, BuildContext context) async {
    var flutterFunctions =
        Provider.of<FlutterFunctions>(context, listen: false);
    var data = {
      "username": username,
      "mobileno": mobileno,
      "role": "p",
      "userstatus": "0",
      "adhar": adhar,
      "pan": pan,
      "lang": languages,
      "isonline": "F"
    };
    var url =
        PurohitApi().baseUrl + PurohitApi().register + selectedCatId.join(',');
    Map<String, String> obj = {"attributes": json.encode(data).toString()};
    print(url);
    try {
      loading();

      var response = http.MultipartRequest('POST', Uri.parse(url))
        ..files.add(await http.MultipartFile.fromPath(
            "imagefile[]", flutterFunctions.imageFileList![0].path,
            contentType: MediaType("image", "jpg")))
        ..files.add(await http.MultipartFile.fromPath(
            "imagefile[]", flutterFunctions.imageFileList![1].path,
            contentType: MediaType("image", "jpg")))
        ..fields.addAll(obj);
      final send = await response.send();
      final res = await http.Response.fromStream(send);
      var userDetails = json.decode(res.body);
      print(userDetails);
      switch (res.statusCode) {
        case 201:
          messages = userDetails['messages'].toString();
          loading();
          break;
        case 500:
          messages = userDetails['messages'].toString();
          loading();
          break;
        case 400:
          messages = userDetails['messages'].toString();
          loading();
          break;
      }
      return res.statusCode;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getLocation(BuildContext context) async {
    final url = '${PurohitApi().baseUrl}${PurohitApi().getLocation}';
    try {
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 ? true : false;
        },
        onRetry: (req, res, retryCount) async {
          //print('retry started $token');

          if (retryCount == 0 && res?.statusCode == 401) {
            print('going to restore access token from get location');
            var accessToken = await Provider.of<Auth>(context, listen: false)
                .restoreAccessToken();
            // Only this block can run (once) until done

            req.headers['Authorization'] = accessToken;
          }
        },
      );
      print('from get location $token');
      var response = await client.get(
        Uri.parse(url),
       
      );
      Map<String, dynamic> locationBody = json.decode(response.body);
      location = Location.fromJson(locationBody);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> insertLocation(BuildContext context, String location) async {
    final url = '${PurohitApi().baseUrl}${PurohitApi().insertLocation}';
    try {
      loading();
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 ? true : false;
        },
        onRetry: (req, res, retryCount) async {
          //print('retry started $token');

          if (retryCount == 0 && res?.statusCode == 401) {
            print('going to restore access token from get location');
            var accessToken = await Provider.of<Auth>(context, listen: false)
                .restoreAccessToken();
            // Only this block can run (once) until done

            req.headers['Authorization'] = accessToken;
          }
        },
      );
      print('from get location $token');
      var response = await client.post(Uri.parse(url),
          headers: {
            'Authorization': token!,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({"location": location}));
      Map<String, dynamic> locationBody = json.decode(response.body);
      messages = locationBody['messages'].toString();
      print(locationBody);
      loading();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletelocation(BuildContext context) async {
    final url = '${PurohitApi().baseUrl}${PurohitApi().deleteLocation}';
    try {
      loading2();
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 ? true : false;
        },
        onRetry: (req, res, retryCount) async {
          //print('retry started $token');

          if (retryCount == 0 && res?.statusCode == 401) {
            var accessToken = await Provider.of<Auth>(context, listen: false)
                .restoreAccessToken();
            // Only this block can run (once) until done
            loading2();
            req.headers['Authorization'] = accessToken;
          }
        },
      );
      var response = await client.delete(Uri.parse(url),
          headers: {
            'Authorization': token!,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({"locationid": locationId}));

      var locationDetails = json.decode(response.body);
      messages = locationDetails['messages'].toString();
      loading2();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

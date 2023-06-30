import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purohithulu_admin/controller/auth.dart';
import 'package:purohithulu_admin/model/location.dart';
import 'package:purohithulu_admin/model/user_details.dart' as userdetails;
import 'package:purohithulu_admin/utlis/purohitapi.dart';
import 'package:flutter/foundation.dart';
import 'package:purohithulu_admin/view/users.dart';
//import 'package:purohithulu_admin/view/location.dart';
import 'package:purohithulu_admin/widgets/insertcategory.dart';
import 'package:purohithulu_admin/controller/fluterr_functions.dart';
import 'package:provider/provider.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../model/categories.dart';

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
  Map<int, UniqueKey> categoryKeys = {};
  int? locationId;
  String? selectedValue;
  var separator = '/';
  Categories? categorieModel;
  userdetails.UsersDetails? userDetails;
  String? checkboxErrorMessage;
  String? selectUser;
  String? selectName;
  //Location? location;
  void updatesubcat(String cat) {
    sub = cat;
    notifyListeners();
  }

  void selectUsers(String users) {
    selectUser = users;

    notifyListeners();
  }

  void onSelectName(String? name) {
    selectName = name;

    notifyListeners();
  }

  void dropdownSelectedValue(String value) {
    selectedValue = value;
    notifyListeners();
  }

  String? validateForm(
      List<TextEditingController> prices, List<int> selectedCat) {
    // Check if at least one checkbox is selected
    if (selectedCat.isEmpty) {
      return 'Please select at least one checkbox';
    }

    // Check if any of the selected checkboxes has an empty price
    for (int i = 0; i < selectedCat.length; i++) {
      if (selectedCat.length <= i || prices.length <= i) {
        return null; // Return null to indicate that no error was found
      }
      if (selectedCat.contains(i) && prices[i].text.isEmpty) {
        return 'Please enter price for selected checkbox ${i + 1}';
      }
    }
    notifyListeners();
    // Return null if no validation error is found
    return null;
  }

  void checkboxError(String error) {
    checkboxErrorMessage = error;
    notifyListeners();
  }

  void update(String token) {
    this.token = token;
  }

  findById(int id) {
    return categorieModel!.data!.firstWhere((cat) => cat.id == id);
  }

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
      selected_box.removeWhere((element) => element == val);
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

  Future<void> insertCategory(String category, BuildContext context,
      String parentid, String categorytype) async {
    var flutterFunctions =
        Provider.of<FlutterFunctions>(context, listen: false);
    final cattype = categorytype[0];
    String randomLetters = generateRandomLetters(10);
    var data = {
      "categorytype": category,
      "filename": randomLetters,
      "cattype": cattype,
    };

    var url = PurohitApi().baseUrl +
        PurohitApi().insertcategory +
        (parentid == "null" ? '' : parentid);
    Map<String, String> obj = {"attributes": json.encode(data).toString()};
    print("insert:$url");
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

  Future<void> createEvent(
      {int? ctypeId,
      String? amount,
      String? dateAndTime,
      String? eventName,
      String? address,
      String? description,
      BuildContext? context}) async {
    loading();
    final url =
        '${PurohitApi().baseUrl}${PurohitApi().createPackage}${ctypeId.toString()}';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token!
        },
        body: json.encode({
          "amount": amount,
          "dateandtime": dateAndTime,
          "eventName": eventName,
          "address": address,
          "description": description
        }));
    print(url);
    var userDetails = json.decode(response.body);
    print(userDetails);
    switch (response.statusCode) {
      case 201:
        showDialog(
          context: context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Event has created sucessfully'),
              actions: [
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        loading();
        break;
      case 500:
        messages = userDetails['messages'].toString();
        loading();
        break;
      case 401:
        Future.delayed(Duration.zero).then((value) {
          Provider.of<Auth>(context!).logout();
          messages = userDetails['messages'].toString();
        });
        loading();
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
      Map<String, dynamic> categoryTypes = json.decode(response.body);

      categorieModel = Categories.fromJson(categoryTypes);
      print(categoryTypes);
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
      //print(packages);
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

      Map<String, dynamic> users = json.decode(response.body);
      userDetails = userdetails.UsersDetails.fromJson(users);
      // print(userDetails!.data![0].role);
      //print(users![0]['adhar']);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUser(
      int userid, BuildContext context, String adharno) async {
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
          body: json.encode({
            "adharno": adharno,
          }));

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

  Future register(
      String mobileno,
      String adhar,
      String profilepic,
      String expirience,
      String languages,
      String userName,
      BuildContext context,
      List price) async {
    print("from api calls register:${price.map((e) => e).toList()}");
    var flutterFunctions =
        Provider.of<FlutterFunctions>(context, listen: false);
    var catIdString = selectedCatId.isNotEmpty ? selectedCatId.join(",") : '';
    String randomLetters = generateRandomLetters(10);

    var data = {
      "mobileno": mobileno,
      "role": "p",
      "username": userName,
      "userstatus": "0",
      "adhar": "${randomLetters}_adhar",
      "profilepic": "${randomLetters}_profilepic",
      "expirience": expirience,
      "lang": languages,
      "isonline": "0",
      "location": locationId
    };

    List<List<String>> priceList = [];
    for (var i = 0; i < price.length; i++) {
      List<String> subcatPrices = [];
      for (var j = 0; j < price[i].length; j++) {
        String text = price[i][j].text;

        if (text.isNotEmpty) {
          subcatPrices.add(text);
        }
        // Do something with the text value
      }
      priceList.add(subcatPrices);
    }
    String prices = priceList.map((e) => e.join(',')).join(',');
    prices = prices.replaceAll(RegExp(r',+$'), ''); // remove trailing commas
    prices = prices.replaceAll(RegExp(r',,'), ','); // remove trailing commas

    var url =
        "${PurohitApi().baseUrl}${PurohitApi().register}$catIdString$separator$prices";
    Map<String, String> obj = {"attributes": json.encode(data).toString()};
    print('Price for category: $url');
    try {
      loading();
      //print(isloading);
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
      var statuscode = res.statusCode;
      loading();
      //print('mobileno:$mobileno,');
      user = json.decode(res.body);
      // print(response.fields);

      // print(isloading);
      if (user!['data'] != null) {
        users = user!['data'];
        messages = user!['messages'].toString();
        // var firebaseresponse = await http.post(Uri.parse(firebaseUrl),
        //     body: json.encode({'status': apiCalls.users![0]['isonline']}));
        // var firebaseDetails = json.decode(firebaseresponse.body);
      }
      messages = user!['messages'].toString();
      print(messages);
      notifyListeners();
      return statuscode;
    } catch (e) {
      messages = e.toString();
      print(e);
    }
  }

  Future<void> getLocation(BuildContext context) async {
    final url = '${PurohitApi().baseUrl}${PurohitApi().location}';
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
    final url = '${PurohitApi().baseUrl}${PurohitApi().location}';
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
    final url = '${PurohitApi().baseUrl}${PurohitApi().location}';
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

  Future<XFile?> getprofiledp(BuildContext context, int i) async {
    var apicalls = Provider.of<ApiCalls>(context, listen: false);
    final url =
        "${PurohitApi().baseUrl}${PurohitApi().userIdCard}${apicalls.userDetails!.data![i].profilepic}${PurohitApi().userid}${apicalls.userDetails!.data![i].id}";
    loading();
    print(isloading);
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
            print('retry $accessToken');
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
      //Map<String, dynamic> userResponse = json.decode(response.body);
      final Uint8List resbytes = response.bodyBytes;
      print("from fetchImage:${response.statusCode}");
      //print(response.statusCode);
      switch (response.statusCode) {
        case 200:
          try {
            // Attempt to create an Image object from the image bytes
            // final image = Image.memory(resbytes);
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/${i}profile');
            await file.writeAsBytes(resbytes);
            final xfile = XFile(file.path);

            userDetails!.data![i].profiledp = XFile(file.path);
            loading();

            //print(userDetails!.data![0].profilepic!);
            notifyListeners();
            return xfile;
            // If the image was created successfully, the bytes are in a valid format
          } catch (e) {
            // If an error is thrown, the bytes are not in a valid format
            print('Error decoding image bytes: $e');
          }
      }

      // print(
      //     "this is from getuserPic:${userDetails!.data![0].xfile!.readAsBytes()}");
    } catch (e) {
      print(e);
    }
    loading();
    print(isloading);
    return null;
  }

  Future<XFile?> getadhardp(BuildContext context, int i) async {
    var apicalls = Provider.of<ApiCalls>(context, listen: false);
    final url =
        "${PurohitApi().baseUrl}${PurohitApi().userIdCard}${apicalls.userDetails!.data![i].adhar}${PurohitApi().userid}${apicalls.userDetails!.data![i].id}";
    print(url);
    loading();
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
            print('retry $accessToken');
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
      //Map<String, dynamic> userResponse = json.decode(response.body);
      final Uint8List resbytes = response.bodyBytes;
      print("from fetchImage:${response.statusCode}");
      print(response.statusCode);
      switch (response.statusCode) {
        case 200:
          try {
            // Attempt to create an Image object from the image bytes
            // final image = Image.memory(resbytes);
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/${i}adhar');
            await file.writeAsBytes(resbytes);
            final xfile = XFile(file.path);

            userDetails!.data![i].adharpic = XFile(file.path);
            loading();

            //print(userDetails!.data![0].profilepic!);
            notifyListeners();
            return xfile;
            // If the image was created successfully, the bytes are in a valid format
          } catch (e) {
            // If an error is thrown, the bytes are not in a valid format
            print('Error decoding image bytes: $e');
          }
      }

      // print(
      //     "this is from getuserPic:${userDetails!.data![0].xfile!.readAsBytes()}");
    } catch (e) {
      print(e);
    }
    loading();
    return null;
  }

  Future<void> uploadHoroscope(
      String title, BuildContext context, String userId) async {
    var flutterFunctions =
        Provider.of<FlutterFunctions>(context, listen: false);

    String randomLetters = generateRandomLetters(10);
    var data = {"title": title, "filename": randomLetters, "userid": userId};

    var url = PurohitApi().baseUrl + PurohitApi().horoscope;
    Map<String, String> obj = {"attributes": json.encode(data).toString()};
    print("insert:$url");
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
            "pdffile", flutterFunctions.pdfFilePath!,
            contentType: MediaType("application", "pdf")))
        ..headers['Authorization'] = token!
        ..fields.addAll(obj);
      final send = await client.send(response);
      final res = await http.Response.fromStream(send);
      var usrData = json.decode(res.body);
      loading();
      messages = usrData['messages'].toString();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  String generateRandomLetters(int length) {
    var random = Random();
    var letters = List.generate(length, (_) => random.nextInt(26) + 97);
    return String.fromCharCodes(letters);
  }

  Future<int> insertAdd(String title, BuildContext context) async {
    var flutterFunctions =
        Provider.of<FlutterFunctions>(context, listen: false);
    int statusCode = -1;
    String randomLetters = generateRandomLetters(10);
    var data = {
      "title": title,
      "filename": randomLetters,
    };

    var url = PurohitApi().baseUrl + PurohitApi().add;
    Map<String, String> obj = {"attributes": json.encode(data).toString()};
    print("insert:$url");
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
      print(res.body);
      messages = usrData['messages'].toString();
      statusCode = res.statusCode;
    } catch (e) {
      print(e);
    }
    return statusCode;
  }
}

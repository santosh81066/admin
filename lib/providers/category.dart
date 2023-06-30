import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/model/categories.dart';
import 'package:http/http.dart' as http;
import '../controller/auth.dart';
import '../controller/fluterr_functions.dart';
import '../utlis/purohitapi.dart';
import 'package:http_parser/http_parser.dart';

class Category with ChangeNotifier {
  String? token;
  Categories? categories;
  String? selectedCat;
  String? sub;
  Map? body;
  Data? data;
  int? subcat;
  String? messages;
  var isloading = false;
  void updatecat(String cat) {
    selectedCat = cat;
    notifyListeners();
  }

  loading() {
    isloading = !isloading;
    notifyListeners();
  }

  void update(String token) {
    this.token = token;
  }

  void updatesubcat(String cat) {
    sub = cat;
    notifyListeners();
  }

  Data findById(int id) {
    return categories!.data!.firstWhere((cat) => cat.id == id);
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

      categories = Categories.fromJson(categoryTypes);
      print(categories!.statusCode);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateCatAtributes(
      String id, BuildContext context, String cattitle) async {
    // print('updating....$id');
    // print('updating....${newCat.toJson()}');
    //  final catId = subid.subcat!.indexWhere((prod) => prod.id == subcat);
    // final catIndex = subid.subcat!.indexWhere((prod) => prod.id == subcat);
    // if (catIndex >= 0) {

    //   subid.subcat![catIndex] = newCat;
    //   notifyListeners();
    // } else {
    //   print('...');
    // }
    print('updateCatAtributes $subcat');
    final url = '${PurohitApi().baseUrl}${PurohitApi().updatecat}$subcat';
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
      var response = await client.patch(
        Uri.parse(url),
        body: json.encode({"categorytype": cattitle}),
        headers: {
          'Authorization': token!,
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      var userDetails = json.decode(response.body);
      messages = userDetails['messages'].toString();
      print(messages);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateImage(BuildContext context, String parentid) async {
    var flutterFunctions =
        Provider.of<FlutterFunctions>(context, listen: false);

    var url = PurohitApi().baseUrl + PurohitApi().updateimage + parentid;

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
        ..headers['Authorization'] = token!;

      final send = await client.send(response);
      final res = await http.Response.fromStream(send);
      var usrData = json.decode(res.body);
      print(usrData);
      loading();
      messages = usrData['messages'].toString();
    } catch (e) {
      print(e);
    }
  }
}

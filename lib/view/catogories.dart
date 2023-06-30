import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/model/categories.dart';
import 'package:purohithulu_admin/providers/category.dart';
import 'package:purohithulu_admin/widgets/app_drawer.dart';
import 'package:purohithulu_admin/widgets/button.dart';

import '../controller/apicalls.dart';
import '../controller/fluterr_functions.dart';
import '../widgets/insertcategory.dart';
import '../widgets/text_widget.dart';

class Catogories extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  const Catogories({super.key, this.scaffoldMessengerKey});

  @override
  State<Catogories> createState() => _CatogoriesState();
}

class _CatogoriesState extends State<Catogories> {
  String? selectedValue;
  String? editselectedValue;
  int? parentid;
  String? editCatButton = 'Edit category';
  final categories = StreamController();
  String catergoryType = "catergoryType";
  String hintCatDetails = "please enter text to save";
  TextEditingController catDetails = TextEditingController();
  TextEditingController categorytype = TextEditingController();
  String insertCategoryButton = "Insert category";

  @override
  Widget build(BuildContext context) {
    var image = Provider.of<FlutterFunctions>(context, listen: false);
    var cat = Provider.of<Category>(context, listen: false).categories;

    //print("${cat.data == null ? "there is no data" : cat.statusCode}");
    return Scaffold(
      appBar: AppBar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Consumer<ApiCalls>(
              builder: (context, value, child) {
                //print('this is from consumer is:${value.vehicles}');
                return DropdownButton<String>(
                  elevation: 16,
                  isExpanded: true,
                  hint: Text('please select type of catogory '),
                  items: value.categorieModel!.data!.map((v) {
                    return DropdownMenuItem<String>(
                        onTap: () {
                          parentid = v.id;
                          print(v.title);
                        },
                        value: v.title,
                        child: Text(v.title!));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedValue = val!;
                    });
                  },
                  value: selectedValue,
                );
              },
            ),
          ),
          InsertCategory(
            parentid: parentid.toString(),
            categories: categories,
            categoryName: catergoryType,
            catergoryType: categorytype,
            buttonName: insertCategoryButton,
            imageIcon: () {
              image.onImageButtonPress(ImageSource.gallery);
            },
            scaffoldMessengerKey: widget.scaffoldMessengerKey,
          ),
          Divider(
            thickness: 2,
          ),
          Consumer<ApiCalls>(
            builder: (context, value, child) {
              //print('this is from consumer is:${value.vehicles}');
              return value.categories == null
                  ? Text('no data')
                  : DropdownButton<String>(
                      elevation: 16,
                      isExpanded: true,
                      hint: Text('please select type of catogory '),
                      items: value.categorieModel!.data!.map((v) {
                        return DropdownMenuItem<String>(
                            onTap: () {
                              parentid = v.id;
                              //print(value.selectedCat);
                            },
                            value: v.title,
                            child: Text(v.title!));
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          editselectedValue = val!;
                        });
                        //print(val);
                      },
                      value: editselectedValue,
                    );
            },
          ),
          Button(
            buttonname: editCatButton,
            onTap: () {
              Navigator.pushNamed(context, 'EditCat', arguments: parentid);
            },
          )
        ]),
      ),
    );
  }
}

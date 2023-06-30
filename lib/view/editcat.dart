import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/controller/apicalls.dart';
import 'package:purohithulu_admin/model/categories.dart';
import 'package:purohithulu_admin/providers/category.dart';
import 'package:purohithulu_admin/widgets/text_widget.dart';

import '../controller/fluterr_functions.dart';
import '../widgets/button.dart';

class EditCat extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  const EditCat({super.key, this.scaffoldMessengerKey});

  @override
  State<EditCat> createState() => _EditCatState();
}

class _EditCatState extends State<EditCat> {
  String hintCat = "Change Title?";
  String updateCatButton = "update image";
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isSubcat = false;
  //String? cid;
  var _initValues = {
    'title': '',
  };
  // var _editedCategory = Data(
  //   id: null,
  //   filename: '',
  //   mimetype: '',
  //   title: '',
  //   directcalling: 0,
  // );
  // var _editedSubCategory = Subcat(
  //   id: null,
  //   filename: '',
  //   mimetype: '',
  //   title: '',
  //   directcalling: 0,
  // );

  void _saveForm(
      String id, String title, ScaffoldMessengerState messages) async {
    print('save form');
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      print('not valid');
      return;
    }
    _form.currentState!.save();
    final message = Provider.of<Category>(context, listen: false);
    await Provider.of<Category>(context, listen: false)
        .updateCatAtributes(id, context, title);
    messages.showSnackBar(SnackBar(
      content: Text(message.messages!),
      duration: Duration(seconds: 5),
    ));
    //Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    final catId = ModalRoute.of(context)!.settings.arguments as int;

    var subcategory = Provider.of<Category>(context);
    final loadedProduct = Provider.of<ApiCalls>(
      context,
    ).findById(catId);
    if (_isInit) {
      subcategory.subcat = catId;
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var apicalls = Provider.of<ApiCalls>(context);
    final ScaffoldMessengerState scaffoldKey =
        widget.scaffoldMessengerKey!.currentState as ScaffoldMessengerState;
    final catId = ModalRoute.of(context)!.settings.arguments as int;
    // final loadedProduct = Provider.of<ApiCalls>(
    //   context,
    // ).findById(catId);
    TextEditingController cat = TextEditingController();
    List<Data> categories = [];

    categories =
        apicalls.categorieModel!.data!.where((cat) => cat.id == catId).toList();

    print(categories);
    int id = catId;
    var image = Provider.of<FlutterFunctions>(context, listen: false);
    var subcategory = Provider.of<Category>(context);
    var flutterFunctions = Provider.of<FlutterFunctions>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(categories[0].title!),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm(id.toString(), cat.text.trim(), scaffoldKey);
            },
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          categories[0].subcat == null
              ? Container()
              : Consumer<ApiCalls>(
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        DropdownButton<String>(
                          elevation: 16,
                          isExpanded: true,
                          hint: Text('please select sub category'),
                          items: categories[0].subcat!.map((v) {
                            return DropdownMenuItem<String>(
                                onTap: () {
                                  subcategory.subcat = v['id'];
                              
                                },
                                value: v['title'],
                                child: Text(v['title']));
                          }).toList(),
                          onChanged: (val) {
                            //print(cat.text);

                            value.updatesubcat(val!);
                            print(val);
                          },
                          value: value.sub,
                        ),
                      ],
                    );
                  },
                ),
          Form(
            key: _form,
            child: Column(
              children: [
                subcategory.sub != null
                    ? Container()
                    : TextFormField(
                        controller: cat,
                        //initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Change title?'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a value';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          // _editedCategory = Data(
                          //     id: loadedProduct.id,
                          //     title: value!,
                          //     filename: _editedCategory.filename,
                          //     mimetype: _editedCategory.mimetype,
                          //     directcalling: _editedCategory.directcalling);
                        },
                      ),
                // subcategory.sub == null
                //     ? Container()
                //     : TextFormField(
                //         initialValue: _initValues['title'],
                //         decoration: InputDecoration(
                //             labelText: 'Change subcategory title?'),
                //         textInputAction: TextInputAction.next,
                //         validator: (value) {
                //           if (value!.isEmpty) {
                //             return 'Please enter a value.';
                //           }

                //           return null;
                //         },
                //         onSaved: (value) {
                //           // _editedSubCategory = Subcat(
                //           //     id: subcategory.subcat,
                //           //     title: value!,
                //           //     filename: _editedSubCategory.filename,
                //           //     mimetype: _editedSubCategory.mimetype,
                //           //     directcalling: _editedSubCategory.directcalling);
                //         },
                //       ),
                Row(
                  children: [],
                ),
                flutterFunctions.imageFile != null
                    ? SizedBox(
                        width: 30,
                        child:
                            Image.file(File(flutterFunctions.imageFile!.path)))
                    : TextButton.icon(
                        onPressed: () {
                          image.onImageButtonPress(ImageSource.gallery);
                        },
                        icon: Icon(Icons.image),
                        label: Text("Select Category Icon")),
                flutterFunctions.imageFile != null
                    ? TextButton(
                        onPressed: () {
                          image.onImageButtonPress(ImageSource.gallery);
                        },
                        child: Text("Change Icon"))
                    : Container(),
                Button(
                  buttonname: updateCatButton,
                  onTap: () async {
                    await subcategory.updateImage(
                        context, subcategory.subcat.toString());
                    scaffoldKey.showSnackBar(SnackBar(
                      content: Text(subcategory.messages!),
                      duration: Duration(seconds: 5),
                    ));
                  },
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

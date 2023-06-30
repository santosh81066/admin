import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/controller/apicalls.dart';
import 'package:purohithulu_admin/controller/fluterr_functions.dart';

class InsertAdd extends StatefulWidget {
  const InsertAdd({super.key});

  @override
  State<InsertAdd> createState() => _InsertAddState();
}

class _InsertAddState extends State<InsertAdd> {
  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var apiCalls = Provider.of<ApiCalls>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Add'),
      ),
      body: Consumer<FlutterFunctions>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      value.imageFile == null
                          ? const Text('No image selected.')
                          : Text(value.imageFile!.path),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        enabled: false,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        validator: (validator) {
                          if (value.imageFile == null) {
                            return 'Please select a image';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          value.onImageButtonPress(ImageSource.gallery);
                          // Call your function to select image
                        },
                        child: const Text('Select Image'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            apiCalls
                                .insertAdd(titleController.text, context)
                                .then((statusCode) {
                              if (statusCode == 201) {
                                // Add the code to show a success alert dialog here
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Success'),
                                      content: const Text(
                                          'Image Uploaded Successfully!'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // You can also handle other status codes here
                                // For example, you may want to show a different message
                                // if the status code is not 201 (which means that the request was not successful)
                              }
                            });
                          }
                        },
                        child: const Text('Upload Image'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

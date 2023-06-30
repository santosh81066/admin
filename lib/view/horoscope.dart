import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:purohithulu_admin/controller/fluterr_functions.dart';
import 'package:purohithulu_admin/model/user_details.dart';

import '../controller/apicalls.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _selectedUser;
  File? _selectedFile;
  bool? _isUploading = false;
  TextEditingController searchController = TextEditingController(text: '');
  // replace with actual user list
  @override
  Widget build(BuildContext context) {
    var apicalls = Provider.of<ApiCalls>(context, listen: false);
    var flutterfunctions = Provider.of<FlutterFunctions>(context);
    // List<Data> filteredUsers = apicalls.userDetails!.data!.where((user) {
    //   return user.role! == 'u' &&
    //       user.mobileno!.toString().contains(searchController.text);
    // }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Astrology'),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              onChanged: (value) {},
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by mobile number',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _title = value.trim();
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select a user',
                  ),
                  value: _selectedUser,
                  items: apicalls.userDetails!.data!
                      .where((user) =>
                          user.role! == 'u' &&
                          user.mobileno
                              .toString()
                              .contains(searchController.text))
                      .map((user) {
                    // print("filterd users${user.username}");
                    return DropdownMenuItem<String>(
                      value: user.id.toString(),
                      child: Text(user.username ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUser = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'User is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                flutterfunctions.pdfFilePath != null
                    ? Row(
                        children: [
                          const Icon(Icons.picture_as_pdf),
                          Expanded(
                              child:
                                  Text(flutterfunctions.pdfFilePath.toString()))
                        ],
                      )
                    : Container(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await flutterfunctions.pickPDFFileFromGallery();

                    print(
                        "from Elevated button:${flutterfunctions.pdfFilePath}");
                  },
                  child: Text(_selectedFile == null
                      ? 'Select a file'
                      : 'File selected'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: apicalls.isloading
                      ? null
                      : () async {
                          await apicalls.uploadHoroscope(
                              _title!, context, _selectedUser!);
                          Future.delayed(Duration.zero)
                              .then((value) => showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Message'),
                                        content: Text('${apicalls.messages}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Ok',
                                                style: TextStyle(
                                                    color: Colors.green)),
                                          ),
                                        ],
                                      );
                                    },
                                  ));
                        },
                  child: apicalls.isloading
                      ? const CircularProgressIndicator()
                      : const Text('Upload'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FileListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Astrology'),
      ),
      body: ListView.builder(
        itemCount: 10, // replace with actual file count
        itemBuilder: (context, index) {
          // replace with actual file data
          String title = 'File ${index + 1}';
          String url = 'https://example.com/files/${index + 1}.pdf';

          return ListTile(
            title: Text(title),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // replace with actual download logic
              },
            ),
          );
        },
      ),
    );
  }
}

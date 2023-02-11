import '../controller/apicalls.dart';
import 'package:flutter/material.dart';
import 'button.dart';
import 'text_widget.dart';
import 'package:provider/provider.dart';

class CreatePackage extends StatefulWidget {
  const CreatePackage(
      {Key? key,
      required this.price,
      required this.amt,
      required this.noOfMinutes,
      required this.noOfMin,
      required this.button,
      required this.viewButton,
      required this.packageName,
      required this.hintPname})
      : super(key: key);

  final TextEditingController price;
  final String amt;
  final TextEditingController noOfMinutes;
  final TextEditingController packageName;
  final String hintPname;
  final String noOfMin;
  final String button;
  final String viewButton;

  @override
  State<CreatePackage> createState() => _CreatePackageState();
}

class _CreatePackageState extends State<CreatePackage> {
  String? selectedValue;
  int? imageid;
  @override
  Widget build(BuildContext context) {
    var apiCalls = Provider.of<ApiCalls>(context, listen: false);
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextWidget(controller: widget.price, hintText: widget.amt)),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextWidget(
              controller: widget.noOfMinutes, hintText: widget.noOfMin),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextWidget(
              controller: widget.packageName, hintText: widget.hintPname),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Consumer<ApiCalls>(
            builder: (context, value, child) {
              //print('this is from consumer is:${value.vehicles}');
              return DropdownButton<String>(
                elevation: 16,
                isExpanded: true,
                hint: Text('please select type of catogory '),
                items: value.categories.map((v) {
                  return DropdownMenuItem<String>(
                      onTap: () {
                        imageid = v['id'];
                        print(v['title']);
                      },
                      value: v['title'],
                      child: Text(v['title']));
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              onTap: () {
                print(imageid);
                apiCalls.createPackage(
                    imageid!,
                    widget.price.text.trim(),
                    widget.noOfMinutes.text.trim(),
                    context,
                    widget.packageName.text);
              },
              buttonname: widget.button,
              fontSize: 15,
            ),
            Button(
              buttonname: widget.viewButton,
              fontSize: 15,
              onTap: () {
                print('button pressed');
                Navigator.pushNamed(context, 'viewPackage');
              },
            ),
          ],
        )
      ],
    );
  }
}

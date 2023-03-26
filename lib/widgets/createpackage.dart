import '../controller/apicalls.dart';
import 'package:flutter/material.dart';
import '../controller/fluterr_functions.dart';
import 'button.dart';
import 'text_widget.dart';
import 'package:provider/provider.dart';

class CreatePackage extends StatefulWidget {
  const CreatePackage({
    Key? key,
    required this.price,
    required this.address,
    required this.description,
    required this.amt,
    required this.packageName,
    required this.hintPname,
    required this.button,
    required this.viewButton,
  }) : super(key: key);

  final TextEditingController price;
  final TextEditingController address;
  final TextEditingController description;
  final String amt;
  final TextEditingController packageName;
  final String hintPname;
  final String button;
  final String viewButton;

  @override
  State<CreatePackage> createState() => _CreatePackageState();
}

class _CreatePackageState extends State<CreatePackage> {
  int? imageid;

  // Define a controller for the date and time TextFormField
  final TextEditingController dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set the initial value of the dateTimeController from the flutterFunctions variables
    final flutterFunctions =
        Provider.of<FlutterFunctions>(context, listen: false);
    if (flutterFunctions.date != null &&
        flutterFunctions.selectedTime != null) {
      dateTimeController.text =
          '${flutterFunctions.date} ${flutterFunctions.selectedTime!.hour.toString().padLeft(2, '0')}:${flutterFunctions.selectedTime!.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var apiCalls = Provider.of<ApiCalls>(context, listen: false);
    var flutterFunctions =
        Provider.of<FlutterFunctions>(context, listen: false);

    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Event',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: widget.price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.amt,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: widget.packageName,
              decoration: InputDecoration(
                labelText: widget.hintPname,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: widget.address,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: widget.description,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: dateTimeController,
              decoration: InputDecoration(
                labelText: 'Date and Time',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                // Show a date picker dialog
                await flutterFunctions.pickDate(context);
                if (flutterFunctions.date != null) {
                  // Show a time picker dialog
                  await flutterFunctions.selectTime(context);
                  if (flutterFunctions.selectedTime != null) {
                    // Combine the selected date and time and update the controller value
                    dateTimeController.text =
                        '${flutterFunctions.date} ${flutterFunctions.selectedTime!.hour.toString().padLeft(2, '0')}:${flutterFunctions.selectedTime!.minute.toString().padLeft(2, '0')}';
                  }
                }
              },
            ),
            SizedBox(height: 16.0),
            Consumer<ApiCalls>(
              builder: (context, value, child) {
                return DropdownButton<String>(
                  elevation: 16,
                  isExpanded: true,
                  hint: Text('please select type of catogory '),
                  items: value.categorieModel!.data.map((v) {
                    return DropdownMenuItem<String>(
                        onTap: () {
                          imageid = v.id;
                          print(v.title);
                        },
                        value: v.title,
                        child: Text(v.title));
                  }).toList(),
                  onChanged: (val) {
                    value.dropdownSelectedValue(val!);
                  },
                  value: value.selectedValue,
                );
              },
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                apiCalls.isloading == true
                    ? const CircularProgressIndicator()
                    : Expanded(
                        child: Button(
                          onTap: apiCalls.isloading == true
                              ? null
                              : () {
                                  apiCalls.createEvent(
                                    ctypeId: imageid!,
                                    amount: widget.price.text.trim(),
                                    dateAndTime: dateTimeController.text.trim(),
                                    eventName: widget.packageName.text.trim(),
                                    address: widget.address.text.trim(),
                                    description: widget.description.text.trim(),
                                    context: context,
                                  );
                                },
                          buttonname: widget.button,
                          fontSize: 18,
                        ),
                      ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Button(
                    buttonname: widget.viewButton,
                    fontSize: 18,
                    onTap: () {
                      Navigator.pushNamed(context, 'viewPackage');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

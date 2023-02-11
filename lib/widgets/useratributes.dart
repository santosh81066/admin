// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:purohithulu/widgets/text_widget.dart';
// import 'package:purohithulu/widgets/userlist.dart';
// import '../controller/auth.dart';
// import '../model/user_details.dart';
// import '../utlis/purohitapi.dart';
// import 'button.dart';

// class UserAtributes extends StatefulWidget {
//   final UserDetails? userDetails;
//   const UserAtributes(this.userDetails, {super.key});

//   @override
//   State<UserAtributes> createState() => _UserAtributesState();
// }

// class _UserAtributesState extends State<UserAtributes> {
//   bool isopen = false;
//   TextEditingController adhar = TextEditingController();
//   TextEditingController pan = TextEditingController();
//   String saveButton = 'Save';
//   @override
//   Widget build(BuildContext context) {
//     var token = Provider.of<Auth>(context);
//     return ExpansionTile(
//       title: Text("${widget.userDetails!.mobileno}"),
//       children: [
//         Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   // width: 30,
//                   child: const UserList(),
//                 )
//               ],
//             ),
//             const Divider(),
//             Center(
//               child: InteractiveViewer(
//                 boundaryMargin: const EdgeInsets.all(20.0),
//                 minScale: 0.1,
//                 maxScale: 5,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 1 / 5,
//                   width: MediaQuery.of(context).size.width,
//                   child: Image.network(
//                       "${PurohitApi().baseUrl}${PurohitApi().userIdCard}${widget.userDetails!.adhar}",
//                       headers: {"Authorization": token.accessToken!}),
//                 ),
//               ),
//             ),
//             const Divider(),
//             Center(
//               child: InteractiveViewer(
//                 boundaryMargin: const EdgeInsets.all(20.0),
//                 minScale: 0.1,
//                 maxScale: 5,
//                 child: Container(
//                   height: MediaQuery.of(context).size.height * 1 / 5,
//                   width: MediaQuery.of(context).size.width,
//                   child: Image.network(
//                       "${PurohitApi().baseUrl}${PurohitApi().userIdCard}${widget.userDetails!.pan}",
//                       headers: {"Authorization": token.accessToken!}),
//                 ),
//               ),
//             ),
//             const Divider(),
//             Padding(
//               padding: EdgeInsets.all(5),
//               child: TextWidget(
//                 hintText: '${widget.userDetails!.adharno}',
//                 userName: adhar,
//               ),
//             ),
//             const Divider(),
//             Padding(
//               padding: EdgeInsets.all(5),
//               child: TextWidget(
//                 hintText: 'Please Enter pan',
//                 userName: pan,
//               ),
//             ),
//             const Divider(),
//             Button(
//               buttonname: saveButton,
//               fontSize: 15,
//               onTap: () {
//                 print('button pressed');
//                 Navigator.pushNamed(context, 'viewPackage');
//               },
//             ),
//           ],
//         )
//       ],
//     );
//     ;
//   }
// }

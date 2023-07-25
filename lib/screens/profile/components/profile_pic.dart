// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:let_com/backend_services/auth.dart';
// import 'package:let_com/utils.dart';

// class ProfilePic extends StatefulWidget {
//   const ProfilePic({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ProfilePic> createState() => _ProfilePicState();
// }

// Uint8List? _file;
// bool _isLoading = false;

// class _ProfilePicState extends State<ProfilePic> {
//   void setImg(String uid, String username) async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       String res = await AuthService()
//           .setProfileImage(uid: uid, name: username, file: _file!);

//       if (res == "success") {
//         setState(() {
//           _isLoading = false;
//         });
//         showSnackBar("profile picture updated", context);
//         setState(() {
//           _file = null;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//         showSnackBar("error occured updating profile picture", context);
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       showSnackBar("network error occured try again later", context);
//     }
//   }

//   _selectImage(BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return SimpleDialog(
//           title: Text('Change Profile Picture'),
//           children: [
//             SimpleDialogOption(
//               padding: EdgeInsets.all(20),
//               child: Text('Take a Photo'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 Uint8List file = await pickImage(ImageSource.camera);

//                 setState(() {
//                   _file = file;
//                 });
//               },
//             ),
//             SimpleDialogOption(
//               padding: EdgeInsets.all(20),
//               child: Text('Choose from gallery'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 Uint8List file = await pickImage(ImageSource.gallery);
//                 setState(() {
//                   _file = file;
//                 });
//               },
//             ),
//             SimpleDialogOption(
//               padding: EdgeInsets.all(20),
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 115,
//           width: 115,
//           child: Stack(
//             fit: StackFit.expand,
//             clipBehavior: Clip.none,
//             children: [
//               _file != null
//                   ? CircleAvatar(
//                       backgroundImage: MemoryImage(_file!),
//                     )
//                   : CircleAvatar(
//                       backgroundImage: AssetImage("assets/images/person.jpeg"),
//                     ),
//               Positioned(
//                 right: -16,
//                 bottom: 0,
//                 child: SizedBox(
//                   height: 46,
//                   width: 46,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50),
//                         side: BorderSide(color: Colors.white),
//                       ),
//                       primary: Colors.white,
//                       backgroundColor: Color(0xFFF5F6F9),
//                     ),
//                     onPressed: () {
//                       _selectImage(context);
//                     },
//                     child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//         _file != null
//             ? TextButton(onPressed: () =>setImg(uid, "profilepic"), child: Text("save Changes"))
//             : Container()
//       ],
//     );
//   }
// }

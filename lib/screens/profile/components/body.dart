import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:let_com/backend_services/auth.dart';
import 'package:let_com/provider/user_provider.dart';
import 'package:let_com/utils.dart';
import 'package:provider/provider.dart';
import '../../../model/User.dart' as model;
import '../../sign_in/sign_in_screen.dart';
import 'profile_menu.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final auth = AuthService();
  bool _isLoading = false;

  Uint8List? _file;
  Future<String> setImg(String uid, String username) async {
    setState(() {
      _isLoading = true;
    });
    String res = '';
    try {
      String res = await AuthService()
          .setProfileImage(uid: uid, name: username, file: _file!);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("profile picture updated successfully! ", context);
        setState(() {
          _file = null;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("error occured updating profile picture", context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar("network error occured try again later", context);
    }
    return res;
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Change Profile Picture'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Take a Photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);

                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    UserProvider _userp = Provider.of(context);
    print(_userp);

    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          _isLoading
              ? LinearProgressIndicator()
              : Container(
                  padding: EdgeInsets.only(top: 0),
                ),
          Column(
            children: [
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    _file != null
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(_file!),
                          )
                        : CircleAvatar(
                            backgroundImage: user!.photoUrl == null
                                ? AssetImage("assets/images/person.jpeg")
                                : NetworkImage(user.photoUrl!)
                                    as ImageProvider<Object>?,
                          ),
                    Positioned(
                      right: -16,
                      bottom: 0,
                      child: SizedBox(
                        height: 46,
                        width: 46,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(color: Colors.white),
                            ),
                            primary: Colors.white,
                            backgroundColor: Color(0xFFF5F6F9),
                          ),
                          onPressed: () {
                            _selectImage(context);
                          },
                          child:
                              SvgPicture.asset("assets/icons/Camera Icon.svg"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _file != null
                  ? TextButton(
                      onPressed: () async {
                        String res = await setImg(user!.uid, "profilepic");
                        if (res == 'success') {
                          Provider.of<UserProvider>(context, listen: false)
                              .refreshUser();
                        }
                      },
                      child: Text("save Changes"))
                  : Container()
            ],
          ),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async {
              await auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                SignInScreen.routeName,
                (route) => route.isFirst,
              );
            },
          ),
        ],
      ),
    );
  }
}

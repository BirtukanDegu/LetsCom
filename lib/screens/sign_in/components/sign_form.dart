import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:let_com/backend_services/auth.dart';
import 'package:let_com/components/custom_surfix_icon.dart';
import 'package:let_com/components/form_error.dart';
import 'package:let_com/helper/keyboard.dart';
import 'package:let_com/screens/forgot_password/forgot_password_screen.dart';
import 'package:let_com/screens/login_success/login_success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool selected = false;
  bool remember = false;
  bool inprogres = false;
  final List<String?> errors = [];
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserEmailPassword();
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      if (_remeberMe) {
        setState(() {
          remember = true;
        });
        _emailController.text = _email ?? "";
        _passwordController.text = _password ?? "";
      }
    } catch (e) {}
  }

  void _handleRemeberme(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      remember = value;
      if (remember == true) {
        await SharedPreferences.getInstance().then(
          (prefs) {
            prefs.setBool("remember_me", value);
            prefs.setString('email', _emailController.text);
            prefs.setString('password', _passwordController.text);
          },
        );
      } else {
        await SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });
      }
      setState(() {
        remember = value;
      });
    }
  }

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  // showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           elevation: 3,
  //           actions: <Widget>[
  //             TextButton(
  //                 child: Text('Ok'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 })
  //           ],
  //           content:
  //               Text("Password Reset Link has been sent. Check Your email!"),
  //         );
  //       },
  //     );
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(_emailController),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(_passwordController),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  _handleRemeberme(value!);
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          inprogres
              ? CircularProgressIndicator(
                  color: Colors.blue[700],
                )
              : DefaultButton(
                  text: "Login",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (remember) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0))),
                              contentPadding: EdgeInsets.only(top: 10.0),
                              elevation: 3,
                              title: Text("Remember Login"),
                              actions: <Widget>[
                                TextButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                              content: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    "Your password and email will be remembered for next 30 days "),
                              ),
                            );
                          },
                        );
                      }
                      setState(() {
                        inprogres = true;
                      });

                      // if all are valid then go to success screen
                      KeyboardUtil.hideKeyboard(context);
                      User? us = await auth.signInWithEmailPassword(
                          _emailController.text.trim(),
                          _passwordController.text.trim());
                      setState(() {
                        inprogres = false;
                      });
                      if (us != null) {
                        Navigator.pushNamed(
                            arguments: us.uid,
                            context,
                            LoginSuccessScreen.routeName);
                      }
                    }
                  },
                ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField(TextEditingController control) {
    return TextFormField(
      controller: control,
      obscureText: selected ? false : true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                selected = !selected;
              });
            },
            child: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg")),
      ),
    );
  }

  TextFormField buildEmailFormField(TextEditingController control) {
    return TextFormField(
      controller: control,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

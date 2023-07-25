import 'package:flutter/material.dart';
import 'package:let_com/backend_services/auth.dart';
import 'package:let_com/components/custom_surfix_icon.dart';
import 'package:let_com/components/default_button.dart';
import 'package:let_com/components/form_error.dart';
import 'package:let_com/screens/complete_profile/complete_profile_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../signup_success/signup_success_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key, required this.role}) : super(key: key);
  final String role;
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? adress;
  String? password;
  String? phone;
  String? conform_password;
  bool remember = false;
  bool isloading = false;
  final List<String?> errors = [];
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();

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

  void SignUpUser() async {
    setState(() {
      isloading = true;
    });

    final res = await AuthService().registerWithEmailAndPassword(
        email: email!,
        password: password!,
        firstName: fname.text,
        address: adress!,
        lastName: lname.text,
        phoneNumber: phone!,
        role: widget.role);
    setState(() {
      isloading = false;
    });
    if (res == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("error has occured")));
    }
    if (res!=null){
    Navigator.pushNamedAndRemoveUntil(
      arguments: res!.uid,
      context,
      SignupSuccessScreen.routeName,
      (route) => route.isFirst,
    );}
    // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    final nameRegExp = new RegExp(
                        r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
                    if (value == '') {
                      return 'Enter Your First Name';
                    } else if (nameRegExp.hasMatch(value!)) {
                      return 'Not Valid Name';
                    }
                  },
                  maxLines: 1,
                  controller: fname,
                  decoration: InputDecoration(
                    hintText: 'First name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  validator: (value) {
                    final nameRegExp = new RegExp(
                        r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
                    if (value == '') {
                      return 'Enter Your First Name';
                    } else if (nameRegExp.hasMatch(value!)) {
                      return 'Not Valid Name';
                    }
                  },
                  maxLines: 1,
                  controller: lname,
                  decoration: InputDecoration(
                    hintText: 'Last name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAdressFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          isloading
              ? CircularProgressIndicator(color: Colors.blue[700])
              : DefaultButton(
                  text: "Continue",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      SignUpUser();
                      // if all are valid then go to success screen
                    }
                  },
                ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
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
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
          labelText: "Phone Number",
          hintText: "Enter your Phone Number",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.phone)),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
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

  TextFormField buildAdressFormField() {
    return TextFormField(
      onSaved: (newValue) => adress = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Adress",
        hintText: "Enter your Adress",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.home_outlined),
      ),
    );
  }
}

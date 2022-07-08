import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/screens/auth/login_screen.dart';
import 'package:kader/screens/home_screen.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/services/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'RegisterScreen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerFormKey = GlobalKey<FormState>();

  File? imageFile;
  String password = '';

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _idNumberFocusNode = FocusNode();

  Future<void> submitForm(Languages languages) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (imageFile == null) {
      Fluttertoast.showToast(msg: languages.mustPickAPicture);
      return;
    }
    if (registerFormKey.currentState!.validate()) {
      registerFormKey.currentState!.save();

      bool isLogged = false;
      await showDialogWaiting(context, () async {
        try {
          await authProvider.register(
              authProvider.user.email, password, imageFile!);
          isLogged = true;
        } catch (e) {
          Fluttertoast.showToast(msg: e.toString());
        }
      });
      if (!isLogged) return;
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(languages.register),
      ),
      body: Form(
        key: registerFormKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (imageFile != null)
                      Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                        height: 64,
                      ),
                    const SizedBox(width: 12),
                    TextButton(
                      child: Text(languages.pickPicture),
                      onPressed: () async {
                        final image =
                            await ImagePickerHelper.instance.pickImage();

                        if (image != null) {
                          setState(() {
                            imageFile = image;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: languages.name,
                  ),
                  validator: (value) => checkEmpty(value, languages.enterValue),
                  onSaved: (value) {
                    value = value!.trim();
                    authProvider.user.name = value;
                  },
                  onFieldSubmitted: (value) {
                    _emailFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: languages.email,
                  ),
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => checkEmpty(value, languages.enterValue),
                  onSaved: (value) {
                    value = value!.trim();
                    authProvider.user.email = value;
                  },
                  onFieldSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: languages.password,
                  ),
                  obscureText: true,
                  validator: (value) => checkEmpty(value, languages.enterValue),
                  focusNode: _passwordFocusNode,
                  onSaved: (value) {
                    value = value!.trim();
                    password = value;
                  },
                  onFieldSubmitted: (value) {
                    _phoneNumberFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: languages.phoneNumber,
                  ),
                  keyboardType: TextInputType.phone,
                  focusNode: _phoneNumberFocusNode,
                  validator: (value) {
                    value = value!.trim();
                    if (value.isEmpty) {
                      return languages.enterValue;
                    }

                    if (value.length != 10) {
                      return languages.phoneNumberMustBeTen;
                    }

                    return null;
                  },
                  onSaved: (value) {
                    value = value!.trim();
                    authProvider.user.phoneNumber = value;
                  },
                  onFieldSubmitted: (value) {
                    _idNumberFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: languages.idNumber,
                  ),
                  focusNode: _idNumberFocusNode,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    value = value!.trim();
                    if (value.isEmpty) {
                      return languages.enterValue;
                    }

                    if (value.length != 10) {
                      return languages.idNumberMustBeTen;
                    }

                    return null;
                  },
                  onSaved: (value) {
                    value = value!.trim();
                    authProvider.user.idNumber = value;
                  },
                  onFieldSubmitted: (value) async {
                    await submitForm(languages);
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => submitForm(languages),
                  child: Text(languages.register),
                ),
                const SizedBox(height: 48),
                TextButton(
                  child: Text(languages.alreadyHaveAccountLogin),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

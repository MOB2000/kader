import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kader/helpers/helpers.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/gender.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/screens/auth/login_screen.dart';
import 'package:kader/screens/home_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'RegisterScreen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

String? checkEmpty(String? value, String whenEmpty) {
  value = value!.trim();
  if (value.isEmpty) {
    return whenEmpty;
  }
  return null;
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerFormKey = GlobalKey<FormState>();

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    // TODO: use focus node and submit
    // TODO:
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(languages.register),
      ),
      body: Form(
        key: registerFormKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              if (imageFile != null)
                Expanded(
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              TextButton(
                child: const Text('اختر صورة'),
                onPressed: () async {
                  //TODO: extract to class
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    setState(() {
                      imageFile = File(image.path);
                    });
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: languages.name,
                ),
                validator: (value) => checkEmpty(value, 'ادخل الاسم'),
                onSaved: (value) {
                  value = value!.trim();
                  authProvider.user = authProvider.user.copyWith(name: value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: languages.email,
                ),
                validator: (value) => checkEmpty(value, 'ادخل الايميل'),
                onSaved: (value) {
                  value = value!.trim();
                  authProvider.user = authProvider.user.copyWith(email: value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: languages.password,
                ),
                validator: (value) => checkEmpty(value, 'ادخل كلمة المرور'),
                onSaved: (value) {
                  value = value!.trim();
                  authProvider.user =
                      authProvider.user.copyWith(password: value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: languages.phoneNumber,
                ),
                validator: (value) => checkEmpty(value, 'ادخل رقم الجوال'),
                onSaved: (value) {
                  value = value!.trim();
                  authProvider.user =
                      authProvider.user.copyWith(phoneNumber: value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: languages.idNumber,
                ),
                validator: (value) => checkEmpty(value, 'ادخل رقم الهوية'),
                onSaved: (value) {
                  value = value!.trim();
                  authProvider.user =
                      authProvider.user.copyWith(idNumber: value);
                },
              ),
              Row(
                children: <Widget>[
                  Text(languages.gender),
                  Expanded(
                    child: RadioListTile<Gender>(
                      title: Text(languages.male),
                      value: Gender.male,
                      groupValue: authProvider.user.gender,
                      onChanged: (value) {
                        setState(() {
                          authProvider.user =
                              authProvider.user.copyWith(gender: value);
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<Gender>(
                      value: Gender.female,
                      groupValue: authProvider.user.gender,
                      onChanged: (value) {
                        setState(() {
                          authProvider.user =
                              authProvider.user.copyWith(gender: value);
                        });
                      },
                      title: Text(languages.female),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                child: Text(languages.register),
                onPressed: () async {
                  if (imageFile == null) {
                    Fluttertoast.showToast(msg: "يجب اختيار صورة");
                    return;
                  }
                  if (registerFormKey.currentState!.validate()) {
                    registerFormKey.currentState!.save();

                    bool isLogged = false;
                    await showDialogWaiting(context, () async {
                      try {
                        await authProvider.register(imageFile!);
                        isLogged = true;
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    });
                    if (!isLogged) return;
                    if (!mounted) return;
                    Navigator.of(context)
                        .pushReplacementNamed(HomeScreen.routeName);
                  }
                },
              ),
              const Spacer(flex: 2),
              TextButton(
                child: const Text('لديك حساب؟ قم بتسجيل الدخول'),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

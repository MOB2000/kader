import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/screens/auth/register_screen.dart';
import 'package:kader/screens/home_screen.dart';
import 'package:kader/services/helpers.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  String email = '';

  String password = '';

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.login),
      ),
      body: Form(
        key: _loginFormKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'الايميل',
                ),
                validator: (value) => checkEmpty(value, 'ادخل الايميل'),
                onSaved: (value) {
                  value = value!.trim();
                  email = value;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                ),
                validator: (value) => checkEmpty(value, 'ادخل كلمة المرور'),
                onSaved: (value) {
                  value = value!.trim();
                  password = value;
                },
              ),
              const SizedBox(height: 24),
              TextButton(
                child: Text(languages.login),
                onPressed: () async {
                  if (_loginFormKey.currentState!.validate()) {
                    _loginFormKey.currentState!.save();
                    bool isLogged = false;
                    await showDialogWaiting(context, () async {
                      try {
                        await authProvider.login(email, password);
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
              TextButton(
                child: Text(languages.register),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(RegisterScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

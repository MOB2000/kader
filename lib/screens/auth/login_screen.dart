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

  final _passwordFocusNode = FocusNode();

  Future<void> login() async {
    final authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

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
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              const Spacer(),
              TextFormField(
                decoration: InputDecoration(
                  labelText: languages.email,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => checkEmpty(value, languages.enterValue),
                onSaved: (value) => email = value!.trim(),
                onFieldSubmitted: (value) => _passwordFocusNode.requestFocus(),
              ),
              const SizedBox(height: 18),
              TextFormField(
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  labelText: languages.password,
                ),
                onFieldSubmitted: (value) async => await login(),
                obscureText: true,
                validator: (value) => checkEmpty(value, languages.enterValue),
                onSaved: (value) => password = value!.trim(),
              ),
              const Spacer(),
              TextButton(
                onPressed: login,
                child: Text(languages.login),
              ),
              const Spacer(),
              TextButton(
                child: Text(languages.register),
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(RegisterScreen.routeName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

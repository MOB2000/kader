import 'package:flutter/material.dart';
import 'package:kader/constants/images.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/screens/auth/login_screen.dart';
import 'package:kader/screens/complaints_screen.dart';
import 'package:kader/services/shared_preferences.dart';
import 'package:kader/widgets/locale_widget.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final account = SharedPrefs.instance.account;
    final languages = Languages.of(context);

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 8,
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  Images.logo,
                  width: 64,
                  height: 64,
                ),
                const SizedBox(width: 8),
                Text(account.name),
              ],
            ),
          ),
          DrawerListTile(
            icon: Image.asset(
              Images.complaints,
              height: 24,
              width: 24,
            ),
            title: languages.complaints,
            onTap: () async {
              Navigator.pushNamed(context, ComplaintsScreen.routeName);
            },
          ),
          const LocaleWidget(),
          DrawerListTile(
            icon: const Icon(Icons.logout),
            title: languages.logout,
            onTap: () async {
              await SharedPrefs.instance.setIsLogged(false);
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      style: ListTileStyle.drawer,
      onTap: onTap,
      leading: icon,
      title: Text(title),
    );
  }
}

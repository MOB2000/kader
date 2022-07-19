import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/localization/language_data.dart';
import 'package:kader/localization/locale_constant.dart';

class LocaleWidget extends StatefulWidget {
  const LocaleWidget({Key? key}) : super(key: key);

  @override
  State<LocaleWidget> createState() => _LocaleWidgetState();
}

class _LocaleWidgetState extends State<LocaleWidget> {
  LanguageData languageData = languageList.first;

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      style: ListTileStyle.drawer,
      leading: const Icon(Icons.language),
      title: Text(languages.appLanguage),
      trailing: DropdownButton<LanguageData>(
        alignment: AlignmentDirectional.centerStart,
        iconSize: 30,
        onChanged: (language) async {
          setState(() {
            languageData = language!;
          });

          await changeLanguage(context, languageData);
        },
        value: languageData,
        items: languageList
            .map<DropdownMenuItem<LanguageData>>(
              (languageData) => DropdownMenuItem<LanguageData>(
                value: languageData,
                child: Text(languageData.name),
              ),
            )
            .toList(),
      ),
    );
  }
}

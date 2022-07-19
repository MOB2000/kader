import 'package:flutter/widgets.dart';
import 'package:kader/localization/language/languages.dart';

class WhenEmptyWidget extends StatelessWidget {
  const WhenEmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Center(child: Text(languages.noData));
  }
}

import 'package:flutter/material.dart';
import 'package:kader/constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  final double? value;

  const LoadingWidget({
    Key? key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        value: value,
        strokeWidth: 6,
        valueColor: AlwaysStoppedAnimation(kMainColor.withOpacity(0.8)),
      ),
    );
  }
}

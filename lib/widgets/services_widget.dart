import 'package:flutter/material.dart';
import 'package:kader/widgets/service_widget.dart';

class ServicesWidget extends StatelessWidget {
  final List<ServiceWidget> children;

  const ServicesWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      children: children,
    );
  }
}

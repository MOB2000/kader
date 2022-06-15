import 'package:flutter/material.dart';
import 'package:kader/constants/colors.dart';
import 'package:kader/constants/images.dart';

class EVacationServiceWidget extends StatelessWidget {
  final String name;
  final String routeName;

  const EVacationServiceWidget({
    Key? key,
    required this.name,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Container(
        height: 57,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 57,
              padding: const EdgeInsetsDirectional.only(start: 15),
              child: Image.asset(
                Images.eVacationService,
                height: 19,
                width: 16,
              ),
            ),
            const SizedBox(width: 11),
            Center(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  color: kTextListColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

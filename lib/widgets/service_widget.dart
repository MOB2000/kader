import 'package:flutter/material.dart';
import 'package:kader/constants/colors.dart';

class ServiceWidget extends StatelessWidget {
  final String name;
  final String routeName;
  final String image;
  final Color? color;

  const ServiceWidget({
    Key? key,
    required this.name,
    required this.routeName,
    required this.image,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Stack(
        children: <Widget>[
          Container(
            width: 120,
            height: 95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 25),
              child: Image.asset(
                image,
                width: 26,
                height: 26,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              alignment: AlignmentDirectional.center,
              height: 25,
              decoration: BoxDecoration(
                color: color ?? kMainColor,
                borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(16),
                  bottomStart: Radius.circular(16),
                ),
              ),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

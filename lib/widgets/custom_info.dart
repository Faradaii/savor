import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

var imageInfo = {
  "error": "assets/images/error_1.svg",
  "search": "assets/images/search_1.svg",
  "empty": "assets/images/empty_1.svg",
};

class CustomInfo extends StatelessWidget {
  final String message;
  final String typeInfo;

  const CustomInfo({
    super.key,
    required this.message,
    required this.typeInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: SvgPicture.asset(
            width: MediaQuery.of(context).size.width * 0.5,
            imageInfo[typeInfo].toString(),
          ),
        ),
        Text(message),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgPicture extends StatelessWidget {
  final String imagePath;
  const CustomSvgPicture({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.secondary,
        BlendMode.srcIn,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgPicture extends StatelessWidget {
  final String imagePath;
  final bool withColorFilter;
  final double? width;
  final double? height;

  const CustomSvgPicture({
    super.key,
    required this.imagePath,
    this.withColorFilter = true,
    this.width,
    this.height
  });

  // Named Constructor
  const CustomSvgPicture.withoutColor({super.key, required this.imagePath, this.width, this.height})
    : withColorFilter = false;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      height: height,
      width: width,
      colorFilter: withColorFilter
          ? ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}

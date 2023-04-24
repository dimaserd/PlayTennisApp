import 'package:flutter/material.dart';
import 'package:play_tennis/main-settings.dart';

class ServerLogoImage extends StatelessWidget {
  final double height;
  const ServerLogoImage({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image(
      height: height,
      width: height,
      image: const NetworkImage(
        ServerImages.logoPath,
      ),
    );
  }
}

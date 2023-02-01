import 'package:flutter/material.dart';
import 'ImageViewWidget.dart';

class CrocoAppImage extends StatelessWidget {
  final int imageFileId;

  const CrocoAppImage({
    super.key,
    required this.imageFileId,
  });

  @override
  Widget build(BuildContext context) {
    return imageView();
  }

  Widget ordinary() {
    return Image(
      image:
          NetworkImage(ImageViewWidgetExtensions.buildMediumUrl(imageFileId)),
    );
  }

  Widget imageView() {
    return ImageViewWidget(fileId: imageFileId);
  }
}

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../main-settings.dart';
import '../Loading.dart';

class ImageViewWidgetExtensions {
  static String buildOriginalUrl(int fileId) {
    return '${MainSettings.domain}/FileCopies/Images/Original/$fileId.jpg';
  }

  static String buildMediumUrl(int fileId) {
    return '${MainSettings.domain}/FileCopies/Images/Medium/$fileId.jpg';
  }

  static Scaffold getScaffold(String originalUrl) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      appBar: AppBar(
        title: const Text("Просмотр изображения"),
      ),
      body: ImageViewRouteWrapper(
        imageProvider: NetworkImage(
          originalUrl,
        ),
        loadingBuilder: (context, event) {
          if (event == null) {
            return const Center(
              child: Text("Загрузка изображения"),
            );
          }

          final value = event.cumulativeBytesLoaded /
              (event.expectedTotalBytes ?? event.cumulativeBytesLoaded);

          final percentage = (100 * value).floor();

          return Center(
            child: Loading(text: "Загрузка изображения $percentage%"),
          );
        },
      ),
    );
  }
}

class ImageViewWidget extends StatelessWidget {
  final int fileId;

  const ImageViewWidget({super.key, required this.fileId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/show-image/$fileId');
      },
      child: Image(
        image: NetworkImage(ImageViewWidgetExtensions.buildMediumUrl(fileId)),
      ),
    );
  }
}

class ImageViewRouteWrapper extends StatelessWidget {
  const ImageViewRouteWrapper({
    super.key,
    this.imageProvider,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialScale,
    this.basePosition = Alignment.center,
    this.filterQuality = FilterQuality.none,
    this.disableGestures,
    this.errorBuilder,
  });

  final ImageProvider? imageProvider;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final dynamic initialScale;
  final Alignment basePosition;
  final FilterQuality filterQuality;
  final bool? disableGestures;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          loadingBuilder: loadingBuilder,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          initialScale: initialScale,
          basePosition: basePosition,
          filterQuality: filterQuality,
          disableGestures: disableGestures,
          errorBuilder: errorBuilder,
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:photo_view/photo_view.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ImageViewWidgetExtensions {
  static String? publicImageUrlFormat;

  static void setImageUrl(String? image) {
    publicImageUrlFormat = image;
  }

  static String _buildUrl(int fileId, String sizeType) {
    if (publicImageUrlFormat != null && publicImageUrlFormat!.isNotEmpty) {
      return publicImageUrlFormat!
          .replaceAll("{sizeType}", sizeType)
          .replaceAll("{fileId}", fileId.toString());
    } else {
      return '${MainSettings.domain}/FileCopies/Images/$sizeType/$fileId.png';
    }
  }

  static String buildOriginalUrl(int fileId) {
    return _buildUrl(fileId, "Original");
  }

  static String buildMediumUrl(int fileId) {
    return _buildUrl(fileId, "Medium");
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

class ImageViewWidget extends StatefulWidget {
  final int fileId;

  const ImageViewWidget({super.key, required this.fileId});

  @override
  State<ImageViewWidget> createState() => _ImageViewWidgetState();
}

class _ImageViewWidgetState extends State<ImageViewWidget> {
  late Future<Image> _imageFuture;
  Image? _cachedImage;

  @override
  void initState() {
    super.initState();

    if (_cachedImage == null) {
      _imageFuture = _loadAndCorrectImage(
              ImageViewWidgetExtensions.buildMediumUrl(widget.fileId))
          .then((image) {
        /// Cache the image
        _cachedImage = image;
        return image;
      });
    } else {
      /// If cached, return a completed future with the cached image
      _imageFuture = Future.value(_cachedImage);
    }
  }

  Future<Image> _loadAndCorrectImage(String url) async {
    /// Fetch the image from the server
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      /// Save the image temporarily to a file
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/temp_image_${widget.fileId}.png');
      await tempFile.writeAsBytes(response.bodyBytes);

      try {
        File correctedFile =
            await FlutterExifRotation.rotateImage(path: tempFile.path);
        Uint8List correctedBytes = await correctedFile.readAsBytes();
        return Image.memory(correctedBytes, width: 350, height: 500);
      } catch (e) {
        print('Error rotating image: $e');
        return Image.memory(response.bodyBytes, width: 350, height: 500);
      }
    }
    throw Exception('Failed to load image');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/show-image/${widget.fileId}');
      },
      child: FutureBuilder<Image>(
        future: _imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return const Text('Error loading image');
          } else {
            return snapshot.data!;
          }
        },
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

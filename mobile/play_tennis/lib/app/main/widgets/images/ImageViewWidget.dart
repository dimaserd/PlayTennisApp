import 'dart:io';
import 'package:exif_reader/exif_reader.dart' as exif_reader;
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:play_tennis/app/main/widgets/Loading.dart';
import 'package:play_tennis/main-settings.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image/image.dart' as img;

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

  static String buildThumbnailUrl(int fileId) {
    return _buildUrl(fileId, "Small");
  }

  static Scaffold getScaffold(String originalUrl) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      appBar: AppBar(
        title: const Text("Просмотр изображения"),
      ),
      body: ImageViewRouteWrapper(
        imageProvider: NetworkImage(originalUrl),
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
              ImageViewWidgetExtensions.buildThumbnailUrl(widget.fileId))
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
      try {
        /// Save the image temporarily to a file
        final tempDir = Directory.systemTemp;
        final tempFile =
            File('${tempDir.path}/temp_image_${widget.fileId}.png');
        await tempFile.writeAsBytes(response.bodyBytes);

        /// Read EXIF data from the image
        final tags =
            await exif_reader.readExifFromBytes(await tempFile.readAsBytes());

        /// Load the image
        img.Image? image = img.decodeImage(response.bodyBytes);

        if (image == null) throw Exception("Error decoding the image");

        if (tags.isNotEmpty) {
          String? orientation = tags['Image Orientation']?.toString();

          /// Rotate the image based on EXIF orientation
          if (orientation != null) {
            switch (orientation) {
              case 'Mirrored vertical':
                image = img.copyRotate(image, angle: 180);
                break;
              case 'Rotated 90 CW':
                image = img.copyRotate(image, angle: 90);
                break;
            }

            /// Convert the rotated image back to bytes
            Uint8List correctedBytes = Uint8List.fromList(img.encodePng(image));
            return Image.memory(correctedBytes);
          }
        }

        /// If no orientation tag, return the original image
        return Image.memory(response.bodyBytes);
      } catch (e) {
        print('Error reading EXIF or rotating image: $e');
        return Image.memory(response.bodyBytes);
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error loading image: ${snapshot.error}');
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
    this.filterQuality = FilterQuality.low,
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

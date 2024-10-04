import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:sensors_plus/sensors_plus.dart';

class TakePhotoScreen extends StatefulWidget {
  const TakePhotoScreen({super.key});

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  XFile? _imageFile;

  late CameraDescription selectedCamera;
  late List<CameraDescription> cameras;
  bool isVertical = true;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _listenToOrientation();
  }

  void _listenToOrientation() {
    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      if (event.x.abs() > event.y.abs()) {
        if (mounted) {
          setState(() {
            isVertical = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isVertical = true;
          });
        }
      }
    });
  }

  Future<void> _initializeCamera({CameraDescription? theSelectedCamera}) async {
    try {
      cameras = await availableCameras();
      selectedCamera = theSelectedCamera ?? cameras.first;

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<XFile> rotate(image, imagePath) async {
    final imageBytes = await File(image.path).readAsBytes();
    img.Image capturedImage = img.decodeImage(imageBytes)!;

    if (!isVertical) {
      capturedImage = img.copyRotate(capturedImage, angle: 90);
    }

    double targetAspectRatio = 3 / 4;

    double currentAspectRatio = capturedImage.width / capturedImage.height;

    if (currentAspectRatio > targetAspectRatio) {
      int newWidth = (capturedImage.height * targetAspectRatio).toInt();
      int offsetX = (capturedImage.width - newWidth) ~/ 2;
      capturedImage = img.copyCrop(capturedImage,
          x: offsetX, y: 0, width: newWidth, height: capturedImage.height);
    } else if (currentAspectRatio < targetAspectRatio) {
      int newHeight = (capturedImage.width / targetAspectRatio).toInt();
      int offsetY = (capturedImage.height - newHeight) ~/ 2;
      capturedImage = img.copyCrop(capturedImage,
          x: 0, y: offsetY, width: capturedImage.width, height: newHeight);
    }
    int targetWidth = 800;
    int targetHeight = (targetWidth / targetAspectRatio).toInt();

    img.Image resizedImage = img.copyResize(
      capturedImage,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.linear,
    );

    final jpgBytes = img.encodeJpg(resizedImage);
    File imageFile = await File(imagePath).writeAsBytes(jpgBytes);
    return XFile(imageFile.path);
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Controller is not initialized');
      return;
    }

    try {
      await _initializeControllerFuture;

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, '${DateTime.now()}.jpg');

      XFile image = await _controller!.takePicture();
      XFile imageFile = await rotate(image, imagePath);
      setState(() {
        _imageFile = XFile(imageFile.path);
      });
      _controller!.dispose();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Container()),
      body: Column(
        children: [
          Expanded(
            child: _initializeControllerFuture == null
                ? const Center(child: CircularProgressIndicator())
                : _imageFile == null
                    ? FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            /// If the Future is complete, display the camera preview.
                            return CameraPreview(_controller!);
                          } else {
                            /// Otherwise, display a loading indicator.
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      )
                    : Image.file(File(_imageFile!.path)),
          ),
          _imageFile != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        Navigator.of(context).pop([_imageFile?.path]);
                      },
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios_outlined),
                      onPressed: () async {
                        await _initializeCamera(
                            theSelectedCamera: (selectedCamera == cameras.first)
                                ? cameras.last
                                : cameras.first);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        _takePicture();
                      },
                    )
                  ],
                ),
        ],
      ),
    );
  }
}

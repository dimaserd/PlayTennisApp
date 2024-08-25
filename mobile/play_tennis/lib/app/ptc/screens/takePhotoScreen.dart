import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Controller is not initialized');
      return;
    }

    try {
      await _initializeControllerFuture;

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, '${DateTime.now()}.png');

      XFile image = await _controller!.takePicture();
      setState(() {
        _imageFile = image;
      });

      await image.saveTo(imagePath);

      /// Close the camera after taking the picture
      _controller!.dispose();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
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

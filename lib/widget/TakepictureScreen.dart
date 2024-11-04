import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Import ini diperlukan untuk mengakses file gambar

class TakepictureScreen extends StatefulWidget {
  const TakepictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakepictureScreenState createState() => TakepictureScreenState();
}

class TakepictureScreenState extends State<TakepictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? imagePath; // Menyimpan jalur gambar yang diambil

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller), // Tampilkan tampilan kamera
                if (imagePath != null) // Jika ada gambar yang diambil
                  Center(
                    child: Image.file(
                      File(imagePath!), // Tampilkan gambar yang diambil
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            setState(() {
              imagePath = image.path; // Simpan jalur gambar yang diambil
            });
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

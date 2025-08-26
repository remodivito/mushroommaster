import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mushroom_master/navigation/nav_bar.dart';
import 'package:camera/camera.dart';
import 'package:mushroom_master/scanner/process_image.dart';
import 'package:mushroom_master/utils/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  final ImagePicker _picker = ImagePicker();
  bool _hasShownPermissionDialog = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionOnce().then((_) {
      initCamera();
    });
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.medium);
    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _checkPermissionOnce() async {
    if (_hasShownPermissionDialog) return;

    final prefs = await SharedPreferences.getInstance();
    final hasGrantedPermission = prefs.getBool('camera_permission_granted') ?? false;

    if (hasGrantedPermission) {
      final status = await Permission.camera.status;
      if (status.isGranted) {
        return;
      }
    }

    final status = await Permission.camera.status;
    if (!status.isGranted) {
      var statuses = await [
        Permission.camera,
        Permission.photos,
      ].request();

      if (statuses[Permission.camera] == PermissionStatus.granted) {
        await prefs.setBool('camera_permission_granted', true);
      }
    }

    _hasShownPermissionDialog = true;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mushroom Scanner'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _controller == null || !_controller!.value.isInitialized
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: AppTheme.primaryColor,
              ),
            )
          : Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
                child: CameraPreview(_controller!),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () async {
                try {
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Classify(image: File(image.path)),
                      ),
                    );
                  }
                } catch (e) {
                  log(e.toString());
                }
              },
              heroTag: 'galleryButton',
              backgroundColor: AppTheme.secondaryColor,
              child: const Icon(Icons.photo_library, color: Colors.white),
            ),
            const SizedBox(width: AppTheme.spacingL),
            FloatingActionButton.large(
              onPressed: () async {
                try {
                  var picture = await _controller!.takePicture();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Classify(image: File(picture.path)),
                      ),
                    );
                  }
                } catch (e) {
                  log(e.toString());
                }
              },
              heroTag: 'cameraButton',
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 36),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

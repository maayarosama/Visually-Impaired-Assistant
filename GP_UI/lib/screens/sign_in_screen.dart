import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/widget/app_bar.dart';
import 'package:best_flutter_ui_templates/screens/navigation_home_screen.dart';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/screens/admin_screen.dart';
import './sign_up_screen.dart';
import 'package:best_flutter_ui_templates/authentication_service.dart';
import 'dart:async';
import 'package:best_flutter_ui_templates/widget/FacePainter.dart';
import 'package:best_flutter_ui_templates/widget/auth-action-button.dart';
import 'package:best_flutter_ui_templates/services/camera.service.dart';
import 'package:best_flutter_ui_templates/services/facenet.service.dart';
import 'package:best_flutter_ui_templates/services/ml_vision_service.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:path/path.dart' show join;
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SignInPage extends StatefulWidget {
  final CameraDescription cameraDescription;

  const SignInPage({
    Key key,
    @required this.cameraDescription,
  }) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignInPage> {
  /// Service injection
  CameraService _cameraService = CameraService();
  MLVisionService _mlVisionService = MLVisionService();
  FaceNetService _faceNetService = FaceNetService();

  Future _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _saving = false;
  bool _bottomSheetVisible = false;

  String imagePath;
  Size imageSize;
  Face faceDetected;

  @override
  void initState() {
    super.initState();

    /// starts the camera & start framing faces
    _start();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }

  /// draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlVisionService.getFacesFromImage(image);

          if (faces != null) {
            if (faces.length > 0) {
              // preprocessing the image
              setState(() {
                faceDetected = faces[0];
              });

              if (_saving) {
                _saving = false;
                _faceNetService.setCurrentPrediction(image, faceDetected);
              }
            } else {
              setState(() {
                faceDetected = null;
              });
            }
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  /// handles the button pressed event
  Future<void> onShot() async {
    if (faceDetected == null) {
      showDialog(
          context: context,
          child: AlertDialog(
            content: Text('No face detected!'),
          ));

      return false;
    } else {
      imagePath =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      _saving = true;

      await Future.delayed(Duration(milliseconds: 500));
      await _cameraService.cameraController.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
      await _cameraService.takePicture(imagePath);

      setState(() {
        _bottomSheetVisible = true;
        pictureTaked = true;
      });

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (pictureTaked) {
              return Container(
                width: width,
                child: Transform(
                    alignment: Alignment.center,
                    child: Image.file(File(imagePath)),
                    transform: Matrix4.rotationY(mirror)),
              );
            } else {
              return Transform.scale(
                scale: 1.0,
                child: AspectRatio(
                  aspectRatio: MediaQuery.of(context).size.aspectRatio,
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Container(
                        width: width,
                        height: width /
                            _cameraService.cameraController.value.aspectRatio,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            CameraPreview(_cameraService.cameraController),
                            CustomPaint(
                              painter: FacePainter(
                                  face: faceDetected, imageSize: imageSize),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !_bottomSheetVisible
          ? AuthActionButton(
              _initializeControllerFuture,
              onPressed: onShot,
              isLogin: true,
            )
          : Container(),
    );
  }
}

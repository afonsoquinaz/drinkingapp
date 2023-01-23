import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:camera/camera.dart';
import 'package:drinkingapp/Game.dart';
import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_watermark/image_watermark.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.photoQuestionText,
    required this.cameras,
    required this.questionsManager,
    required this.players,
    required this.playersInPhoto,
  });

  final String photoQuestionText;
  final List<UserClass> playersInPhoto;
  final List<UserClass> players;
  final List<CameraDescription> cameras;
  final QuestionsManager questionsManager;

  @override
  TakePictureScreenState createState() => TakePictureScreenState(
      questionsManager: questionsManager,
      players: players,
      playersInPhoto: playersInPhoto,
      photoQuestionText: photoQuestionText);
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final List<UserClass> playersInPhoto;
  final List<UserClass> players;
  final QuestionsManager questionsManager;
  final String photoQuestionText;
  int selectedCamera = 0;
  bool isFlashOn = false;

  TakePictureScreenState(
      {required this.questionsManager,
      required this.players,
      required this.playersInPhoto,
      required this.photoQuestionText});

  initializeCamera(int cameraIndex) async {
    if (cameraIndex == 1) {
      isFlashOn = false;
    }
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras[cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  toggleFlash() async {
    if (isFlashOn) {
      _controller.setFlashMode(FlashMode.off);
    } else {
      _controller.setFlashMode(FlashMode.always);
    }
    isFlashOn = !isFlashOn;
  }

  @override
  void initState() {
    initializeCamera(selectedCamera);
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < playersInPhoto.length; i++)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: playersInPhoto[i].photoPath.contains('avatar')
                              ? AssetImage(playersInPhoto[i].photoPath)
                              : Image.file(File(playersInPhoto[i].photoPath))
                                  .image,
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                        //border: Border.all(color: Colors.yellow.shade700, width: 3),
                        color: Colors.yellow.shade700,
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                photoQuestionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          //SizedBox(width: 100,),
          Container(
              width: size,
              height: size,
              child: ClipRect(
                  child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                              height: 1,
                              child: FutureBuilder<void>(
                                future: _initializeControllerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return AspectRatio(
                                        aspectRatio:
                                            1 / _controller.value.aspectRatio,
                                        child: CameraPreview(_controller));
                                  } else {
                                    // Otherwise, display a loading indicator.
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              )))))),
          SizedBox(
            height: 10,
          ),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(),
                  FloatingActionButton(
                    backgroundColor: Colors.black,
                    // Provide an onPressed callback.
                    onPressed: () {
                      if (selectedCamera == 0) {
                        setState(() {
                          toggleFlash();
                        });
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Can't turn flash on while on selfie mode"),
                          duration: const Duration(seconds: 2),
                        ));
                      }
                    },
                    child: isFlashOn ? const Icon(Icons.flash_on, size: 35) : Icon(Icons.flash_off, size: 35, color: selectedCamera==0 ? Colors.white : Colors.grey.shade500,),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        // Attempt to take a picture and get the file `image`
                        // where it was saved.

                        final image = await _controller.takePicture();
                        if (!mounted) return;

                        ImageProperties properties =
                            await FlutterNativeImage.getImageProperties(
                                image.path);

                        int width = properties.height!;

                        print(properties.height!);
                        print(properties.width!);
                        var offset = (properties.width! - width) / 2;

                        if (Platform.isAndroid) {
                          // Android-specific code
                          print("it is ANDROID");
                          width = properties.height!;
                          offset = (properties.width! - width) / 2;
                          File croppedFile = await FlutterNativeImage.cropImage(
                              image.path, offset.round(), 0, width, width);
                          
                          questionsManager.addPhotoToFeed(croppedFile.path,
                              playersInPhoto, photoQuestionText);
                        } else if (Platform.isIOS) {
                          print("it is iphone");
                          // iOS-specific code
                          width = properties.width!;
                          offset = (properties.height! - width) / 2;
                          File croppedFile = await FlutterNativeImage.cropImage(
                              image.path, 0, offset.round(), width, width);
                          questionsManager.addPhotoToFeed(croppedFile.path,
                              playersInPhoto, photoQuestionText);
                        }

                        //questionsManager.addPhotoToFeed(image.path);

                        if (!mounted) return;
                        await Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => Game(
                                  players: players,
                                  questionsManager: questionsManager)),
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 100,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.black,
                    // Provide an onPressed callback.
                    onPressed: () {
                      if (widget.cameras.length > 1) {
                        setState(() {
                          selectedCamera =
                              selectedCamera == 0 ? 1 : 0; //Switch camera
                          initializeCamera(selectedCamera);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('No secondary camera found'),
                          duration: const Duration(seconds: 2),
                        ));
                      }
                    },
                    child: const Icon(
                      Icons.flip_camera_ios,
                      size: 45,
                    ),
                  ),
                  SizedBox()
                ],
              ),
              Text(
                "Tap for photo",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w200),
              ),
            ],
          ),
          SizedBox()
        ],
      ),
    );
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      //showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (_controller == null) {
      return;
    }

    try {
      await _controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      //_showCameraException(e);
      rethrow;
    }
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:drinkingapp/Game.dart';
import 'package:drinkingapp/Views/CountdownTimer.dart';
import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:vibration/vibration.dart';

// A screen that allows users to take a picture using a given camera.s
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.photoQuestionText,
    required this.cameras,
    required this.questionsManager,
    required this.players,
    required this.playersInPhoto,
    required this.onAcceptPic, required this.isAppOnBackground,
  });

  final String photoQuestionText;
  final List<UserClass> playersInPhoto;
  final List<UserClass> players;
  final List<CameraDescription> cameras;
  final QuestionsManager questionsManager;
  final void Function() onAcceptPic;
  final bool Function() isAppOnBackground;

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
  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 0, seconds: 40);
  int selectedCamera = 0;
  bool isFlashOn = false;
  String? picPath;

  TakePictureScreenState(
      {required this.questionsManager,
      required this.players,
      required this.playersInPhoto,
      required this.photoQuestionText});

  @override
  void initState() {
    initializeCamera(selectedCamera);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    countdownTimer?.cancel();
    super.dispose();
  }

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

    await _initializeControllerFuture;

    if (isFlashOn) {
      _controller.setFlashMode(FlashMode.always);
    } else {
      _controller.setFlashMode(FlashMode.off);
    }
  }

  toggleFlash() async {
    if (isFlashOn) {
      _controller.setFlashMode(FlashMode.off);
    } else {
      _controller.setFlashMode(FlashMode.always);
    }
    isFlashOn = !isFlashOn;
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        Navigator.popUntil(context, ModalRoute.withName('PicQuestion'));
        Navigator.pop(context);
        countdownTimer!.cancel();
      } else {
        vibrate() async {
          if (myDuration.inMinutes < 1 && seconds <= 30) {
            bool? canVibrate = await Vibration.hasVibrator();
            if (canVibrate != null && canVibrate) {
              Vibration.vibrate(duration: 30);
            }
          }
        }
        if (!widget.isAppOnBackground()) {
          vibrate();
        }
        myDuration = Duration(seconds: seconds);
      }
    });
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
              CountdownTimer(myDuration: myDuration),
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
          picPath != null
              ? Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: Image.file(File(picPath!)).image,
                        fit: BoxFit.fill,
                      )),
                )
              : Container(
                  width: size,
                  height: size,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
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
                                            aspectRatio: 1 /
                                                _controller.value.aspectRatio,
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
          picPath != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          widget.questionsManager.addPhotoToFeed(picPath!,
                              widget.playersInPhoto, widget.photoQuestionText);
                          Navigator.pop(context);
                          widget.onAcceptPic();
                        },
                        child: Text("ACCEPT")),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            picPath = null;
                            initializeCamera(selectedCamera);
                          });
                        },
                        child: Text("RETAKE")),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(),
                        FloatingActionButton(
                          heroTag: null,
                          backgroundColor: Colors.black,
                          // Provide an onPressed callback.
                          onPressed: () {
                            if (selectedCamera == 0) {
                              setState(() {
                                toggleFlash();
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Can't turn flash on while on selfie mode"),
                                duration: const Duration(seconds: 2),
                              ));
                            }
                          },
                          child: isFlashOn
                              ? const Icon(Icons.flash_on, size: 35)
                              : Icon(
                                  Icons.flash_off,
                                  size: 35,
                                  color: selectedCamera == 0
                                      ? Colors.white
                                      : Colors.grey.shade500,
                                ),
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

                              var offset = (properties.width! - width) / 2;

                              File? croppedFile;

                              if (Platform.isAndroid) {
                                // Android-specific code
                                print("it is ANDROID");
                                width = properties.height!;
                                offset = (properties.width! - width) / 2;
                                croppedFile =
                                    await FlutterNativeImage.cropImage(
                                        image.path,
                                        offset.round(),
                                        0,
                                        width,
                                        width);
                                // questionsManager.addPhotoToFeed(croppedFile.path,
                                //     playersInPhoto, photoQuestionText);
                              } else if (Platform.isIOS) {
                                print("it is iphone");
                                // iOS-specific code
                                width = properties.width!;
                                offset = (properties.height! - width) / 2;
                                croppedFile =
                                    await FlutterNativeImage.cropImage(
                                        image.path,
                                        0,
                                        offset.round(),
                                        width,
                                        width);
                              }

                              if (!mounted) return;
                              setState(() {
                                picPath = croppedFile!.path;
                                _controller.dispose();
                              });
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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

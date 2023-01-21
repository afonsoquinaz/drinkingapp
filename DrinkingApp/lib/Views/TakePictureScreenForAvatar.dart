import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:camera/camera.dart';
import 'package:drinkingapp/Game.dart';
import 'package:drinkingapp/questionsManager/UserClass.dart';
import 'package:drinkingapp/questionsManager/questionsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreenForAvatar extends StatefulWidget {
  const TakePictureScreenForAvatar({
    super.key,
    required this.camera,
    required this.player,
    required this.changePhoto
  });

  final CameraDescription camera;
  final UserClass player;
  final Function changePhoto;

  @override
  TakePictureScreenForAvatarState createState() => TakePictureScreenForAvatarState();
}

class TakePictureScreenForAvatarState extends State<TakePictureScreenForAvatar> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int isFlashOn = 0;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
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

    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Column(
            children: [
              SizedBox(height: 50,),
              const Text(
                "DrinkingApp",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w200),
              ),
              SizedBox(height: 10,),
              const Text(
                "Take a picture for your avatar",
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
              child: ClipOval(

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
                    heroTag: null,
                    backgroundColor: Colors.black,
                    // Provide an onPressed callback.
                    onPressed: () async {
                      if (isFlashOn == 0) {
                        isFlashOn = 1;
                        _controller != null
                            ? () => onSetFlashModeButtonPressed(FlashMode.always)
                            : null;
                      } else if (isFlashOn == 1) {
                        print("oi");
                        isFlashOn = 0;
                        _controller != null
                            ? () => onSetFlashModeButtonPressed(FlashMode.off)
                            : null;
                      }
                    },
                    child: const Icon(Icons.flash_on , size: 35,),
                  ),
                  GestureDetector(
                    onTap:  () async {
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
                        await FlutterNativeImage.getImageProperties(image.path);

                        int width = properties.height!;

                        print(properties.height!);
                        print(properties.width!);
                        var offset = (properties.width! - width) / 2;

                        File? croppedFile;

                        if (Platform.isAndroid) {
                          // Android-specific code
                          print("it is ANDROID");
                          width = properties.height!;
                          offset = (properties.width! - width) / 2;
                          croppedFile = await FlutterNativeImage.cropImage(
                              image.path, offset.round(), 0, width, width);

                        } else if (Platform.isIOS) {
                          print("it is iphone");
                          // iOS-specific code
                          width = properties.width!;
                          offset = (properties.height! - width) / 2;
                          croppedFile = await FlutterNativeImage.cropImage(
                              image.path, 0 , offset.round() , width , width );
                        }


                        //questionsManager.addPhotoToFeed(image.path);

                        if (!mounted) return;
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                              // Pass the automatically generated path to
                              // the DisplayPictureScreen widget.
                              imagePath: croppedFile!.path,
                              player: widget.player,
                              changePhoto: widget.changePhoto,
                            ),
                          ),
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
                        SizedBox(height: 50,)
                      ],
                    ),
                  ),



                  FloatingActionButton(
                    backgroundColor: Colors.black,
                    // Provide an onPressed callback.
                    onPressed: () async {},
                    child: const Icon(Icons.refresh ,size: 45,),
                  ),
                  SizedBox()
                ],
              ),
              Text(
                "Tap for photo, hold for video",
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
  final UserClass player;
  final Function changePhoto;

  const DisplayPictureScreen({super.key, required this.imagePath, required this.player, required this.changePhoto});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(height: 50,),
                const Text(
                  "DrinkingApp",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w200),
                ),
                SizedBox(height: 10,),
                const Text(
                  "Preview your avatar picture",
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
            Container(
        width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle,
              image: DecorationImage(
                image: Image.file(File(imagePath)).image,
                fit: BoxFit.fill,
              )
          ),
    ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              TextButton(onPressed: () {changePhoto(imagePath); Navigator.pop(context); Navigator.pop(context);}, child: Text("ACCEPT")),
              TextButton(onPressed: () {Navigator.pop(context);}, child: Text("RETAKE")),
            ],)
          ]));
  }
}

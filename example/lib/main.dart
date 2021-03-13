import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pip/flutter_pip.dart';
import 'package:flutter_pip/models/pip_ratio.dart';
import 'package:flutter_pip/platform_channel/channel.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Video Player Controller
  VideoPlayerController controller;

  // Pip Indicator Text
  String pipStatus = "Not in PiP mode.";

  // PiP Status
  bool isInPictureInPictureMode = false;

  void updateUI(bool pipMode) {
    if (pipMode == true) {
      setState(() {
        isInPictureInPictureMode = true;
        pipStatus = "Current on PiP mode.";
      });
    } else {
      setState(() {
        isInPictureInPictureMode = false;
        pipStatus = "Got out of PiP mode.";
      });
    }
  }

  @override
  void initState() {
    controller = VideoPlayerController.network(
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    )..initialize().then((value) {
      controller.play();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PipWidget(
        onResume: (bool pipMode) {
          updateUI(pipMode);
        },
        onSuspending: () {
          FlutterPip.enterPictureInPictureMode().then((result) {
            // Result == 0 means we successfully entered PiP mode
            if (result == 0) {
              updateUI(true);
              controller.play();
            } else {
              // Result != 0 means PiP is most probably not supported
            }
          });
        },
        child: !isInPictureInPictureMode
          ? Scaffold(
              appBar: AppBar(
                title: const Text('Picture in Picture Plugin'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16/9,
                      child: VideoPlayer(
                        controller
                      ),
                    ),
                    Text(pipStatus),
                    TextButton(
                      onPressed: () {
                        FlutterPip.enterPictureInPictureMode().then((result) {
                          // Result == 0 means we successfully entered PiP mode
                          if (result == 0) {
                            updateUI(true);
                          } else {
                            // Result != 0 means PiP is most probably not supported
                          }
                        });
                      },
                      child: Text("Enter Pip Mode")
                    )
                  ],
                ),
              )
            )
          : AspectRatio(
              aspectRatio: 16/9,
              child: VideoPlayer(
                controller
              ),
          ),
      ),
    );
  }
}

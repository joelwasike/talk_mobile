import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_player/video_player.dart';

import '../utils/colors.dart';

class ViewerPage extends StatelessWidget {
  final Medium medium;

  const ViewerPage(this.medium, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColor.maincolor1,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FloatingActionButton(
            backgroundColor: LightColor.secondaycolor,
            mini: true,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(30.0), // Adjust the radius as needed
            ),
            onPressed: () {},
            child: const Text(
              "Post",
              style: TextStyle(
                  color: LightColor.maincolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 0.0)),
          const Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 350,
                  child: medium.mediumType == MediumType.image
                      ? AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.contain,
                              alignment: FractionalOffset.topCenter,
                              image: PhotoProvider(mediumId: medium.id),
                            )),
                          ),
                        )
                      : SizedBox(
                          width: 200,
                          child: VideoProvider(
                            mediumId: medium.id,
                          ),
                        )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 3, left: 5),
                  height: 200,
                  decoration: BoxDecoration(
                    color: LightColor.maincolor1,
                    border: Border.all(color: LightColor.maincolor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: LightColor.secondaycolor.withOpacity(.2),
                        spreadRadius: .5,
                        blurRadius: .5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const TextField(
                    style: TextStyle(fontSize: 14),
                    //controller: desc,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a caption",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VideoProvider extends StatefulWidget {
  final String mediumId;

  const VideoProvider({
    required this.mediumId,
  });

  @override
  _VideoProviderState createState() => _VideoProviderState();
}

class _VideoProviderState extends State<VideoProvider> {
  VideoPlayerController? _controller;
  File? _file;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
    super.initState();
  }

  Future<void> initAsync() async {
    try {
      _file = await PhotoGallery.getFile(mediumId: widget.mediumId);
      _controller = VideoPlayerController.file(_file!);
      _controller?.initialize().then((_) {
        setState(() {});
      });
    } catch (e) {
      print("Failed : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null || !_controller!.value.isInitialized
        ? Container()
        : Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _controller!.value.isPlaying
                          ? _controller!.pause()
                          : _controller!.play();
                    });
                  },
                  child: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_circle,
                    color: LightColor.background,
                    size: 50,
                  ),
                ),
              ),
            ],
          );
  }
}

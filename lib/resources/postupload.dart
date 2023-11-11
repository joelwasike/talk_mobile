import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:video_player/video_player.dart';

import '../utils/colors.dart';

class ViewerPage extends StatefulWidget {
  final File medium;

  const ViewerPage(this.medium, {super.key});

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  TextEditingController caption = TextEditingController();
  bool isloading = false;

  toast(String message) {
    CherryToast.success(
            title: const Text(""),
            backgroundColor: Colors.black,
            displayTitle: false,
            description: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            animationDuration: const Duration(milliseconds: 500),
            autoDismiss: true)
        .show(context);
  }

  Future<void> uploadPost() async {
    // _file = await PhotoGallery.getFile(mediumId: widget.medium.id);
    setState(() {
      isloading = true;
    });
    print(widget.medium.path);
    try {
      //print("image selected is: ${imagefile!.path}");
      //print("video selected is: ${videoFile!.path}");

      Dio dio = Dio();

      var formData = FormData();

      formData.fields.addAll([
        MapEntry('userid', "1"),
        MapEntry('content', caption.text),
        const MapEntry('username', "davis"),
      ]);

      formData.files.addAll([
        MapEntry(
          'media',
          await MultipartFile.fromFile(widget.medium.path),
        ),
      ]);

      final response = await dio.post(
        '$baseUrl/createpost',
        data: formData,
      );
      //print(jsonDecode(response.data));
      if (response.statusCode == 200) {
        // Handle successful response
        // titleController.clear();
        // descriptionController.clear();
        // setState(() {
        //   imagefile = null;
        // });
        toast('Post uploaded successfully');
      } else {
        // Handle error response
        toast("Error uploading Post");
        print('Error uploading Post: ${response.statusMessage}');
      }
    } catch (e) {
      // Handle exceptions
      toast("Error uploading Post");
      print('Error: $e');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  bool isVideoFilePath(String filePath) {
    final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov', '.wmv'];
    final lowerCaseFilePath = filePath.toLowerCase();

    for (final extension in videoExtensions) {
      if (lowerCaseFilePath.endsWith(extension)) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 10),
        child: SizedBox(
          height: 50,
          width: 50,
          child: FloatingActionButton(
              onPressed: () {
                uploadPost();
              },
              backgroundColor: LightColor.maincolor,
              child: isloading
                  ? const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 20,
                    )
                  : const Text(
                      "Post",
                      style: TextStyle(color: Colors.white),
                    )),
        ),
      ),
      body: ListView(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 0.0)),
          const Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 350,
                  child: !isVideoFilePath(widget.medium.path)
                      ? AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                alignment: FractionalOffset.topCenter,
                                image: FileImage(File(widget.medium
                                    .path)), // Use FileImage with the file path.
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 200,
                          child: VideoProvider(
                            mediumId: widget.medium,
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
                  child: TextField(
                    controller: caption,
                    style: TextStyle(fontSize: 14),
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
  final File mediumId;

  const VideoProvider({
    super.key,
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
      _file = widget.mediumId;
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

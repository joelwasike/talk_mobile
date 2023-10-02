import 'dart:io';
import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usersms/utils/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddGossip extends StatefulWidget {
  const AddGossip({super.key});

  @override
  State<AddGossip> createState() => _AddGossipState();
}

class _AddGossipState extends State<AddGossip> {
  File? imagefile;

//imagepicker
  var picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Uint8List? _videoThumbnail;
  VideoPlayerController? _videoController;
  bool isVideoPlaying = false;
  bool isloading = false;
  File? videoFile;

//pick video
  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        videoFile = File(result.files.single.path!);
      });

      _videoThumbnail = await VideoThumbnail.thumbnailData(
        video: videoFile!.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 100, // Adjust the thumbnail size as needed
        quality: 50, // Adjust the quality of the thumbnail
      );

      _videoController = VideoPlayerController.file(videoFile!)
        ..initialize().then((_) {
          // Ensure the first frame is shown
          setState(() {});
        });
    }
  }

  toast(String message) {
    CherryToast.error(
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

  Future<void> uploadGossip() async {
    setState(() {
      isloading = true;
    });
    try {
      print("image selected is: ${imagefile!.path}");
      print("video selected is: ${videoFile!.path}");

      Dio dio = Dio();

      var formData = FormData();

      formData.fields.addAll([
        MapEntry('title', titleController.text),
        MapEntry('content', descriptionController.text),
        const MapEntry('email', "daviswasike@gmail.com"),
      ]);
      if (imagefile != null) {
         formData.files.addAll([
        MapEntry(
          'photo',
          await MultipartFile.fromFile(imagefile!.path),
        ),
      ]);
      }

       if (videoFile != null) {
         formData.files.addAll([
        MapEntry(
          'video',
          await MultipartFile.fromFile(videoFile!.path),
        ),
      ]);
      }
     

      final response = await dio.post(
        'https://68ff-197-232-22-252.ngrok.io/uploadgossip',
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
        toast('Gossip uploaded successfully');

        print('Gossip uploaded successfully');
      } else {
        // Handle error response
        toast("Error uploading Notice");
        print('Error uploading notice: ${response.statusMessage}');
      }
    } catch (e) {
      // Handle exceptions
      toast("Error uploading Notice");
      print('Error: $e');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height / 10.2,
            decoration: const BoxDecoration(
                color: LightColor.maincolor1,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 30.0,
                        color: LightColor.maincolor,
                      ),
                      Text(
                        "Gallery",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, color: LightColor.maincolor),
                      )
                    ],
                  ),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.pop(context);
                  },
                )),
                Expanded(
                    child: InkWell(
                  child: const SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 30.0,
                          color: LightColor.maincolor,
                        ),
                        Text(
                          "Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: LightColor.maincolor),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.pop(context);
                  },
                ))
              ],
            ),
          );
        });
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Crop",
              toolbarColor: LightColor.maincolor1,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Crop",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imagefile = File(croppedFile.path);
      });
      // reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        iconTheme: const IconThemeData(color: LightColor.background),
        automaticallyImplyLeading: true,
        backgroundColor: LightColor.maincolor1,
        title: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInRight(
                  child: Text('Post a Gossip',
                      style: GoogleFonts.aguafinaScript(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ))),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 10),
        child: SizedBox(
          height: 50,
          width: 50,
          child: FloatingActionButton(
              onPressed: () {
                uploadGossip();
              },
              backgroundColor: LightColor.maincolor,
              child: isloading?const CircularProgressIndicator(color: Colors.white,): const Text(
                "Post",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: ListView(
        children: [
          const Text(
            "  Gossip Title",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "eg. Mr kibu won..",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: LightColor.maincolor1,
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: LightColor.maincolor)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "  Gossip description ",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
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
              child:  TextField(
                style: const TextStyle(fontSize: 14),
                controller: descriptionController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Gossip description here",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    Map<Permission, PermissionStatus> statuses = await [
                      Permission.storage,
                      Permission.camera,
                    ].request();
                    if (statuses[Permission.storage]!.isDenied &&
                        statuses[Permission.camera]!.isDenied) {
                      print('no permission provided');
                    } else {
                      showImagePicker(context);
                    }
                  },
                  child: imagefile == null
                      ? Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: LightColor.maincolor),
                          child: const Icon(
                            Icons.add_a_photo,
                            color: LightColor.background,
                          ),
                        )
                      : SizedBox(
                          width: 115,
                          height: 115,
                          child: Image.file(
                            imagefile!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Text(
                  "     Select a photo",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickVideo();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: LightColor.maincolor),
                        child: const Icon(
                          Icons.video_file,
                          color: LightColor.background,
                        ),
                      ),
                    ),
                    Text(
                      "Select a video",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    if (_videoThumbnail != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isVideoPlaying = !isVideoPlaying;
                            if (isVideoPlaying) {
                              _videoController?.play();
                            } else {
                              _videoController?.pause();
                            }
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_videoThumbnail != null && !isVideoPlaying)
                              Image.memory(_videoThumbnail!),
                            if (_videoThumbnail != null && isVideoPlaying)
                              AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                            if (isVideoPlaying)
                              const Center(
                                child: Icon(
                                  Icons.pause,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            if (!isVideoPlaying)
                              const Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

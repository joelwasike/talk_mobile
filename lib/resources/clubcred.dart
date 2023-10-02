import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/colors.dart';
import 'groupcredentials.dart';

class ClubCred extends StatefulWidget {
  const ClubCred({super.key});

  @override
  State<ClubCred> createState() => _ClubCredState();
}

class _ClubCredState extends State<ClubCred> {
  File? imagefile;

//imagepicker
  final picker = ImagePicker();

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FadeInRight(
                child: Text('Create Club/Society',
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 10),
        child: SizedBox(
          height: 50,
          width: 50,
          child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  (context),
                  MaterialPageRoute(builder: (context) => const GroupCred()),
                );
              },
              backgroundColor: LightColor.maincolor,
              child: const Text(
                "create",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 40),
            child: Column(
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
                  child: CircleAvatar(
                    maxRadius: 60,
                    child: ClipOval(
                      child: SizedBox(
                        width: 115,
                        height: 115,
                        child: imagefile == null
                            ? Image.asset(
                                'assets/airtime.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                imagefile!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Profile picture",
                  style: TextStyle(color: Colors.grey.shade600),
                )
              ],
            ),
          ),
          const Text(
            "  Club Name",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "eg. Salsa Dance Club..",
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
            "  Club description ",
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
              child: const TextField(
                style: TextStyle(fontSize: 14),
                //controller: desc,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your Club description here",
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
    );
  }
}

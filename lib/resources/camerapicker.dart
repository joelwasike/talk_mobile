import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usersms/utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final picker = ImagePicker();
  File? croppedImageFile;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  Future imagecam() async {
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
        croppedImageFile = File(croppedFile.path);
      });
      // reload();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagecam();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColor.maincolor1,
        
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: <Widget>[
          TextButton(
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
      // POST FORM
      body: ListView(
        children: <Widget>[
          isLoading
              ? const LinearProgressIndicator()
              : const Padding(padding: EdgeInsets.only(top: 0.0)),
          const Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
             
              SizedBox(
                width: MediaQuery.of(context).size.width/2,
                child: AspectRatio(
                  aspectRatio: 487 / 500,
                  child: Container(
                    decoration: croppedImageFile != null
                        ? BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              alignment: FractionalOffset.topCenter,
                              image: FileImage(croppedImageFile!),
                            ),
                          )
                        : null,
                  ),
                ),
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
          const Divider(),
        ],
      ),
    );
  }
}

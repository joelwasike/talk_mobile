import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/utils/colors.dart';

class Addnotice extends StatefulWidget {
  const Addnotice({super.key});

  @override
  State<Addnotice> createState() => _AddnoticeState();
}

class _AddnoticeState extends State<Addnotice> {
  File? imagefile;
  bool isloading = false;

//imagepicker
  var picker = ImagePicker();
  File? selectedPdf;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  toast(String message) {
    CherryToast.success(
            title: const Text(""),
            backgroundColor: Colors.black,
            description: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            animationDuration: const Duration(milliseconds: 500),
            autoDismiss: true)
        .show(context);
  }

  Future<void> uploadNotice() async {
    setState(() {
      isloading = true;
    });
    try {
      if (imagefile == null || selectedPdf == null) {
        toast("The files should not be empty");
        return;
      }
      print("image selected is: ${imagefile!.path}");
      print("pdf selected is: ${selectedPdf!.path}");

      Dio dio = Dio();

      var formData = FormData();

      formData.fields.addAll([
        MapEntry('title', titleController.text),
        MapEntry('content', descriptionController.text),
        MapEntry('id', "6"),
      ]);
      formData.files.addAll([
        MapEntry(
          'photo',
          await MultipartFile.fromFile(imagefile!.path),
        ),
      ]);

      formData.files.addAll([
        MapEntry(
          'pdf',
          await MultipartFile.fromFile(selectedPdf!.path),
        ),
      ]);

      final response = await dio.post(
        '$baseUrl/uploadnotice',
        data: formData,
      );
      //print(jsonDecode(response.data));
      if (response.statusCode == 200) {
        // Handle successful response
        titleController.clear();
        descriptionController.clear();
        setState(() {
          imagefile = null;
          selectedPdf = null;
        });
        toast('Notice uploaded successfully');

        print('Notice uploaded successfully');
      } else {
        // Handle error response
        toast("Error uploading Notice");
        print('Error uploading notice: ${response.statusMessage}');
      }
    } catch (e) {
      // Handle exceptions
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

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedPdf = File(result.files.single.path!);
      });
    }
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 30)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 30)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile =
        await ImageCropper().cropImage(sourcePath: imgFile.path, uiSettings: [
      AndroidUiSettings(
        toolbarTitle: "Crop",
        toolbarColor: LightColor.maincolor1,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
        ],
      ),
      IOSUiSettings(
        title: "Crop",
      )
    ]);
    if (croppedFile != null) {
      // imageCache.clear();
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
        backgroundColor: LightColor.scaffold,
        title: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInRight(
                  child: Text('Post a Notice',
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
                uploadNotice();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          const Text(
            "  Notice Title",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "eg. Fee notice..",
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
            "  Notice Summary ",
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
              child: TextField(
                controller: descriptionController,
                style: const TextStyle(fontSize: 14),
                //controller: desc,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Notice summary here",
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
                  "Choose pdf screenshot",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(
                  height: 20,
                ),
                selectedPdf != null
                    ? Row(
                        children: <Widget>[
                          const Icon(
                            Icons.file_present,
                            color: LightColor.maincolor,
                          ),
                          const SizedBox(width: 10), // Changed height to width
                          Flexible(
                            child: Text(
                              selectedPdf!.path.split('/').last,
                              style: const TextStyle(fontSize: 12),
                              softWrap:
                                  true, // Ensures the text wraps to the next line
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          pickFile();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.height / 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: LightColor.maincolor),
                          child: const Icon(
                            Icons.attach_file,
                            color: LightColor.background,
                          ),
                        ),
                      ),
                Text(
                  "Attach a pdf notice",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

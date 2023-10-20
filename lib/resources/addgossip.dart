import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/utils/colors.dart';

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
  bool isVideoPlaying = false;
  bool isloading = false;
  File? videoFile;
  PlatformFile? pickedFile;
  String? path;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov'],
      );

      if (result != null) {
        setState(() {
          pickedFile = result.files.single;
          path = pickedFile!.path;
        });
      } else {
        print("error occured");
        // User canceled the file picking operation.
      }
    } catch (e) {
      // Handle errors or exceptions.
      print('Error picking file: $e');
    }
  }

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

  Future<void> uploadGossip() async {
    setState(() {
      isloading = true;
    });
    try {
      //print("image selected is: ${imagefile!.path}");
      //print("video selected is: ${videoFile!.path}");

      Dio dio = Dio();

      var formData = FormData();

      formData.fields.addAll([
        MapEntry('title', titleController.text),
        MapEntry('content', descriptionController.text),
        const MapEntry('email', "daviswasike@gmail.com"),
      ]);
      if (pickedFile != null) {
        formData.files.addAll([
          MapEntry(
            'media',
            await MultipartFile.fromFile(path!),
          ),
        ]);
      }

      final response = await dio.post(
        '$baseUrl/uploadgossip',
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
        toast("Error uploading Gossip");
        print('Error uploading Gossip: ${response.statusMessage}');
      }
    } catch (e) {
      // Handle exceptions
      toast("Error uploading Gossip");
      print('Error: $e');
    } finally {
      setState(() {
        isloading = false;
      });
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
              child: isloading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
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
              child: TextField(
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
                        _pickFile();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: LightColor.maincolor),
                      child: const Icon(
                        Icons.add_a_photo,
                        color: LightColor.background,
                      ),
                    )),
                Text(
                  "     Select a file",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (pickedFile != null)
                      pickedFile!.extension == 'mp4' ||
                              pickedFile!.extension == 'mov'
                          ?Text(pickedFile!.name)
                          : Image.file(
                              File(path!),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                  
                  ],
                ),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}

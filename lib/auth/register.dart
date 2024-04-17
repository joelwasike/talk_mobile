import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usersms/glassbox.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:http/http.dart' as http;
import 'package:usersms/utils/colors.dart';

class Register extends StatefulWidget {
  final VoidCallback showloginpage;
  const Register({super.key, required this.showloginpage});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final username = TextEditingController();
  final campus = TextEditingController();
  final emailAddressControllerR = TextEditingController();
  final passwordControllerR = TextEditingController();
  final passwordController = TextEditingController();
  bool isloading = false;
  File? imagefile;

  //toast
  toast(String message) {
    CherryToast.info(
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

  //fetch data

  Future<void> fetchData() async {
    setState(() {
      isloading = true;
    });
    Map body = {"email": emailAddressControllerR.text};
    final url =
        Uri.parse('$baseUrl/getuserdetails'); // Replace with your JSON URL
    final response = await http.post(url, body: jsonEncode(body));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var box = Hive.box("Talk");
      box.put("id", jsonData[0]["ID"]);
      box.put("username", jsonData[0]["username"]);
      box.put("email", jsonData[0]["email"]);
      box.put("profile_picture", jsonData[0]["profile_picture"]);
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  //register
  Future register() async {
    try {
      setState(() {
        isloading = true;
      });

      if (passwordconfirm()) {
        final addUserResult = await addUser();
        if (addUserResult) {
          await fetchData();
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailAddressControllerR.text.trim(),
            password: passwordController.text.trim(),
          );
        } else {
          setState(() {
            isloading = false;
          });
          toast('An error occurred. Please try again');
        }
      } else {
        CherryToast.error(
          title: const Text(""),
          backgroundColor: Colors.black45,
          description: const Text(
            "Password Mismatch",
            style: TextStyle(color: Colors.white),
          ),
          animationDuration: const Duration(seconds: 1),
          autoDismiss: true,
        ).show(context);
      }
    } on FirebaseAuthException catch (e) {
      CherryToast.error(
        title: const Text(""),
        backgroundColor: Colors.black45,
        description: Text(
          e.message.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        animationDuration: const Duration(seconds: 1),
        autoDismiss: true,
      ).show(context);
    } finally {
      setState(() {
        isloading = true;
      });
    }
  }

  Future<bool> addUser() async {
    setState(() {
      isloading = true;
    });
    try {
      if (imagefile == null) {
        toast("The files should not be empty");
        return false;
      }

      Dio dio = Dio();

      var formData = FormData();

      formData.fields.addAll([
        MapEntry('email', emailAddressControllerR.text),
        MapEntry('username', username.text),
        MapEntry('campus', "kibabii university"),
      ]);
      formData.files.addAll([
        MapEntry(
          'profilepicture',
          await MultipartFile.fromFile(imagefile!.path),
        ),
      ]);

      final response = await dio.post(
        '$baseUrl/register',
        data: formData,
      );
      //print(jsonDecode(response.data));
      if (response.statusCode == 200) {
        // Handle successful response

        setState(() {
          imagefile = null;
        });
        toast('Account created successfully');
        return true;
      } else {
        // Handle error response
        setState(() {
          isloading = false;
        });
        toast("Error creating Account");
        return false;
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      return false;
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

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

  //confirm password
  bool passwordconfirm() {
    if (passwordControllerR.text.trim() == passwordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    emailAddressControllerR.dispose();
    passwordController.dispose();
    passwordControllerR.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/airtime.jpg"),
                  fit: BoxFit.cover,
                  opacity: 0.49)),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  "Nice to meet you.",
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey)),
                ),
              ),
              FadeInDown(
                child: Center(
                  child: Text(
                    "Campus Talk",
                    style: GoogleFonts.aguafinaScript(
                        textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                ),
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
                      child: Stack(alignment: Alignment.center, children: [
                        CircleAvatar(
                          maxRadius: 60,
                          backgroundColor: LightColor.maincolor,
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
                        Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 30,
                        )
                      ]),
                    ),
                    Text(
                      "Profile picture",
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GlassBox(
                width: double.infinity,
                height: 50.0,
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none,
                      hintText: "Username",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GlassBox(
                width: double.infinity,
                height: 50.0,
                child: TextField(
                  controller: emailAddressControllerR,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none,
                      hintText: "Email",
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GlassBox(
                width: double.infinity,
                height: 50.0,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none,
                      hintText: "Password",
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GlassBox(
                width: double.infinity,
                height: 50.0,
                child: TextField(
                  controller: passwordControllerR,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none,
                      hintText: "Confirm Password",
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade400)),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: register,
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(9)),
                    child: Center(
                        child: isloading
                            ? const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 25,
                              )
                            : const Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: widget.showloginpage,
                      child: const Text(
                        "Have an account? Log in",
                        style: TextStyle(color: Colors.grey),
                      )),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              //  Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     GestureDetector(
              //       onTap: () => AuthService().signInWithGoogle(),
              //       child: const GlassBox(
              //           height: 70.0,
              //           width: 70.0,
              //           child: Center(
              //             child: Image(
              //               height: 40,
              //               width: 40,
              //               image: AssetImage("assets/google.png"),
              //               fit: BoxFit.contain,
              //             ),
              //           )),
              //     ),
              //     const GlassBox(
              //         height: 70.0,
              //         width: 70.0,
              //         child: Center(
              //           child: Image(
              //             height: 50,
              //             width: 50,
              //             image: AssetImage("assets/facebook.png"),
              //             fit: BoxFit.contain,
              //           ),
              //         ))
              //   ],
              // )
            ],
          ),
        ));
  }
}

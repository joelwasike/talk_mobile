import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usersms/resources/followers.dart';
import 'package:usersms/resources/following.dart';
import 'package:usersms/utils/colors.dart';
import 'dart:math' as math;
import 'package:usersms/screens/profile/widgets/profile_background.dart';
import 'package:usersms/screens/profile/widgets/stat.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../resources/image_data.dart';
import '../../resources/searchpostpage.dart';

class ProfileScren extends StatefulWidget {
  const ProfileScren({Key? key}) : super(key: key);

  @override
  State<ProfileScren> createState() => _ProfileScrenState();
}

class _ProfileScrenState extends State<ProfileScren> {
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
    return ProfileBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: math.pi / 4,
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.black),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
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
                      child: ClipPath(
                          clipper: ProfileImageClipper(),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                            imagefile == null
                                ? Image.asset(
                                    'assets/airtime.jpg',
                                    width: 180.0,
                                    height: 180.0,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    imagefile!,
                                    width: 180.0,
                                    height: 180.0,
                                    fit: BoxFit.cover,
                                  ),
                                  const Icon(Icons.add_a_photo,color: LightColor.background,size: 30,)
                          ])),
                    )
                  ],
                ),
                const Text(
                  'Joel Wasike',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '@joelwasike',
                  style: TextStyle(color: Colors.grey.shade300),
                ),
                const SizedBox(height: 80.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Stat(title: 'Posts', value: 35),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (context) => const Followers()),
                            );
                          },
                          child: const Stat(title: 'Followers', value: 1552)),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (context) => const Following()),
                            );
                          },
                          child: const Stat(title: 'Following', value: 128)),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: StaggeredGrid.count(
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                    crossAxisCount: 3,
                    children: List.generate(
                      imageList.length,
                      (index) => StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPostPage(
                                      postId: imageList[index].id),
                                ),
                              );
                            },
                            child: ImageCard(imageData: imageList[index])),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileImageClipper extends CustomClipper<Path> {
  double radius = 23;

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(size.width / 2 - radius, radius)
      ..quadraticBezierTo(size.width / 2, 0, size.width / 2 + radius, radius)
      ..lineTo(size.width - radius, size.height / 2 - radius)
      ..quadraticBezierTo(size.width, size.height / 2, size.width - radius,
          size.height / 2 + radius)
      ..lineTo(size.width / 2 + radius, size.height - radius)
      ..quadraticBezierTo(size.width / 2, size.height, size.width / 2 - radius,
          size.height - radius)
      ..lineTo(radius, size.height / 2 + radius)
      ..quadraticBezierTo(0, size.height / 2, radius, size.height / 2 - radius)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, required this.imageData}) : super(key: key);

  final ImageData imageData;

  Future<String> generateVideoThumbnail(String videoUrl) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      quality: 75, // Adjust the quality (0 - 100)
      maxHeight: 128, // Maximum height of the thumbnail
    );

    return thumbnailPath!;
  }

  bool isVideoLink(String link) {
    final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov', '.wmv'];
    for (final extension in videoExtensions) {
      if (link.toLowerCase().endsWith(extension)) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isVideo = isVideoLink(imageData.imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: isVideo
          ? FutureBuilder<String>(
              future: generateVideoThumbnail(imageData.imageUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(
                        File(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                      Center(
                        child: Icon(
                          Icons.play_arrow,
                          size: 48,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(); // Show a loading indicator
                }
              },
            )
          : Image.network(imageData.imageUrl, fit: BoxFit.cover),
    );
  }
}

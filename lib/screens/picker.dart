// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:photo_gallery/photo_gallery.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:usersms/utils/colors.dart';
// import 'package:video_player/video_player.dart';

// class AlbumPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => AlbumPageState();
// }

// class AlbumPageState extends State<AlbumPage>
//     with SingleTickerProviderStateMixin {
//   List<Medium>? _media;
//   bool _loading = false;
//   File? imagefile;
//   final picker = ImagePicker();
//   Uint8List? _file;

//   @override
//   void initState() {
//     super.initState();
//     _loading = true;
//     initAsync();
//   }

//   _imgFromCamera() async {
//     await picker
//         .pickImage(source: ImageSource.camera, imageQuality: 50)
//         .then((value) {
//       if (value != null) {
//         _cropImage(File(value.path));
//       }
//     });
//   }

//   _cropImage(File imgFile) async {
//     final croppedFile = await ImageCropper().cropImage(
//         sourcePath: imgFile.path,
//         aspectRatioPresets: Platform.isAndroid
//             ? [
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio16x9
//               ]
//             : [
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio5x3,
//                 CropAspectRatioPreset.ratio5x4,
//                 CropAspectRatioPreset.ratio7x5,
//                 CropAspectRatioPreset.ratio16x9
//               ],
//         uiSettings: [
//           AndroidUiSettings(
//               toolbarTitle: "Crop",
//               toolbarColor: LightColor.maincolor1,
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false),
//           IOSUiSettings(
//             title: "Crop",
//           )
//         ]);
//     if (croppedFile != null) {
//       imageCache.clear();
//       setState(() {
//         imagefile = File(croppedFile.path);
//       });
     

//       // reload();
//     }
//   }

//   Future<void> initAsync() async {
//     if (await _promptPermissionSetting()) {
//       List<Medium> mediaList = await fetchMediaItems();
//       setState(() {
//         _media = mediaList;
//         _loading = false;
//       });
//     }
//     setState(() {
//       _loading = false;
//     });
//   }

//   Future<List<Medium>> fetchMediaItems() async {
//     List<Album> albums = await PhotoGallery.listAlbums();
//     List<Medium> mediaList = [];

//     for (var album in albums) {
//       MediaPage mediaPage = await album.listMedia();
//       mediaList.addAll(mediaPage.items);
//     }

//     return mediaList;
//   }

//   Future<bool> _promptPermissionSetting() async {
//     if (Platform.isIOS) {
//       if (await Permission.photos.request().isGranted ||
//           await Permission.storage.request().isGranted) {
//         return true;
//       }
//     }
//     if (Platform.isAndroid) {
//       if (await Permission.storage.request().isGranted ||
//           await Permission.photos.request().isGranted &&
//               await Permission.videos.request().isGranted) {
//         return true;
//       }
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Number of tabs
//       child: Scaffold(
//         appBar: AppBar(
//             backgroundColor: LightColor.maincolor1,
//             automaticallyImplyLeading: false,
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Talk Gallery",
//                   style: TextStyle(color: LightColor.background),
//                 ),
//                 IconButton(
//                     onPressed: _imgFromCamera,
//                     icon: Icon(
//                       Icons.camera,
//                       size: 35,
//                       color: LightColor.background,
//                     ))
//               ],
//             )),
//         body: _loading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : TabBarView(
//                 children: [
//                   // First Tab: Gallery

//                   SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 2),
//                       child: Container(
//                         child: StaggeredGrid.count(
//                           mainAxisSpacing: 4.0,
//                           crossAxisSpacing: 4.0,
//                           crossAxisCount: 3,
//                           children: List.generate(
//                             _media?.length ?? 0,
//                             (index) => StaggeredGridTile.fit(
//                               crossAxisCellCount: 1,
//                               child: GestureDetector(
//                                 onTap: () => Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           ViewerPage(_media![index])),
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(16.0),
//                                   child: FadeInImage(
//                                     fit: BoxFit.cover,
//                                     placeholder: MemoryImage(kTransparentImage),
//                                     image: ThumbnailProvider(
//                                       mediumId: _media![index].id,
//                                       mediumType: _media![index].mediumType,
//                                       highQuality: true,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container()
//                 ],
//               ),
//       ),
//     );
//   }
// }

// class ViewerPage extends StatelessWidget {
//   final Medium medium;

//   ViewerPage(Medium medium) : medium = medium;

//   @override
//   Widget build(BuildContext context) {
//     DateTime? date = medium.creationDate ?? medium.modifiedDate;
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () => Navigator.of(context).pop(),
//             icon: const Icon(Icons.arrow_back_ios),
//           ),
//           title: date != null ? Text(date.toLocal().toString()) : null,
//         ),
//         body: Column(
//           children: <Widget>[
//             const Padding(padding: EdgeInsets.only(top: 0.0)),
//             const Divider(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 const CircleAvatar(
//                   backgroundImage: AssetImage("assets/airtime.jpg"),
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.3,
//                   child: const TextField(
//                     decoration: InputDecoration(
//                         hintText: "Write a caption...",
//                         hintStyle: TextStyle(color: Colors.white),
//                         border: InputBorder.none),
//                     maxLines: 8,
//                   ),
//                 ),
//                 SizedBox(
//                     height: 175.0,
//                     width: 55.0,
//                     child: medium.mediumType == MediumType.image
//                         ? AspectRatio(
//                             aspectRatio: 487 / 451,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                 fit: BoxFit.fill,
//                                 alignment: FractionalOffset.topCenter,
//                                 image: PhotoProvider(mediumId: medium.id),
//                               )),
//                             ),
//                           )
//                         : Container(
//                             child: VideoProvider(
//                               mediumId: medium.id,
//                             ),
//                           )),
//               ],
//             ),
//             const Divider(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VideoProvider extends StatefulWidget {
//   final String mediumId;

//   const VideoProvider({
//     required this.mediumId,
//   });

//   @override
//   _VideoProviderState createState() => _VideoProviderState();
// }

// class _VideoProviderState extends State<VideoProvider> {
//   VideoPlayerController? _controller;
//   File? _file;

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       initAsync();
//     });
//     super.initState();
//   }

//   Future<void> initAsync() async {
//     try {
//       _file = await PhotoGallery.getFile(mediumId: widget.mediumId);
//       _controller = VideoPlayerController.file(_file!);
//       _controller?.initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//     } catch (e) {
//       print("Failed : $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller == null || !_controller!.value.isInitialized
//         ? Container()
//         : Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               AspectRatio(
//                 aspectRatio: _controller!.value.aspectRatio,
//                 child: VideoPlayer(_controller!),
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     _controller!.value.isPlaying
//                         ? _controller!.pause()
//                         : _controller!.play();
//                   });
//                 },
//                 child: Icon(
//                   _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                 ),
//               ),
//             ],
//           );
//   }
// }

// class Post extends StatefulWidget {
//   const Post({super.key});

//   @override
//   State<Post> createState() => _PostState();
// }

// class _PostState extends State<Post> {
//   Uint8List? _file;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           const Padding(padding: EdgeInsets.only(top: 0.0)),
//           const Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const CircleAvatar(
//                 backgroundImage: AssetImage("assets/airtime.jpg"),
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.3,
//                 child: TextField(
//                   decoration: const InputDecoration(
//                       hintText: "Write a caption...", border: InputBorder.none),
//                   maxLines: 8,
//                 ),
//               ),
//               SizedBox(
//                 height: 45.0,
//                 width: 45.0,
//                 child: AspectRatio(
//                   aspectRatio: 487 / 451,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                       fit: BoxFit.fill,
//                       alignment: FractionalOffset.topCenter,
//                       image: MemoryImage(_file!),
//                     )),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Divider(),
//         ],
//       ),
//     );
//   }
// }

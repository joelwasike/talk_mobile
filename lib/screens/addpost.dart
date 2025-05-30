import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:usersms/utils/colors.dart';

import '../resources/postupload.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<StatefulWidget> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage>
    with SingleTickerProviderStateMixin {
  List<Medium>? _media;
  bool _loading = false;
  File? imagefile;

  @override
  void initState() {
    super.initState();
    _loading = true;
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Medium> mediaList = await fetchMediaItems();
      if (mounted) {
        setState(() {
          _media = mediaList;
          _loading = false;
        });
      }
    }
  }

  Future<List<Medium>> fetchMediaItems() async {
    List<Album> albums = await PhotoGallery.listAlbums();
    List<Medium> mediaList = [];

    for (var album in albums) {
      MediaPage mediaPage = await album.listMedia();
      mediaList.addAll(mediaPage.items);
    }

    return mediaList;
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        return true;
      }
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
              await Permission.videos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: LightColor.scaffold,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Talk Gallery",
                  style: GoogleFonts.aguafinaScript(
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: LightColor.background)),
                ),
                // IconButton(
                //     onPressed: () {
                //       Navigator.pushNamed(context, '/camera');
                //     },
                //     icon: const Icon(
                //       FontAwesomeIcons.camera,
                //       size: 30,
                //       color: LightColor.maincolor,
                //     ))
              ],
            )),
        body: _loading
            ? const Center(
                child: SpinKitThreeBounce(
                color: Colors.white,
                size: 25,
              )
                // Placeholder while loading

                )
            : TabBarView(
                children: [
                  // First Tab: Gallery

                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        child: StaggeredGrid.count(
                          mainAxisSpacing: 2.0,
                          crossAxisSpacing: 2.0,
                          crossAxisCount: 3,
                          children: List.generate(
                            _media?.length ?? 0,
                            (index) => StaggeredGridTile.fit(
                              crossAxisCellCount: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  File file = await PhotoGallery.getFile(
                                      mediumId: _media![index].id);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ViewerPage(file),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FadeInImage(
                                        fit: BoxFit.cover,
                                        placeholder:
                                            MemoryImage(kTransparentImage),
                                        image: ThumbnailProvider(
                                          mediumId: _media![index].id,
                                          mediumType: _media![index].mediumType,
                                          highQuality: true,
                                        ),
                                      ),
                                      if (_media![index].mediumType ==
                                          MediumType
                                              .video) // Check if it's a video
                                        const Icon(
                                          Icons.play_circle_filled,
                                          size: 40,
                                          color: Colors.white,
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container()
                ],
              ),
      ),
    );
  }
}

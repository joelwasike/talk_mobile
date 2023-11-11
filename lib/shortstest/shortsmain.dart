import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:usersms/shortstest/shortsplayerwidget.dart';
import 'package:usersms/utils/colors.dart';

class ShortsMainScreen extends StatefulWidget {
  final List url;
  final int startIndex;
  const ShortsMainScreen(
      {Key? key, required this.url, required this.startIndex})
      : super(key: key);

  @override
  State<ShortsMainScreen> createState() => _ShortsMainScreenState();
}

class _ShortsMainScreenState extends State<ShortsMainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: (widget.url.isNotEmpty)
          ? Scaffold(
              body: PreloadPageView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.url.length,
                preloadPagesCount: 5,
                controller: PreloadPageController(initialPage: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Stack(
                    //to put all other elements on top of the video
                    children: [
                      ShortsPlayer(
                        profilepic: widget.url[index]["profile_pictire"],
                        username: widget.url[index]["username"],
                        userid: widget.url[index]["userid"],
                        likes: widget.url[index]["likes"],
                        id: widget.url[index]["id"],
                        content: widget.url[index]["content"],
                        shortsUrl: widget.url[index]["media"],
                      ),

                      //all stacked options
                    ],
                  );
                },
              ),
            )
          : const Center(
              child: SpinKitSpinningLines(
                color: LightColor.scaffold,
                size: 200,
                lineWidth: 3,
              ),
            ),
    );
  }
}

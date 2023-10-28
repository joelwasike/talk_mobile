import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:usersms/resources/heartanimationwidget.dart';
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
              body: PageView.builder(
                //to make the whole page scrollable
                itemCount: widget.url.length,
                controller: PageController(
                    initialPage: widget.startIndex, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Stack(
                    //to put all other elements on top of the video
                    children: [
                      ShortsPlayer(
                        shortsUrl: widget.url[index],
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

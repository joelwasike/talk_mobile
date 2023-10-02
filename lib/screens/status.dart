import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:usersms/resources/image_data.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/story/screens/story_screen.dart';

class StatusScreen extends StatefulWidget {
  static const String id = "statusscreen";

  const StatusScreen({super.key});
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

Map statusList = {
  0: ['Williams Anders', 'assets/airtime.jpg', 3.0, 4.5, '1 minute ago', false],
  1: ['Mom', 'assets/airtime.jpg', 1.0, 0.0, '20 minutes ago', false],
  2: ['Hannah', 'assets/airtime.jpg', 5.0, 2.5, '28 minutes ago', false],
  3: ['Dad', 'assets/airtime.jpg', 2.0, 3.5, '53 minutes ago', false],
  4: ['Cayne Don', 'assets/airtime.jpg', 4.0, 3.0, 'Today 04:30 pm', false],
  5: ['Abby Gale', 'assets/airtime.jpg', 1.0, 0.0, 'Today 03:30 pm', false],
  6: ['Dad', 'assets/airtime.jpg', 2.0, 3.5, '53 minutes ago', false],
  7: ['Cayne Don', 'assets/airtime.jpg', 4.0, 3.0, 'Today 04:30 pm', false],
  8: ['Abby Gale', 'assets/airtime.jpg', 1.0, 0.0, 'Today 03:30 pm', false],
};

class _StatusScreenState extends State<StatusScreen> {
  bool isclicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: LightColor.maincolor1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: const Icon(
              Icons.add_a_photo,
              color: LightColor.maincolor,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: LightColor.secondaycolor,
              pinned: true,
              snap: true,
              floating: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(color: LightColor.background),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isclicked = !isclicked;
                        });
                      },
                      icon: const Icon(
                        Icons.search,
                        color: LightColor.background,
                      ))
                ],
              )),
          SliverToBoxAdapter(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: 800,
                    child: Column(
                      children: [
                        //search
                        isclicked
                            ? FadeInDown(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 16, right: 16),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search status...",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey.shade600,
                                        size: 20,
                                      ),
                                      filled: true,
                                      fillColor: LightColor.maincolor1,
                                      contentPadding: const EdgeInsets.all(8),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade600)),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: const Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: LightColor.maincolor1,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          AssetImage('assets/airtime.jpg'),
                                    ),
                                    Positioned(
                                      left: 30,
                                      top: 30,
                                      child: CircleAvatar(
                                        backgroundColor: LightColor.maincolor,
                                        radius: 10,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Status',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: LightColor.background,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Tap to add status update',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: LightColor.maincolor1,
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Text(
                            'Recent updates',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const StatusTiles(),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}

class StatusTiles extends StatelessWidget {
  const StatusTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  onTap: () {
                    showModalBottomSheet(
                        useSafeArea: true,
                        isScrollControlled: true,
                        enableDrag: true,
                        context: context,
                        builder: (context) => Container(
                            padding: const EdgeInsets.only(
                                bottom:
                                    0),
                            decoration: const BoxDecoration(
                                color: LightColor.maincolor1,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    topLeft: Radius.circular(25))),
                            child: const StoryScreen(images: imageList)));
                  },
                  title: Container(
                    child: Row(
                      children: [
                        DottedBorder(
                          color: LightColor.maincolor,
                          borderType: BorderType.Circle,
                          radius: const Radius.circular(27),
                          dashPattern: [
                            (2 * pi * 27) /
                                statusList.values.elementAt(index)[2],
                            statusList.values.elementAt(index)[3],
                          ],
                          strokeWidth: 2,
                          child: CircleAvatar(
                            radius: 27,
                            backgroundColor: LightColor.maincolor1,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                statusList.values.elementAt(index)[1],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${statusList.values.elementAt(index)[0]}',
                              style: const TextStyle(
                                color: LightColor.background,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${statusList.values.elementAt(index)[4]}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: statusList.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}

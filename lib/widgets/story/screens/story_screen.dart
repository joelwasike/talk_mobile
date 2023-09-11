import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:usersms/resources/image_data.dart';

import '../../../utils/colors.dart';


class StoryScreen extends StatefulWidget {
  late final List<ImageData> images;
  StoryScreen({required this.images, super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentIndex = 0;
  List<double> precentagesProgress = [];
    bool isPaused = false; 
      int longPressedIndex = -1; // Index of the image being long-pressed



  @override
  void initState() {
    super.initState();
    for (var _ in widget.images) {
      precentagesProgress.add(0.0);
    }

    _watchingProgress();
  }

  void _watchingProgress() {
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (mounted && !isPaused) {
        setState(() {
          if (longPressedIndex == currentIndex) { // Check the longPressedIndex
            if (precentagesProgress[currentIndex] + 0.01 < 1) {
              precentagesProgress[currentIndex] += 0.01;
            } else {
              precentagesProgress[currentIndex] = 1;
              timer.cancel();

              if (currentIndex < widget.images.length - 1) {
                currentIndex++;
                _watchingProgress();
              } else {
                _goBack();
              }
            }
          }
        });
      }
    });
  }
  

  void _goBack() {
    Navigator.pop(context);
  }

  void _onTap(TapDownDetails details) {
    final double dx = details.globalPosition.dx;
    final double width = MediaQuery.of(context).size.width;
    if (dx < width / 2) {
      setState(() {
        if (currentIndex > 0) {
          precentagesProgress[currentIndex - 1] = 0;
          precentagesProgress[currentIndex] = 0;
          currentIndex--;
        }
      });
    } else {
      setState(() {
        if (currentIndex < widget.images.length - 1) {
          precentagesProgress[currentIndex] = 1;
          currentIndex++;
        } else {
          precentagesProgress[currentIndex] = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    return Scaffold(
      body: GestureDetector(
         onTapDown: _onTap,
    onLongPressStart: (details) {
    
      longPressedIndex = currentIndex;
      setState(() {
        isPaused = true; // Pause the timer and progress
      });
    },
    onLongPressEnd: (_) {
      longPressedIndex = -1; // Reset the longPressedIndex
      setState(() {
        isPaused = false; // Resume the timer and progress
      });
    },
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                 // _buildNavBar(),
                  _buildBars(images.length, precentagesProgress),
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(images[currentIndex].imageUrl),
                      ),
                    ),
                  ),
                  
                  
                  
                  Positioned(
                    top: 40,
                    right: 5,
                    child: IconButton(color: Colors.indigo,
            
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ),
            
                 
                ],
              ),
            ),
             Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search friends...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: LightColor.maincolor1,
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade600)),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildBars(int count, List<double> precents) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Row(
      children: [
        for (int i = 0; i < count; i++)
          Expanded(
            child: LinearPercentIndicator(
              progressColor: Colors.indigo,
              backgroundColor: const Color.fromARGB(255, 226, 226, 226),
              lineHeight: 3,
              percent: precents[i],
              padding: const EdgeInsets.symmetric(horizontal: 2), // Adjust this value
              barRadius: const Radius.circular(10.0),
            ),
          )
      ],
    ),
  );
}

 Widget _buildMessageInput() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade700),
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/airtime.jpg"),
            ),
          ),
          Expanded(
            child: TextField(
              //controller: _messageController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: InputBorder.none,
                  hintText: "    Write Comment",
                  hintStyle: TextStyle(color: Colors.grey.shade400)),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send,
                color: LightColor.maincolor,
              ))
        ],
      ),
    );
  }
}




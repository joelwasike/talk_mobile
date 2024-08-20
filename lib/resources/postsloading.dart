import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

class Postsloading extends StatefulWidget {
  const Postsloading({super.key});

  @override
  State<Postsloading> createState() => _PostsloadingState();
}

class _PostsloadingState extends State<Postsloading> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            GFShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    color: Colors.grey.shade800.withOpacity(0.4),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 8,
                    color: Colors.grey.shade800.withOpacity(0.4),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 8,
                    color: Colors.grey.shade800.withOpacity(0.4),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 8,
                    color: Colors.grey.shade800.withOpacity(0.4),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        );
      },
    );
  }
}

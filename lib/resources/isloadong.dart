import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

class Isloading extends StatefulWidget {
  const Isloading({super.key});

  @override
  State<Isloading> createState() => _IsloadingState();
}

class _IsloadingState extends State<Isloading> {
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    GFShimmer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            color: Colors.grey.shade800.withOpacity(0.2),
                          ),
                         
                        ],
                      ),
                    ),
                    SizedBox(height: 10,)
                  ],
                );
              },
            );
  }
}


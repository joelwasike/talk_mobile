import 'package:flutter/material.dart';

class HeartAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool alwaysAnimate;


  const HeartAnimationWidget({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.alwaysAnimate = false,
    this.duration = const Duration(microseconds: 150),
    this.onEnd,
  }) : super(key: key);

  @override
  State<HeartAnimationWidget> createState() => _HeartAnimationWidgetState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final halfduration = widget.duration.inMicroseconds ~/ 2;
    controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: halfduration),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant HeartAnimationWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      doAnimation();
    }
  }
  Future doAnimation() async{
    if (widget.isAnimating || widget.alwaysAnimate) {
       await controller.forward();
    await controller.reverse();

    if (widget.onEnd != null) {
      widget.onEnd!();
    }
    }
   
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child);
  }
}

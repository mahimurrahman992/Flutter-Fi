import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  @override
  _CustomCircularProgressIndicatorState createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation =
        Tween<double>(begin: 0, end: 2 * 3.14159) // Full rotation (360 degrees)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
          ..addListener(() {
            setState(() {});
          });

    _controller.repeat(); // Start the rotation animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: _animation.value,
        child:Image.asset('images/flutter.png'),
      ),
    );
  }
}

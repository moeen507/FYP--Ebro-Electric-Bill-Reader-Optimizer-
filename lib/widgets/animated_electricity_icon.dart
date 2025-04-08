import 'package:flutter/material.dart';

class AnimatedElectricityIcon extends StatefulWidget {
  const AnimatedElectricityIcon({super.key});

  @override
  _AnimatedElectricityIconState createState() =>
      _AnimatedElectricityIconState();
}

class _AnimatedElectricityIconState extends State<AnimatedElectricityIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(Icons.bolt, size: 150, color: Colors.tealAccent),
    );
  }
}

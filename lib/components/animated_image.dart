import 'package:flutter/material.dart';

class CustomBgImage extends StatelessWidget {
  final double opacity;
  final Duration duration;
  const CustomBgImage({super.key, required this.opacity, required this.duration});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: duration,
      opacity: opacity,
    
      child: Image.asset('assets/images/bg.jpg',
        fit: BoxFit.cover,
      ),
      
    );
  }
}

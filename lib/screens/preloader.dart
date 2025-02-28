// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tontine/components/animated_image.dart';
import 'package:tontine/components/button.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    // Fade in animation
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 0.3;
      });
    });
  }

  void submit(){
    // Navigate to Login page after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = !_isLoading;
      });
      Navigator.pushNamed(context, '/login');
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark, // Status bar color
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: CustomBgImage(
                duration: Duration(seconds: 2),
                opacity: _opacity,
              ),
            ),

            // Text & Button Overlay
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Welcome to FinancePro",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Your follow up savings companion",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(),
                      ),
                    ),
                    SizedBox(height: 30),
                    
                    // "Get Started" Button
                    CustomButton(
                      text: "Get Started",
                      onPressed: submit,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
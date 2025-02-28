import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback?
      onPressed; // Allows passing a function when the button is pressed

  const CustomButton({
    super.key,
    required this.text, // Required text argument
    this.onPressed, // Optional onPressed argument
    required this.isLoading, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Uses the passed function
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(201, 254, 1, 43),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
        textStyle: const TextStyle(
          fontSize: 18,
        ),
      ),
      child: isLoading ? 
            const CircularProgressIndicator(
                color: Colors.white,
            )
            : 
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {

  final VoidCallback onTap;
  final Color? backgroundColor;
  Color iconColor;
  Color textColor;
  final String title;
  final IconData icon;

  CustomListTile({
    super.key,
    required this.icon,
    required this.onTap,
    required this.title,
    this.backgroundColor = Colors.grey,
    this.iconColor = Colors.white,
    this.textColor = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        leading: Icon(icon),
        iconColor: iconColor,
        title: Text(title),
        textColor: textColor,
        onTap: onTap,
      ),
    );
  }
}

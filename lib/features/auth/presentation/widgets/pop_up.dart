import 'package:flutter/material.dart';

class CommonPopup extends StatelessWidget {
  final String title; // Popup title
  final String content; // Popup content
  final VoidCallback? onClose; // Action for the single button
  final String buttonText; // Text for the single button
  final IconData icon; // Icon to display
  final Color iconColor; // Icon color

  const CommonPopup({
    Key? key,
    required this.title,
    required this.content,
    this.onClose,
    this.buttonText = "OK", // Default button text
    required this.icon, // Icon for popup
    required this.iconColor, // Color for the icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actionsPadding: const EdgeInsets.all(8),
      title: Row(
        children: [
          Icon(
            icon, // Dynamic icon
            color: iconColor, // Dynamic icon color
            size: 28,
          ),
          const SizedBox(width: 8), // Spacing between icon and title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
      actions: [
        ElevatedButton(
          onPressed: onClose ?? () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: iconColor, // Match button color with icon
          ),
          child: Text(buttonText),
        ),
      ],
    );
  }
}

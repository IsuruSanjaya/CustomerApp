import 'package:flutter/material.dart';

class FancyLoader extends StatelessWidget {
  final String message;

  const FancyLoader({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rotating circle for a nicer effect
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 6,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          // Additional animation for a better visual effect
          const SizedBox(
            height: 40,
            width: 40,
            child: AnimatedOpacity(
              opacity: 0.7,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.hourglass_empty,
                color: Colors.blue,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:customers/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AuthButton extends StatelessWidget {
  final Future<void> Function() onPressed; // Updated to Future<void>

  const AuthButton({
    super.key,
    required this.onPressed, // Store the callback
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppPallete.gradient3, AppPallete.gradient2],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          borderRadius: BorderRadius.circular(7)),
      child: ElevatedButton(
        onPressed: () async {
          await onPressed(); // Call the provided callback
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(400, 55),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          'Sign In',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

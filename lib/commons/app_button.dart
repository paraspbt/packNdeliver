import 'package:flutter/material.dart';
import 'package:pack_n_deliver/theme/app_pallete.dart';

class AppButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(320, 50),
          backgroundColor: AppPallete.darkGreen,
          foregroundColor: AppPallete.backgroundColor,
          // Set a specific width and height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

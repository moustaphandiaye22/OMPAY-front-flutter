import 'package:flutter/material.dart';

class CustomOrangeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final bool isLoading;

  const CustomOrangeButton({
   Key? key,
   required this.text,
   this.onPressed,
   this.height = 40.0,
   this.isLoading = false,
 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7900),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0,
              ),
            ),
      ),
    );
  }
}
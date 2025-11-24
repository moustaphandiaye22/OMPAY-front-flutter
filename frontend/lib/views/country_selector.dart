import 'package:flutter/material.dart';

class CountrySelector extends StatelessWidget {
  final double height;

  const CountrySelector({
    Key? key,
    this.height = 56.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        border: Border.all(
          color: const Color(0xFF3A3A3A),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🇸🇳',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 6),
          const Text(
            '+221',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 22,
          ),
        ],
      ),
    );
  }
}
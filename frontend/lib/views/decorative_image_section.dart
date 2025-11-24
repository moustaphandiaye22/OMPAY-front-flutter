import 'package:flutter/material.dart';

class DecorativeImageSection extends StatelessWidget {
  const DecorativeImageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Image
          Positioned(
            right: 20,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 180,
                height: 100,
                color: const Color(0xFF4A4A4A),
                child: const Icon(
                  Icons.computer,
                  size: 60,
                  color: Color(0xFFFF7900),
                ),
              ),
            ),
          ),
          // Bandes colorées
          Positioned(
            right: 0,
            top: 20,
            child: CustomPaint(
              size: const Size(200, 80),
              painter: ColorfulLinesPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

// Painter pour les bandes colorées décoratives
class ColorfulLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final colors = [
      const Color(0xFF6B4FBF),
      const Color(0xFF4A90E2),
      const Color(0xFFFF7900),
      const Color(0xFFFFC700),
    ];

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      final startY = i * 20.0;
      canvas.drawLine(
        Offset(0, startY),
        Offset(size.width, startY + 40),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
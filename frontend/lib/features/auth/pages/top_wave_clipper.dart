import 'dart:ui';

import 'package:flutter/material.dart';

class TopWaveClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1C1C1C) // Couleur gris foncé
      ..style = PaintingStyle.fill;

    final path = Path();

    // Commencer depuis le point haut gauche avec la courbe
    path.moveTo(0, 60);

    // Créer une vague lisse et fluide avec cubicTo pour plus de contrôle
    path.cubicTo(
      size.width * 0.15, 2,    // Premier point de contrôle (montée)
      size.width * 0.15, 2,    // Deuxième point de contrôle (sommet)
      size.width * 0.5, 40,     // Point d'arrivée (milieu)
    );

    path.cubicTo(
      size.width * 0.65, 50,    // Premier point de contrôle (descente)
      size.width * 0.85, 75,    // Deuxième point de contrôle
      size.width, 3,           // Point final à droite
    );

    // Compléter le rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
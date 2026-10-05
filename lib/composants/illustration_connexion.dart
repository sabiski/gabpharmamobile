import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';

/// Illustration sécurité (femme + téléphone + cadenas) — version vectorielle UI.
class IllustrationConnexion extends StatelessWidget {
  final double height;

  const IllustrationConnexion({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _IllustrationPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.52;
    final cy = size.height * 0.52;

    // Ombre sol
    final shadow = Paint()..color = const Color(0x14228545);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.92),
        width: size.width * 0.55,
        height: size.height * 0.08,
      ),
      shadow,
    );

    // Téléphone (grand)
    final phoneW = size.width * 0.28;
    final phoneH = size.height * 0.72;
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx + phoneW * 0.35, cy),
        width: phoneW,
        height: phoneH,
      ),
      const Radius.circular(18),
    );
    canvas.drawRRect(phoneRect, Paint()..color = Design.neutreFonce);

    final screen = phoneRect.deflate(6);
    canvas.drawRRect(screen, Paint()..color = Design.blanc);

    // Écran intérieur (fond soft)
    canvas.drawRRect(
      screen.deflate(4),
      Paint()..color = const Color(0xFFF5F3FF),
    );

    // Bouclier
    final shieldCenter = Offset(cx + phoneW * 0.35, cy - phoneH * 0.08);
    final shieldPath = Path()
      ..moveTo(shieldCenter.dx, shieldCenter.dy - 28)
      ..cubicTo(
        shieldCenter.dx + 26,
        shieldCenter.dy - 18,
        shieldCenter.dx + 26,
        shieldCenter.dy + 8,
        shieldCenter.dx,
        shieldCenter.dy + 32,
      )
      ..cubicTo(
        shieldCenter.dx - 26,
        shieldCenter.dy + 8,
        shieldCenter.dx - 26,
        shieldCenter.dy - 18,
        shieldCenter.dx,
        shieldCenter.dy - 28,
      )
      ..close();
    canvas.drawPath(shieldPath, Paint()..color = Design.primaire);

    // Cadenas vert
    final lockPaint = Paint()..color = Design.secondaire;
    final lockCx = shieldCenter.dx;
    final lockCy = shieldCenter.dy + 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(lockCx, lockCy + 6), width: 22, height: 16),
        const Radius.circular(4),
      ),
      lockPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(lockCx, lockCy), width: 14, height: 14),
      3.14,
      3.14,
      false,
      Paint()
        ..color = Design.blanc
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Personnage (silhouette simplifiée à gauche)
    final personX = size.width * 0.28;
    final personY = size.height * 0.58;

    // Tête
    canvas.drawCircle(
      Offset(personX, personY - 52),
      16,
      Paint()..color = const Color(0xFF8B5E3C),
    );
    // Cheveux
    canvas.drawCircle(
      Offset(personX - 2, personY - 58),
      18,
      Paint()..color = const Color(0xFF3B2314),
    );
    canvas.drawCircle(
      Offset(personX, personY - 52),
      14,
      Paint()..color = const Color(0xFF8B5E3C),
    );

    // Corps (robe verte)
    final body = Path()
      ..moveTo(personX - 22, personY + 55)
      ..lineTo(personX - 18, personY - 20)
      ..quadraticBezierTo(personX, personY - 34, personX + 18, personY - 20)
      ..lineTo(personX + 22, personY + 55)
      ..close();
    canvas.drawPath(body, Paint()..color = Design.secondaire);

    // Bras tendu vers le téléphone
    canvas.drawLine(
      Offset(personX + 12, personY - 10),
      Offset(cx, cy + 10),
      Paint()
        ..color = const Color(0xFF8B5E3C)
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';

/// Logo Gab'Pharma (asset officiel).
class LogoGabPharma extends StatelessWidget {
  final double size;
  final bool showSlogan;

  const LogoGabPharma({
    super.key,
    this.size = 56,
    this.showSlogan = true,
  });

  static const asset = 'images/logo_gabpharma.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          asset,
          height: size,
          width: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Icon(
            Icons.local_pharmacy,
            size: size * 0.7,
            color: Design.secondaire,
          ),
        ),
        if (showSlogan) ...[
          const SizedBox(height: Design.s8),
          Text(
            'La santé à portée de main',
            textAlign: TextAlign.center,
            style: Design.body2.copyWith(
              color: Design.texte,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

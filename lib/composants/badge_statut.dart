import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';

enum TypeBadge { succes, attention, info, erreur }

class BadgeStatut extends StatelessWidget {
  final String label;
  final TypeBadge type;

  const BadgeStatut({
    super.key,
    required this.label,
    this.type = TypeBadge.succes,
  });

  Color get _bg {
    switch (type) {
      case TypeBadge.succes:
        return const Color(0xFFDCFCE7);
      case TypeBadge.attention:
        return const Color(0xFFFEF3C7);
      case TypeBadge.info:
        return const Color(0xFFDBEAFE);
      case TypeBadge.erreur:
        return const Color(0xFFFEE2E2);
    }
  }

  Color get _fg {
    switch (type) {
      case TypeBadge.succes:
        return Design.secondaire;
      case TypeBadge.attention:
        return const Color(0xFFB45309);
      case TypeBadge.info:
        return Design.information;
      case TypeBadge.erreur:
        return Design.alerte;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(Design.radiusPill),
      ),
      child: Text(
        label,
        style: Design.caption.copyWith(
          color: _fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class EnTeteSection extends StatelessWidget {
  final String titre;
  final String actionLabel;
  final VoidCallback? onVoirTout;
  final Color? actionColor;

  const EnTeteSection({
    super.key,
    required this.titre,
    this.onVoirTout,
    this.actionLabel = 'Voir tout',
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titre,
            style: Design.h3.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        if (onVoirTout != null)
          GestureDetector(
            onTap: onVoirTout,
            child: Text(
              actionLabel,
              style: Design.body2.copyWith(
                color: actionColor ?? Design.secondaire,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

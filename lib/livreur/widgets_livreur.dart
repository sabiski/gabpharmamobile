import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_auth_livreur.dart';

/// Stepper horizontal 4 étapes (maquette livreur).
class StepperLivreur extends StatelessWidget {
  final int etapeActive;
  final List<String> labels;

  const StepperLivreur({
    super.key,
    required this.etapeActive,
    this.labels = ControllerAuthLivreur.etapesLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Design.s8),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            final leftDone = (i ~/ 2) < etapeActive;
            return Expanded(
              child: Container(
                height: 2,
                color: leftDone ? Design.primaire : Design.bordure,
              ),
            );
          }
          final index = i ~/ 2;
          final done = index < etapeActive;
          final active = index == etapeActive;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active ? Design.primaire : Design.blanc,
                  border: Border.all(
                    color: done || active ? Design.primaire : Design.bordure,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: done
                    ? const Icon(Icons.check, size: 16, color: Design.blanc)
                    : Text(
                        '${index + 1}',
                        style: Design.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: active
                              ? Design.blanc
                              : Design.texteSecondaire,
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[index],
                style: Design.caption.copyWith(
                  fontSize: 10,
                  fontWeight:
                      active ? FontWeight.w600 : FontWeight.w400,
                  color: active || done
                      ? Design.primaire
                      : Design.texteSecondaire,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class ChampLabel extends StatelessWidget {
  final String label;
  final bool requis;
  final Widget child;

  const ChampLabel({
    super.key,
    required this.label,
    required this.child,
    this.requis = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: Design.body1.copyWith(
              fontWeight: FontWeight.w500,
              color: Design.texte,
            ),
            children: [
              if (requis)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Design.erreur),
                ),
            ],
          ),
        ),
        const SizedBox(height: Design.s8),
        child,
      ],
    );
  }
}

class ChipsZones extends StatelessWidget {
  final List<String> selection;
  final List<String> disponibles;
  final ValueChanged<String> onAjouter;
  final ValueChanged<String> onRetirer;

  const ChipsZones({
    super.key,
    required this.selection,
    required this.disponibles,
    required this.onAjouter,
    required this.onRetirer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Design.s12),
          decoration: BoxDecoration(
            color: Design.blanc,
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(color: Design.bordure),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...selection.map(
                (z) => Chip(
                  label: Text(z, style: Design.body2.copyWith(
                    color: Design.information,
                    fontWeight: FontWeight.w500,
                  )),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => onRetirer(z),
                  backgroundColor: const Color(0xFFEFF6FF),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Design.radiusPill),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: onAjouter,
                itemBuilder: (_) => disponibles
                    .where((z) => !selection.contains(z))
                    .map(
                      (z) => PopupMenuItem(value: z, child: Text(z)),
                    )
                    .toList(),
                child: Chip(
                  avatar: const Icon(Icons.add, size: 16, color: Design.primaire),
                  label: Text(
                    'Ajouter',
                    style: Design.body2.copyWith(color: Design.primaire),
                  ),
                  backgroundColor: const Color(0xFFF5F3FF),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Design.radiusPill),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BoutonSuivantLivreur extends StatelessWidget {
  final String texte;
  final VoidCallback? onTap;
  final bool loading;

  const BoutonSuivantLivreur({
    super.key,
    required this.texte,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: loading ? null : onTap,
        style: FilledButton.styleFrom(
          backgroundColor: Design.primaire,
          foregroundColor: Design.blanc,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Design.radiusMd),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                texte,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Design.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Design.blanc,
                ),
              ),
      ),
    );
  }
}

class ZoneUploadDocument extends StatelessWidget {
  final String titre;
  final String sousTitre;
  final bool televerse;
  final VoidCallback onTap;

  const ZoneUploadDocument({
    super.key,
    required this.titre,
    required this.sousTitre,
    required this.televerse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Design.s16),
        decoration: BoxDecoration(
          color: televerse ? const Color(0xFFECFDF5) : Design.blanc,
          borderRadius: BorderRadius.circular(Design.radiusMd),
          border: Border.all(
            color: televerse ? Design.secondaire : Design.bordure,
            style: televerse ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Icon(
              televerse ? Icons.check_circle : Icons.cloud_upload_outlined,
              color: televerse ? Design.secondaire : Design.primaire,
            ),
            const SizedBox(width: Design.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    televerse ? 'Document ajouté' : sousTitre,
                    style: Design.caption,
                  ),
                ],
              ),
            ),
            Icon(
              televerse ? Icons.edit_outlined : Icons.add,
              color: Design.texteSecondaire,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class IllustrationLivreur extends StatelessWidget {
  final double height;

  const IllustrationLivreur({super.key, this.height = 160});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _IllustrationLivreurPainter(),
      ),
    );
  }
}

class _IllustrationLivreurPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.55;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.9),
        width: size.width * 0.45,
        height: size.height * 0.08,
      ),
      Paint()..color = const Color(0x1A6C3AED),
    );

    // Sac à dos
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + 28, cy - 10),
          width: 48,
          height: 58,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = Design.primaire,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + 28, cy - 22),
          width: 28,
          height: 18,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = Design.blanc,
    );

    // Tête
    canvas.drawCircle(
      Offset(cx - 8, cy - 48),
      18,
      Paint()..color = const Color(0xFF8B5E3C),
    );
    // Casque
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - 8, cy - 52), width: 40, height: 36),
      3.4,
      2.5,
      true,
      Paint()..color = Design.primaire,
    );

    // Corps
    final body = Path()
      ..moveTo(cx - 30, cy + 50)
      ..lineTo(cx - 26, cy - 20)
      ..quadraticBezierTo(cx - 8, cy - 32, cx + 12, cy - 18)
      ..lineTo(cx + 18, cy + 50)
      ..close();
    canvas.drawPath(body, Paint()..color = Design.primaire);

    // Téléphone
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx - 36, cy + 4),
          width: 18,
          height: 30,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = Design.neutreFonce,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class IllustrationScooter extends StatelessWidget {
  final double height;

  const IllustrationScooter({super.key, this.height = 72});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 120,
      child: CustomPaint(painter: _ScooterPainter()),
    );
  }
}

class _ScooterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Design.primaire;
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.72), 12, p);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.72), 12, p);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.2, size.height * 0.35, size.width * 0.55, 14),
        const Radius.circular(6),
      ),
      p,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.15, 28, 28),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF8B5CF6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Case à cocher conditions d'utilisation.
class CaseConditions extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CaseConditions({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(value: value, onChanged: onChanged),
        ),
        const SizedBox(width: Design.s8),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: "J'accepte les ",
              style: Design.body2.copyWith(color: Design.texte, height: 1.4),
              children: [
                TextSpan(
                  text: "Conditions d'utilisation",
                  style: Design.body2.copyWith(
                    color: Design.information,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' et la '),
                TextSpan(
                  text: 'Politique de confidentialité',
                  style: Design.body2.copyWith(
                    color: Design.information,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

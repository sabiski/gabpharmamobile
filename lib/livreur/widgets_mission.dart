import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';

/// Zone de signature tactile simple (sans package).
class PadSignature extends StatefulWidget {
  final String nomSignataire;
  final ValueChanged<bool>? onChange;
  final VoidCallback? onEffacer;

  const PadSignature({
    super.key,
    required this.nomSignataire,
    this.onChange,
    this.onEffacer,
  });

  @override
  State<PadSignature> createState() => PadSignatureState();
}

class PadSignatureState extends State<PadSignature> {
  final _traits = <List<Offset>>[];
  List<Offset>? _traitCourant;

  bool get aSigne => _traits.any((t) => t.length > 2);

  void effacer() {
    setState(() {
      _traits.clear();
      _traitCourant = null;
    });
    widget.onChange?.call(false);
    widget.onEffacer?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: Design.blanc,
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(color: Design.bordure),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Design.radiusMd),
            child: GestureDetector(
              onPanStart: (d) {
                setState(() {
                  _traitCourant = [d.localPosition];
                  _traits.add(_traitCourant!);
                });
              },
              onPanUpdate: (d) {
                setState(() {
                  _traitCourant?.add(d.localPosition);
                });
              },
              onPanEnd: (_) {
                widget.onChange?.call(aSigne);
                _traitCourant = null;
              },
              child: CustomPaint(
                painter: _SignaturePainter(_traits),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        const SizedBox(height: Design.s8),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.nomSignataire,
                style: Design.caption.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            TextButton.icon(
              onPressed: effacer,
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(
                'Effacer',
                style: Design.caption.copyWith(color: Design.texteSecondaire),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> traits;

  _SignaturePainter(this.traits);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Design.texte
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final trait in traits) {
      if (trait.length < 2) continue;
      final path = Path()..moveTo(trait.first.dx, trait.first.dy);
      for (var i = 1; i < trait.length; i++) {
        path.lineTo(trait[i].dx, trait[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}

/// En-tête livreur commun (logo + notifs + Urgence).
class EnteteLivreur extends StatelessWidget {
  final int badgeNotifs;
  final VoidCallback? onUrgence;
  final VoidCallback? onRetour;
  final String labelUrgence;

  const EnteteLivreur({
    super.key,
    this.badgeNotifs = 5,
    this.onUrgence,
    this.onRetour,
    this.labelUrgence = 'Urgence',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Design.s8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onRetour ?? () => Navigator.maybePop(context),
          ),
          const Expanded(
            child: Column(
              children: [
                Text(
                  "Gab'Pharma",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Design.texte,
                  ),
                ),
                Text(
                  'Livreur',
                  style: TextStyle(fontSize: 11, color: Design.texteSecondaire),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              if (badgeNotifs > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Design.erreur,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$badgeNotifs',
                      style: const TextStyle(
                        color: Design.blanc,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Flexible(
            child: FilledButton(
              onPressed: onUrgence,
              style: FilledButton.styleFrom(
                backgroundColor: Design.erreur,
                foregroundColor: Design.blanc,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Design.radiusSm),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emergency, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      labelUrgence,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Design.caption.copyWith(
                        color: Design.blanc,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stepper mission : Récupération → En route → Livraison.
class StepperMission extends StatelessWidget {
  final int etape; // 0, 1, 2

  const StepperMission({super.key, required this.etape});

  static const _labels = ['Récupération', 'En route', 'Livraison'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Design.s16),
      child: Row(
        children: List.generate(_labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            final left = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: left < etape ? Design.primaire : Design.bordure,
              ),
            );
          }
          final index = i ~/ 2;
          final done = index < etape;
          final active = index == etape;
          return Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active ? Design.primaire : Design.blanc,
                  border: Border.all(
                    color: done || active ? Design.primaire : Design.bordure,
                    width: 2,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check, size: 14, color: Design.blanc)
                    : Center(
                        child: Text(
                          '${index + 1}',
                          style: Design.caption.copyWith(
                            color: active ? Design.blanc : Design.texteSecondaire,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                _labels[index],
                style: Design.caption.copyWith(
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active || done ? Design.primaire : Design.texteSecondaire,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

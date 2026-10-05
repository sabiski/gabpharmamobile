import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_mission.dart';
import 'package:gabpharmamobile/maps/maps_markers.dart';
import 'package:gabpharmamobile/maps/widgets/carte_gabpharma.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Mission d'urgence — livraison critique affectée au livreur.
class MissionUrgence extends StatefulWidget {
  const MissionUrgence({super.key});

  @override
  State<MissionUrgence> createState() => _MissionUrgenceState();
}

class _MissionUrgenceState extends State<MissionUrgence> {
  final _c = Get.find<ControllerLivraisonLivreur>();
  late int _secondesRestantes;
  Timer? _timer;
  int _etapeMission = 0;

  @override
  void initState() {
    super.initState();
    _secondesRestantes = 18 * 60 + 45; // 18:45 démo
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondesRestantes <= 0) {
        _timer?.cancel();
        return;
      }
      setState(() => _secondesRestantes--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _chrono {
    final m = (_secondesRestantes ~/ 60).toString().padLeft(2, '0');
    final s = (_secondesRestantes % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.fond,
      body: SafeArea(
        child: Obx(() {
          final l = _c.livraison.value;
          if (l == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              EnteteLivreur(
                labelUrgence: 'Urgence',
                onUrgence: _c.urgencePersonnelle,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    Design.s16,
                    Design.s8,
                    Design.s16,
                    Design.s24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeroUrgence(chrono: _chrono),
                      const SizedBox(height: Design.s12),
                      Row(
                        children: [
                          Expanded(
                            child: _MiniContact(
                              titre: l.pharmacie.nom,
                              sousTitre: l.pharmacie.adresse,
                              tel: l.pharmacie.telephone,
                              couleur: Design.secondaire,
                              onAppeler: () =>
                                  _c.appeler(l.pharmacie.telephone),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Design.erreur,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: _MiniContact(
                              titre: 'Client ${l.client.nom}',
                              sousTitre: l.client.telephone,
                              tel: l.client.telephone,
                              couleur: Design.primaire,
                              onAppeler: () => _c.appeler(l.client.telephone),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(
                                Design.radiusMd,
                              ),
                              border: Border.all(color: Design.erreur),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Niveau',
                                  style: Design.caption.copyWith(fontSize: 9),
                                ),
                                const Icon(
                                  Icons.priority_high,
                                  color: Design.erreur,
                                  size: 18,
                                ),
                                Text(
                                  'CRITIQUE',
                                  style: Design.caption.copyWith(
                                    color: Design.erreur,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Design.s12),
                      Container(
                        padding: const EdgeInsets.all(Design.s12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Design.erreur,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Motif de l\'urgence : Malaise / Douleur intense',
                                    style: Design.body2.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Design.texte,
                                    ),
                                  ),
                                  Text(
                                    'Le client a besoin de son médicament le plus rapidement possible.',
                                    style: Design.caption.copyWith(
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Design.s16),
                      Text(
                        'Itinéraire',
                        style: Design.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: Design.s8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _LieuLigne(
                                  couleur: Design.secondaire,
                                  titre: 'Récupérer le médicament',
                                  adresse: l.pharmacie.adresse,
                                  nom: l.pharmacie.nom,
                                ),
                                const SizedBox(height: 8),
                                _LieuLigne(
                                  couleur: Design.erreur,
                                  titre: 'Livrer au client',
                                  adresse: l.client.adresse,
                                  nom: 'À côté de l\'école publique',
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Distance : ${l.distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km',
                                  style: Design.body2.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Design.texte,
                                  ),
                                ),
                                Text(
                                  'Temps estimé : ≈ ${l.dureeMinutes + 3} min',
                                  style: Design.caption,
                                ),
                                TextButton.icon(
                                  onPressed: () =>
                                      Get.toNamed(Routes.carteSuiviLivreur),
                                  icon: const Icon(
                                    Icons.map_outlined,
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Voir sur la carte',
                                    style: Design.caption.copyWith(
                                      color: Design.primaire,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: CarteGabPharma(
                              height: 140,
                              afficherDistance: false,
                              myLocationEnabled: false,
                              points: [
                                PointCarte(
                                  id: 'ph',
                                  titre: l.pharmacie.nom,
                                  position: l.pharmacie.position,
                                  type: TypeMarqueurMaps.pharmacie,
                                ),
                                PointCarte(
                                  id: 'cl',
                                  titre: l.client.nom,
                                  position: l.client.position,
                                  type: TypeMarqueurMaps.client,
                                ),
                              ],
                              origineItineraire: l.pharmacie.position,
                              destinationItineraire: l.client.position,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Design.s12),
                      Container(
                        padding: const EdgeInsets.all(Design.s12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Design.information,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Instructions importantes',
                                  style: Design.body2.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Design.texte,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '• Partez immédiatement vers la pharmacie.\n'
                              '• Conduisez prudemment malgré l\'urgence.\n'
                              '• Confirmez chaque étape dans l\'application.',
                              style: Design.caption.copyWith(
                                height: 1.4,
                                color: Design.texte,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Design.s12),
                      Container(
                        padding: const EdgeInsets.all(Design.s12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              color: Design.secondaire,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informations sur la commande',
                                    style: Design.body2.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Design.texte,
                                    ),
                                  ),
                                  Text(
                                    '#${l.reference} · ${l.articles.length} médicament(s)',
                                    style: Design.caption,
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed(Routes.detailLivraisonLivreur),
                              child: Text(
                                'Voir le détail >',
                                style: Design.caption.copyWith(
                                  color: Design.secondaire,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Design.s12),
                      Row(
                        children: [
                          _ActionCarre(
                            icone: Icons.phone_outlined,
                            label: 'Appeler client',
                            onTap: () => _c.appeler(l.client.telephone),
                          ),
                          _ActionCarre(
                            icone: Icons.local_pharmacy_outlined,
                            label: 'Pharmacien',
                            onTap: () => _c.appeler(l.pharmacie.telephone),
                          ),
                          _ActionCarre(
                            icone: Icons.chat_bubble_outline,
                            label: 'Chat',
                            onTap: () => _c.message(l.client.nom),
                          ),
                          _ActionCarre(
                            icone: Icons.navigation_outlined,
                            label: 'Itinéraire',
                            onTap: () =>
                                Get.toNamed(Routes.carteSuiviLivreur),
                          ),
                        ],
                      ),
                      const SizedBox(height: Design.s16),
                      Text(
                        'Étapes de la mission',
                        style: Design.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: Design.s12),
                      _StepperUrgence(etape: _etapeMission),
                      const SizedBox(height: Design.s24),
                      FilledButton.icon(
                        onPressed: () {
                          setState(() => _etapeMission = 1);
                          _c.demarrerMissionUrgence();
                          Get.toNamed(Routes.validationRecuperation);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Design.secondaire,
                          foregroundColor: Design.blanc,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Design.radiusMd,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.two_wheeler),
                        label: Text(
                          'Je pars immédiatement — Démarrer',
                          style: Design.body1.copyWith(
                            color: Design.blanc,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: Design.s8),
                      OutlinedButton.icon(
                        onPressed: _c.signalerProbleme,
                        icon: const Icon(
                          Icons.flag_outlined,
                          color: Design.primaire,
                        ),
                        label: Text(
                          "J'ai un problème — Signaler",
                          style: Design.body1.copyWith(
                            color: Design.primaire,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Design.primaire),
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                      const SizedBox(height: Design.s8),
                      OutlinedButton.icon(
                        onPressed: () {
                          Get.snackbar(
                            'Mission annulée',
                            'Annulation mission urgence à brancher (API).',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          Get.back();
                        },
                        icon: const Icon(Icons.close, color: Design.erreur),
                        label: Text(
                          'Annuler la mission — Non réalisé',
                          style: Design.body1.copyWith(color: Design.erreur),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Design.erreur),
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _HeroUrgence extends StatelessWidget {
  final String chrono;
  const _HeroUrgence({required this.chrono});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Design.s16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
        ),
        borderRadius: BorderRadius.circular(Design.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(Icons.emergency, color: Design.blanc, size: 36),
          const SizedBox(width: Design.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MISSION D'URGENCE",
                  style: Design.h3.copyWith(
                    color: Design.blanc,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Vous avez été affecté à une livraison urgente !',
                  style: Design.caption.copyWith(color: Design.blanc),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Design.blanc,
              borderRadius: BorderRadius.circular(Design.radiusMd),
            ),
            child: Column(
              children: [
                Text(
                  'Temps restant',
                  style: Design.caption.copyWith(fontSize: 9),
                ),
                Text(
                  chrono,
                  style: Design.h2.copyWith(
                    color: Design.erreur,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 12,
                      color: Design.secondaire,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Dans le temps',
                      style: Design.caption.copyWith(
                        fontSize: 9,
                        color: Design.secondaire,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniContact extends StatelessWidget {
  final String titre;
  final String sousTitre;
  final String tel;
  final Color couleur;
  final VoidCallback onAppeler;

  const _MiniContact({
    required this.titre,
    required this.sousTitre,
    required this.tel,
    required this.couleur,
    required this.onAppeler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: Design.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: Design.texte,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            sousTitre,
            style: Design.caption.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          GestureDetector(
            onTap: onAppeler,
            child: Text(
              tel,
              style: Design.caption.copyWith(
                color: couleur,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LieuLigne extends StatelessWidget {
  final Color couleur;
  final String titre;
  final String nom;
  final String adresse;

  const _LieuLigne({
    required this.couleur,
    required this.titre,
    required this.nom,
    required this.adresse,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.place, color: couleur, size: 20),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titre,
                style: Design.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: couleur,
                ),
              ),
              Text(nom, style: Design.caption.copyWith(color: Design.texte)),
              Text(adresse, style: Design.caption.copyWith(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCarre extends StatelessWidget {
  final IconData icone;
  final String label;
  final VoidCallback onTap;

  const _ActionCarre({
    required this.icone,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Design.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Design.blanc,
              borderRadius: BorderRadius.circular(Design.radiusMd),
              border: Border.all(color: Design.bordure),
            ),
            child: Column(
              children: [
                Icon(icone, color: Design.primaire, size: 20),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Design.caption.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Design.texte,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepperUrgence extends StatelessWidget {
  final int etape;
  const _StepperUrgence({required this.etape});

  static const _labels = [
    'Je pars\nimmédiatement',
    'Récupération',
    'En route',
    'Livraison',
    'Terminée',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final left = i ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              color: left < etape ? Design.secondaire : Design.bordure,
            ),
          );
        }
        final index = i ~/ 2;
        final done = index <= etape;
        return Column(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? Design.secondaire : Design.blanc,
                border: Border.all(
                  color: done ? Design.secondaire : Design.bordure,
                  width: 2,
                ),
              ),
              child: Center(
                child: done && index < etape
                    ? const Icon(Icons.check, size: 12, color: Design.blanc)
                    : Text(
                        '${index + 1}',
                        style: Design.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: done ? Design.blanc : Design.texteSecondaire,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 56,
              child: Text(
                _labels[index],
                textAlign: TextAlign.center,
                style: Design.caption.copyWith(
                  fontSize: 8,
                  height: 1.15,
                  fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                  color: done ? Design.secondaire : Design.texteSecondaire,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

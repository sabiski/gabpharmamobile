import 'package:flutter/material.dart';
import 'package:gabpharmamobile/composants/logo_gabpharma.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_livreur.dart';
import 'package:gabpharmamobile/maps/maps_markers.dart';
import 'package:gabpharmamobile/maps/widgets/carte_gabpharma.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Carte & Suivi GPS (Écran 7 livreur).
class CarteSuiviLivreur extends StatelessWidget {
  const CarteSuiviLivreur({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerLivraisonLivreur>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Obx(() {
          final l = c.livraison.value;
          if (l == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Design.s12,
                  vertical: Design.s8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Get.back(),
                    ),
                    const Expanded(
                      child: Column(
                        children: [
                          LogoGabPharma(size: 28, showSlogan: false),
                          Text(
                            'Livreur',
                            style: TextStyle(
                              fontSize: 11,
                              color: Design.texteSecondaire,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {},
                        ),
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
                              '${c.messagesNonLus.value}',
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
                    FilledButton.icon(
                      onPressed: c.urgence,
                      style: FilledButton.styleFrom(
                        backgroundColor: Design.erreur,
                        foregroundColor: Design.blanc,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: const Size(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Design.radiusSm),
                        ),
                      ),
                      icon: const Icon(Icons.emergency, size: 16),
                      label: Text(
                        'Urgence',
                        style: Design.caption.copyWith(
                          color: Design.blanc,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    Design.s16,
                    0,
                    Design.s16,
                    Design.s16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Carte & Suivi GPS', style: Design.h2),
                      Text(
                        'Suivez votre itinéraire de livraison en temps réel',
                        style: Design.caption,
                      ),
                      const SizedBox(height: Design.s12),
                      Container(
                        padding: const EdgeInsets.all(Design.s12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Design.secondaire,
                            ),
                            const SizedBox(width: Design.s8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Livraison en cours',
                                        style: Design.body1.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Design.secondaire,
                                          borderRadius: BorderRadius.circular(
                                            Design.radiusPill,
                                          ),
                                        ),
                                        child: Text(
                                          'En cours',
                                          style: Design.caption.copyWith(
                                            color: Design.blanc,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${l.reference} | ${l.pharmacie.nom} → ${l.client.nom}',
                                    style: Design.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Design.s12),
                      CarteGabPharma(
                        height: 240,
                        afficherDistance: false,
                        points: [
                          PointCarte(
                            id: 'pharma',
                            titre: l.pharmacie.nom,
                            sousTitre: 'Point de retrait',
                            position: l.pharmacie.position,
                            type: TypeMarqueurMaps.pharmacie,
                          ),
                          PointCarte(
                            id: 'client',
                            titre: l.client.nom,
                            sousTitre: 'Client',
                            position: l.client.position,
                            type: TypeMarqueurMaps.client,
                          ),
                          PointCarte(
                            id: 'livreur',
                            titre: 'Vous',
                            position: l.positionLivreur,
                            type: TypeMarqueurMaps.livreur,
                          ),
                        ],
                        origineItineraire: l.positionLivreur,
                        destinationItineraire: l.client.position,
                      ),
                      const SizedBox(height: Design.s12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Design.s8,
                          vertical: Design.s12,
                        ),
                        decoration: BoxDecoration(
                          color: Design.blanc,
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                          border: Border.all(color: Design.bordure),
                        ),
                        child: Row(
                          children: [
                            _Metric(
                              icone: Icons.place_outlined,
                              valeur:
                                  '${l.distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km',
                              label: 'Distance',
                            ),
                            _sep(),
                            _Metric(
                              icone: Icons.schedule,
                              valeur: '≈ ${l.dureeMinutes} min',
                              label: 'Temps estimé',
                            ),
                            _sep(),
                            _Metric(
                              icone: Icons.speed,
                              valeur: '${l.vitesseKmh.round()} km/h',
                              label: 'Vitesse',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Design.s16),
                      Row(
                        children: [
                          Text(
                            'Détails de la livraison',
                            style: Design.body1.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () =>
                                Get.toNamed(Routes.detailLivraisonLivreur),
                            child: Text(
                              'Voir la commande',
                              style: Design.body2.copyWith(
                                color: Design.primaire,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _LigneLieu(
                        couleur: Design.secondaire,
                        icone: Icons.local_pharmacy,
                        titre: l.pharmacie.nom,
                        adresse: l.pharmacie.adresse,
                        onAppeler: () => c.appeler(l.pharmacie.telephone),
                        onMessage: () => c.message(l.pharmacie.nom),
                      ),
                      const SizedBox(height: Design.s8),
                      _LigneLieu(
                        couleur: Design.erreur,
                        icone: Icons.home_outlined,
                        titre: l.client.nom,
                        adresse: l.client.adresse,
                        onAppeler: () => c.appeler(l.client.telephone),
                        onMessage: () => c.message(l.client.nom),
                      ),
                      const SizedBox(height: Design.s12),
                      Container(
                        padding: const EdgeInsets.all(Design.s12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                          border: Border.all(color: const Color(0xFFFED7AA)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instructions du client',
                              style: Design.body2.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Design.texte,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '« ${l.instructionsClient} »',
                              style: Design.caption.copyWith(
                                color: Design.texte,
                                height: 1.4,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Design.s16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BoutonSuivantLivreur(
                            texte: 'Arrivée chez le client',
                            onTap: c.arriverChezClient,
                          ),
                          const SizedBox(height: Design.s8),
                          OutlinedButton.icon(
                            onPressed: c.signalerProbleme,
                            icon: const Icon(
                              Icons.warning_amber_rounded,
                              color: Design.erreur,
                            ),
                            label: Text(
                              'Signaler un problème',
                              style: Design.body2.copyWith(
                                color: Design.erreur,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Design.erreur,
                              side: const BorderSide(color: Design.erreur),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Design.radiusMd,
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _sep() => Container(
        width: 1,
        height: 36,
        color: Design.bordure,
        margin: const EdgeInsets.symmetric(horizontal: 4),
      );
}

class _Metric extends StatelessWidget {
  final IconData icone;
  final String valeur;
  final String label;

  const _Metric({
    required this.icone,
    required this.valeur,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icone, size: 18, color: Design.primaire),
          const SizedBox(height: 4),
          Text(
            valeur,
            style: Design.body2.copyWith(
              fontWeight: FontWeight.w700,
              color: Design.texte,
            ),
          ),
          Text(label, style: Design.caption),
        ],
      ),
    );
  }
}

class _LigneLieu extends StatelessWidget {
  final Color couleur;
  final IconData icone;
  final String titre;
  final String adresse;
  final VoidCallback onAppeler;
  final VoidCallback onMessage;

  const _LigneLieu({
    required this.couleur,
    required this.icone,
    required this.titre,
    required this.adresse,
    required this.onAppeler,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Design.s12),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: couleur.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icone, color: couleur, size: 20),
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
                Text(adresse, style: Design.caption),
              ],
            ),
          ),
          IconButton(
            onPressed: onAppeler,
            icon: const Icon(Icons.phone_outlined, color: Design.primaire),
          ),
          IconButton(
            onPressed: onMessage,
            icon: const Icon(Icons.chat_bubble_outline, color: Design.primaire),
          ),
        ],
      ),
    );
  }
}

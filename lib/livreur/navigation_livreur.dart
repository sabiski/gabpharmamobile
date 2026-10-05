import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/carte_suivi.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/profil_livreur.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Shell navigation livreur (Accueil / Livraisons / Carte / Messages / Profil).
class NavigationLivreur extends StatelessWidget {
  const NavigationLivreur({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerLivraisonLivreur>();

    return Obx(() {
      final i = c.onglet.value;
      return Scaffold(
        body: IndexedStack(
          index: i,
          children: const [
            _AccueilLivreur(),
            _ListeLivraisons(),
            CarteSuiviLivreur(),
            _PlaceholderLivreur(
              titre: 'Messages',
              description: 'Messagerie livreur à brancher.',
              icone: Icons.chat_bubble_outline,
            ),
            ProfilLivreur(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: c.selectionnerOnglet,
          backgroundColor: Design.blanc,
          indicatorColor: Design.primaire.withValues(alpha: 0.12),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Design.primaire),
              label: 'Accueil',
            ),
            const NavigationDestination(
              icon: Icon(Icons.local_shipping_outlined),
              selectedIcon: Icon(Icons.local_shipping, color: Design.primaire),
              label: 'Livraisons',
            ),
            const NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map, color: Design.primaire),
              label: 'Carte',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: c.messagesNonLus.value > 0,
                label: Text('${c.messagesNonLus.value}'),
                child: const Icon(Icons.chat_bubble_outline),
              ),
              selectedIcon: Badge(
                isLabelVisible: c.messagesNonLus.value > 0,
                label: Text('${c.messagesNonLus.value}'),
                child: const Icon(Icons.chat_bubble, color: Design.primaire),
              ),
              label: 'Messages',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: Design.primaire),
              label: 'Profil',
            ),
          ],
        ),
      );
    });
  }
}

class _AccueilLivreur extends StatelessWidget {
  const _AccueilLivreur();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerLivraisonLivreur>();
    final l = c.livraison.value;

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(title: const Text('Accueil livreur')),
      body: Padding(
        padding: const EdgeInsets.all(Design.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bonjour 👋', style: Design.h2),
            const SizedBox(height: Design.s8),
            Text(
              'Vous avez 1 livraison active.',
              style: Design.body1.copyWith(color: Design.texteSecondaire),
            ),
            const SizedBox(height: Design.s24),
            if (l != null && l.priorite == PrioriteLivraison.haute) ...[
              InkWell(
                onTap: () => Get.toNamed(Routes.missionUrgence),
                borderRadius: BorderRadius.circular(Design.radiusMd),
                child: Container(
                  padding: const EdgeInsets.all(Design.s16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                    ),
                    borderRadius: BorderRadius.circular(Design.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emergency, color: Design.blanc, size: 28),
                      const SizedBox(width: Design.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MISSION D'URGENCE",
                              style: Design.body1.copyWith(
                                color: Design.blanc,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Livraison critique #${l.reference} — Ouvrir',
                              style: Design.caption.copyWith(
                                color: Design.blanc,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Design.blanc),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Design.s12),
            ],
            if (l != null)
              InkWell(
                onTap: () {
                  c.onglet.value = 1;
                  Get.toNamed(Routes.detailLivraisonLivreur);
                },
                borderRadius: BorderRadius.circular(Design.radiusMd),
                child: Container(
                  padding: const EdgeInsets.all(Design.s16),
                  decoration: BoxDecoration(
                    color: Design.blanc,
                    borderRadius: BorderRadius.circular(Design.radiusMd),
                    border: Border.all(color: Design.bordure),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#${l.reference}',
                            style: Design.body1.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(
                                Design.radiusPill,
                              ),
                            ),
                            child: Text(
                              'Haute',
                              style: Design.caption.copyWith(
                                color: Design.erreur,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l.pharmacie.nom} → ${l.client.nom}',
                        style: Design.body2.copyWith(color: Design.texte),
                      ),
                      Text(
                        '${l.distanceKm.toStringAsFixed(1)} km · ≈ ${l.dureeMinutes} min',
                        style: Design.caption,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ListeLivraisons extends StatelessWidget {
  const _ListeLivraisons();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerLivraisonLivreur>();

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(title: const Text('Livraisons')),
      body: Obx(() {
        final l = c.livraison.value;
        if (l == null) {
          return const Center(child: Text('Aucune livraison'));
        }
        return ListView(
          padding: const EdgeInsets.all(Design.s16),
          children: [
            InkWell(
              onTap: () => Get.toNamed(Routes.detailLivraisonLivreur),
              borderRadius: BorderRadius.circular(Design.radiusMd),
              child: Container(
                padding: const EdgeInsets.all(Design.s16),
                decoration: BoxDecoration(
                  color: Design.blanc,
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                  border: Border.all(color: Design.bordure),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Livraison #${l.reference}',
                            style: Design.body1.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Design.texteSecondaire,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${l.pharmacie.nom} → ${l.client.nom}',
                      style: Design.body2.copyWith(color: Design.texte),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(
                              Design.radiusPill,
                            ),
                          ),
                          child: Text(
                            '🔥 Haute priorité',
                            style: Design.caption.copyWith(
                              color: Design.erreur,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${l.distanceKm.toStringAsFixed(1)} km',
                          style: Design.caption.copyWith(
                            fontWeight: FontWeight.w600,
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
    );
  }
}

class _PlaceholderLivreur extends StatelessWidget {
  final String titre;
  final String description;
  final IconData icone;

  const _PlaceholderLivreur({
    required this.titre,
    required this.description,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(title: Text(titre)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Design.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, size: 56, color: Design.primaire),
              const SizedBox(height: Design.s16),
              Text(titre, style: Design.h3),
              const SizedBox(height: Design.s8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Design.body1.copyWith(color: Design.texteSecondaire),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gabpharmamobile/composants/badge_statut.dart';
import 'package:gabpharmamobile/composants/bouton_panier.dart';
import 'package:gabpharmamobile/composants/logo_gabpharma.dart';
import 'package:gabpharmamobile/composants/slider_auto.dart';
import 'package:gabpharmamobile/controllers/controller_accueil.dart';
import 'package:gabpharmamobile/controllers/controller_navigation.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

String _prixFcfa(int montant) {
  final raw = montant.toString();
  final buf = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buf.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
  }
  return '${buf.toString()} FCFA';
}

class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerAccueil>();

    return Scaffold(
      backgroundColor: Design.fond,
      body: SafeArea(
        child: RefreshIndicator(
          color: Design.primaire,
          onRefresh: c.chargerAccueil,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _HeaderAccueil(controller: c)),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Design.s12),
                  child: SliderAutoGabPharma(height: 176),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: Design.s24)),
              SliverToBoxAdapter(child: _FonctionnalitesRapides()),
              const SliverToBoxAdapter(child: SizedBox(height: Design.s24)),
              SliverToBoxAdapter(child: _OffresDuMoment(controller: c)),
              const SliverToBoxAdapter(child: SizedBox(height: Design.s24)),
              SliverToBoxAdapter(child: _PharmaciesProximite(controller: c)),
              const SliverToBoxAdapter(child: SizedBox(height: Design.s16)),
              const SliverToBoxAdapter(child: _BandeauSecurite()),
              const SliverToBoxAdapter(child: SizedBox(height: Design.s24)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderAccueil extends StatelessWidget {
  final ControllerAccueil controller;

  const _HeaderAccueil({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Design.s16,
        Design.s8,
        Design.s16,
        Design.s8,
      ),
      child: Row(
        children: [
          const LogoGabPharma(size: 36, showSlogan: false),
          const SizedBox(width: Design.s8),
          Expanded(
            child: GestureDetector(
              onTap: controller.changerLocalisation,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Design.primaire,
                    size: 22,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Obx(
                      () => Text(
                        controller.localisation.value,
                        style: Design.h3.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Design.texte),
                ],
              ),
            ),
          ),
          const BoutonPanier(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => Get.toNamed(Routes.notifications),
                icon: const Icon(Icons.notifications_outlined),
                color: Design.texte,
              ),
              Obx(() {
                final n = controller.notificationsNonLues.value;
                if (n <= 0) return const SizedBox.shrink();
                return Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Design.primaire,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$n',
                      style: Design.caption.copyWith(
                        color: Design.blanc,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.profil),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Design.primaire.withValues(alpha: 0.15),
              child: const Icon(Icons.person, color: Design.primaire, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _FonctionnalitesRapides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickItem(
        label: 'Rechercher un médicament',
        icone: Icons.search,
        couleur: Design.information,
        onTap: () => Get.find<ControllerNavigation>().recherche(),
      ),
      _QuickItem(
        label: 'Pharmacies à proximité',
        icone: Icons.local_pharmacy_outlined,
        couleur: Design.secondaire,
        onTap: () => Get.toNamed(Routes.pharmacies),
      ),
      _QuickItem(
        label: 'Livraison à domicile',
        icone: Icons.delivery_dining_outlined,
        couleur: Design.primaire,
        onTap: () => Get.toNamed(Routes.commandes),
      ),
      _QuickItem(
        label: 'Mes ordonnances',
        icone: Icons.description_outlined,
        couleur: const Color(0xFFEF4444),
        onTap: () => Get.toNamed(Routes.ordonnances),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Design.s16),
      child: Column(
        children: [
          EnTeteSection(
            titre: 'Fonctionnalités rapides',
            onVoirTout: () {},
          ),
          const SizedBox(height: Design.s16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map(
                  (e) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: e,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _QuickItem extends StatelessWidget {
  final String label;
  final IconData icone;
  final Color couleur;
  final VoidCallback onTap;

  const _QuickItem({
    required this.label,
    required this.icone,
    required this.couleur,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: couleur.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icone, color: couleur, size: 26),
          ),
          const SizedBox(height: Design.s8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Design.caption.copyWith(
              color: Design.texte,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _OffresDuMoment extends StatelessWidget {
  final ControllerAccueil controller;

  const _OffresDuMoment({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Design.s16),
          child: EnTeteSection(
            titre: 'Offres du moment',
            onVoirTout: () {},
          ),
        ),
        const SizedBox(height: Design.s16),
        SizedBox(
          height: 210,
          child: Obx(() {
            final list = controller.offres;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: Design.s16),
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final offre = list[index];
                return _CarteOffre(
                  offre: offre,
                  favori: controller.favorisIds.contains(offre.id),
                  onFavori: () => controller.basculerFavori(offre.id),
                  onTap: () => Get.toNamed(
                    Routes.ficheMedicament,
                    arguments: {'id': offre.id},
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}

class _CarteOffre extends StatelessWidget {
  final OffreMoment offre;
  final bool favori;
  final VoidCallback onFavori;
  final VoidCallback onTap;

  const _CarteOffre({
    required this.offre,
    required this.favori,
    required this.onFavori,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Design.blanc,
          borderRadius: BorderRadius.circular(Design.radiusMd),
          border: Border.all(color: Design.bordure),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 96,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Design.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Design.radiusMd),
                    ),
                  ),
                  child: const Icon(
                    Icons.medication_outlined,
                    size: 42,
                    color: Design.secondaire,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onFavori,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Design.blanc,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        favori ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: favori ? Design.alerte : Design.texteSecondaire,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offre.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Design.body2.copyWith(
                      color: Design.texte,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(offre.forme, style: Design.caption),
                  const SizedBox(height: 4),
                  Text(
                    _prixFcfa(offre.prixFcfa),
                    style: Design.body2.copyWith(
                      color: Design.secondaire,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (offre.disponible)
                    const BadgeStatut(
                      label: 'Disponible',
                      type: TypeBadge.succes,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PharmaciesProximite extends StatelessWidget {
  final ControllerAccueil controller;

  const _PharmaciesProximite({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Design.s16),
      child: Column(
        children: [
          EnTeteSection(
            titre: 'Pharmacies à proximité',
            onVoirTout: () => Get.toNamed(Routes.pharmacies),
          ),
          const SizedBox(height: Design.s16),
          Obx(() {
            return Column(
              children: controller.pharmaciesProximite
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: Design.s8),
                      child: _CartePharmacie(pharmacie: p),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}

class _CartePharmacie extends StatelessWidget {
  final PharmacieProximite pharmacie;

  const _CartePharmacie({required this.pharmacie});

  @override
  Widget build(BuildContext context) {
    final statut = pharmacie.ouvert
        ? (pharmacie.ouvert24h ? 'Ouvert • 24h/24' : 'Ouvert')
        : 'Fermé';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Design.surface,
              borderRadius: BorderRadius.circular(Design.radiusSm),
            ),
            child: const Icon(Icons.local_pharmacy, color: Design.secondaire),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pharmacie.nom,
                  style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Design.attention),
                    const SizedBox(width: 2),
                    Text(
                      '${pharmacie.note} (${pharmacie.avis})',
                      style: Design.caption.copyWith(color: Design.texte),
                    ),
                    Text('  ·  ', style: Design.caption),
                    Text(
                      'À ${pharmacie.distanceKm.toStringAsFixed(1)} km',
                      style: Design.caption,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  statut,
                  style: Design.caption.copyWith(
                    color: pharmacie.ouvert ? Design.secondaire : Design.alerte,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Get.snackbar(
                'Appel',
                pharmacie.telephone ?? 'Numéro indisponible',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(Icons.phone_outlined, color: Design.secondaire),
          ),
          const Icon(Icons.chevron_right, color: Design.texteSecondaire),
        ],
      ),
    );
  }
}

class _BandeauSecurite extends StatelessWidget {
  const _BandeauSecurite();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Design.s16),
      child: Material(
        color: Design.surface,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(Design.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Design.s16,
              vertical: 12,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  color: Design.secondaire,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Vos données sont protégées et sécurisées selon les normes en vigueur.',
                    style: Design.body2.copyWith(
                      color: Design.texte,
                      height: 1.35,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Design.secondaire),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

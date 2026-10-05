import 'package:flutter/material.dart';
import 'package:gabpharmamobile/composants/bouton_panier.dart';
import 'package:gabpharmamobile/controllers/controller_favoris.dart';
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

class Favoris extends StatelessWidget {
  const Favoris({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ControllerFavorisUi());

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(
        backgroundColor: Design.blanc,
        surfaceTintColor: Design.blanc,
        automaticallyImplyLeading: false,
        title: Text(
          'Favoris',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.find<ControllerNavigation>().recherche(),
            icon: const Icon(Icons.search),
          ),
          const BoutonPanier(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => Get.toNamed(Routes.notifications),
                icon: const Icon(Icons.notifications_outlined),
              ),
              Obx(() {
                final n = c.notificationsNonLues.value;
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
                      color: Design.information,
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
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Design.s16,
              Design.s8,
              Design.s16,
              0,
            ),
            child: Obx(() {
              final onglet = c.onglet.value;
              return Row(
                children: [
                  Expanded(
                    child: _TabFavoris(
                      label: 'Pharmacies (${c.pharmacies.length})',
                      selected: onglet == OngletFavoris.pharmacies,
                      onTap: () =>
                          c.changerOnglet(OngletFavoris.pharmacies),
                    ),
                  ),
                  const SizedBox(width: Design.s8),
                  Expanded(
                    child: _TabFavoris(
                      label: 'Médicaments (${c.medicaments.length})',
                      selected: onglet == OngletFavoris.medicaments,
                      onTap: () =>
                          c.changerOnglet(OngletFavoris.medicaments),
                    ),
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value &&
                  c.pharmacies.isEmpty &&
                  c.medicaments.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Design.primaire),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(Design.s16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Design.surface,
                      borderRadius: BorderRadius.circular(Design.radiusMd),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.bookmark_border,
                          color: Design.secondaire,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Retrouvez rapidement vos favoris. Gérez vos pharmacies et médicaments préférés.',
                            style: Design.body2.copyWith(
                              color: Design.texte,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Design.s16),
                  if (c.onglet.value == OngletFavoris.pharmacies) ...[
                    _EnTete(
                      titre: 'Pharmacies favorites',
                      onToutVoir: () {},
                    ),
                    const SizedBox(height: Design.s12),
                    if (c.pharmacies.isEmpty)
                      _Vide(message: 'Aucune pharmacie favorite')
                    else
                      ...c.pharmacies.map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: Design.s8),
                          child: _CartePharmacieFavori(
                            pharmacie: p,
                            onRetirer: () => c.retirerPharmacie(p.id),
                            onAppeler: () => c.appeler(p),
                            onItineraire: () => c.itineraires(p),
                            onMessage: () => c.message(p),
                          ),
                        ),
                      ),
                  ] else ...[
                    _EnTete(
                      titre: 'Médicaments favoris',
                      onToutVoir: () {},
                    ),
                    const SizedBox(height: Design.s12),
                    if (c.medicaments.isEmpty)
                      _Vide(message: 'Aucun médicament favori')
                    else
                      ...c.medicaments.map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: Design.s8),
                          child: _CarteMedicamentFavori(
                            medicament: m,
                            onRetirer: () => c.retirerMedicament(m.id),
                            onTap: () => Get.toNamed(
                              Routes.ficheMedicament,
                              arguments: {'id': m.id},
                            ),
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: Design.s16),
                  OutlinedButton.icon(
                    onPressed: c.ajouterFavori,
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Ajouter un favori'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Design.primaire,
                      side: const BorderSide(color: Design.primaire),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                      ),
                    ),
                  ),
                  const SizedBox(height: Design.s24),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TabFavoris extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabFavoris({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Design.primaire : Design.blanc,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(
              color: selected ? Design.primaire : Design.bordure,
            ),
          ),
          child: Text(
            label,
            style: Design.body2.copyWith(
              fontWeight: FontWeight.w700,
              color: selected ? Design.blanc : Design.texte,
            ),
          ),
        ),
      ),
    );
  }
}

class _EnTete extends StatelessWidget {
  final String titre;
  final VoidCallback onToutVoir;

  const _EnTete({required this.titre, required this.onToutVoir});

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
        GestureDetector(
          onTap: onToutVoir,
          child: Text(
            'Tout voir',
            style: Design.body2.copyWith(
              color: Design.primaire,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _Vide extends StatelessWidget {
  final String message;

  const _Vide({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Design.s24),
      child: Center(child: Text(message, style: Design.body2)),
    );
  }
}

class _CartePharmacieFavori extends StatelessWidget {
  final FavoriPharmacie pharmacie;
  final VoidCallback onRetirer;
  final VoidCallback onAppeler;
  final VoidCallback onItineraire;
  final VoidCallback onMessage;

  const _CartePharmacieFavori({
    required this.pharmacie,
    required this.onRetirer,
    required this.onAppeler,
    required this.onItineraire,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Design.surface,
                  borderRadius: BorderRadius.circular(Design.radiusSm),
                ),
                child: const Icon(
                  Icons.local_pharmacy,
                  color: Design.secondaire,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pharmacie.nom,
                            style: Design.body1.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: pharmacie.ouvert
                                ? const Color(0xFFDCFCE7)
                                : const Color(0xFFFEE2E2),
                            borderRadius:
                                BorderRadius.circular(Design.radiusPill),
                          ),
                          child: Text(
                            pharmacie.ouvert ? 'Ouvert' : 'Fermé',
                            style: Design.caption.copyWith(
                              color: pharmacie.ouvert
                                  ? Design.secondaire
                                  : Design.alerte,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '★ ${pharmacie.note} (${pharmacie.avis})',
                      style: Design.caption,
                    ),
                    Text(pharmacie.adresse, style: Design.caption),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onRetirer,
                child: const Icon(Icons.favorite, color: Design.primaire),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ActionText(label: 'Appeler', onTap: onAppeler),
              const SizedBox(width: 16),
              _ActionText(label: 'Itinéraire', onTap: onItineraire),
              const SizedBox(width: 16),
              _ActionText(label: 'Message', onTap: onMessage),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionText extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionText({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: Design.body2.copyWith(
          color: Design.primaire,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CarteMedicamentFavori extends StatelessWidget {
  final FavoriMedicament medicament;
  final VoidCallback onRetirer;
  final VoidCallback onTap;

  const _CarteMedicamentFavori({
    required this.medicament,
    required this.onRetirer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Design.blanc,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(color: Design.bordure),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Design.surface,
                  borderRadius: BorderRadius.circular(Design.radiusSm),
                ),
                child: const Icon(
                  Icons.medication_outlined,
                  color: Design.secondaire,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicament.nom,
                      style: Design.body1.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(medicament.forme, style: Design.caption),
                    Text(
                      _prixFcfa(medicament.prixFcfa),
                      style: Design.body2.copyWith(
                        color: Design.primaire,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onRetirer,
                child: const Icon(Icons.favorite, color: Design.primaire),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

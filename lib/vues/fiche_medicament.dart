import 'package:flutter/material.dart';
import 'package:gabpharmamobile/composants/badge_statut.dart';
import 'package:gabpharmamobile/controllers/controller_fiche_medicament.dart';
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

class FicheMedicament extends StatelessWidget {
  const FicheMedicament({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerFicheMedicament>();

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(
        backgroundColor: Design.blanc,
        surfaceTintColor: Design.blanc,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: Text(
          'Détails du médicament',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: c.partager,
            icon: const Icon(Icons.share_outlined),
          ),
          Obx(
            () => IconButton(
              onPressed: c.basculerFavori,
              icon: Icon(
                c.estFavori.value ? Icons.favorite : Icons.favorite_border,
                color: c.estFavori.value ? Design.alerte : Design.texte,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value && c.detail.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Design.primaire),
          );
        }
        final d = c.detail.value;
        if (d == null) {
          return Center(
            child: Text('Médicament introuvable', style: Design.body1),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Design.s16,
                  Design.s8,
                  Design.s16,
                  Design.s16,
                ),
                children: [
                  _HeroProduit(detail: d),
                  const SizedBox(height: Design.s16),
                  _SpecsGrid(detail: d),
                  const SizedBox(height: Design.s16),
                  _SectionTexte(
                    titre: 'Description',
                    contenu: Text(d.description, style: Design.body1.copyWith(height: 1.45)),
                    ouverte: c.descriptionOuverte,
                  ),
                  const SizedBox(height: Design.s8),
                  _SectionTexte(
                    titre: 'Composition',
                    contenu: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: d.composition
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(e, style: Design.body1),
                            ),
                          )
                          .toList(),
                    ),
                    ouverte: c.compositionOuverte,
                  ),
                  const SizedBox(height: Design.s8),
                  _SectionTexte(
                    titre: "Conseils d'utilisation",
                    contenu: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: d.conseils
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('•  ', style: Design.body1),
                                  Expanded(
                                    child: Text(
                                      e,
                                      style: Design.body1.copyWith(height: 1.35),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    ouverte: c.conseilsOuverts,
                  ),
                  const SizedBox(height: Design.s16),
                  _BandeauOrdonnance(surOrdonnance: d.surOrdonnance),
                  const SizedBox(height: Design.s24),
                  EnTeteSection(
                    titre: 'Pharmacies disponibles (${d.pharmacies.length})',
                    actionLabel: 'Voir tout',
                    actionColor: Design.primaire,
                    onVoirTout: () => Get.toNamed(Routes.pharmacies),
                  ),
                  const SizedBox(height: 12),
                  ...d.pharmacies.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: Design.s8),
                      child: Obx(
                        () => _CartePharmacieDetail(
                          pharmacie: p,
                          selectionnee: c.pharmacieSelectionneeId.value == p.id,
                          onTap: () => c.selectionnerPharmacie(p.id),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Design.s16),
                  Text(
                    'Options de retrait ou livraison',
                    style: Design.h3.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _OptionsRetrait(controller: c),
                  const SizedBox(height: Design.s24),
                ],
              ),
            ),
            _BarreActions(controller: c),
          ],
        );
      }),
    );
  }
}

class _HeroProduit extends StatelessWidget {
  final DetailMedicament detail;

  const _HeroProduit({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Design.s16),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Design.surface,
              borderRadius: BorderRadius.circular(Design.radiusMd),
            ),
            child: const Icon(
              Icons.medication_outlined,
              size: 48,
              color: Design.secondaire,
            ),
          ),
          const SizedBox(width: Design.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.nom,
                  style: Design.h2.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${detail.forme}\n${detail.principeActif}',
                  style: Design.body2,
                ),
                const SizedBox(height: 8),
                BadgeStockDetail(stock: detail.stock),
                const SizedBox(height: 10),
                Text(
                  _prixFcfa(detail.prixFcfa),
                  style: Design.h2.copyWith(
                    fontSize: 20,
                    color: Design.primaire,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Prix unitaire TTC',
                  style: Design.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BadgeStockDetail extends StatelessWidget {
  final StockDetail stock;

  const BadgeStockDetail({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final IconData icon;
    late final String label;

    switch (stock) {
      case StockDetail.disponible:
        bg = const Color(0xFFDCFCE7);
        fg = Design.secondaire;
        icon = Icons.check_circle_outline;
        label = 'Disponible';
      case StockDetail.stockFaible:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        icon = Icons.warning_amber_rounded;
        label = 'Stock faible';
      case StockDetail.indisponible:
        bg = const Color(0xFFFEE2E2);
        fg = Design.alerte;
        icon = Icons.cancel_outlined;
        label = 'Indisponible';
      case StockDetail.surCommande:
        bg = const Color(0xFFDBEAFE);
        fg = Design.information;
        icon = Icons.schedule;
        label = 'Sur commande';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Design.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: Design.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecsGrid extends StatelessWidget {
  final DetailMedicament detail;

  const _SpecsGrid({required this.detail});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.medication_outlined, 'Forme', detail.forme),
      (Icons.science_outlined, 'Dosage', detail.dosage),
      (Icons.inventory_2_outlined, 'Conditionnement', detail.conditionnement),
      (Icons.person_outline, 'Âge', detail.age),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Design.s16, horizontal: 8),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusLg),
      ),
      child: Row(
        children: items
            .map(
              (e) => Expanded(
                child: Column(
                  children: [
                    Icon(e.$1, color: Design.primaire, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      e.$2,
                      style: Design.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Design.texte,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      e.$3,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Design.caption.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SectionTexte extends StatelessWidget {
  final String titre;
  final Widget contenu;
  final RxBool ouverte;

  const _SectionTexte({
    required this.titre,
    required this.contenu,
    required this.ouverte,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Design.s16),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titre,
                  style: Design.h3.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: () => ouverte.value = !ouverte.value,
                  child: Text(
                    ouverte.value ? 'Voir moins' : 'Voir plus',
                    style: Design.body2.copyWith(
                      color: Design.primaire,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Design.s8),
          Obx(() {
            return ouverte.value
                ? contenu
                : DefaultTextStyle(
                    style: Design.body1.copyWith(height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    child: contenu,
                  );
          }),
        ],
      ),
    );
  }
}

class _BandeauOrdonnance extends StatelessWidget {
  final bool surOrdonnance;

  const _BandeauOrdonnance({required this.surOrdonnance});

  @override
  Widget build(BuildContext context) {
    final bg = surOrdonnance ? const Color(0xFFFEF3C7) : Design.surface;
    final fg = surOrdonnance ? const Color(0xFFB45309) : Design.secondaire;
    final icon = surOrdonnance
        ? Icons.description_outlined
        : Icons.check_circle_outline;
    final texte = surOrdonnance
        ? 'Ce médicament nécessite une ordonnance. Joignez un fichier PDF/JPG/PNG au checkout.'
        : 'Ce médicament ne nécessite pas d’ordonnance. Veuillez lire attentivement la notice avant utilisation.';

    return Container(
      padding: const EdgeInsets.all(Design.s16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Design.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texte,
              style: Design.body2.copyWith(
                color: Design.texte,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartePharmacieDetail extends StatelessWidget {
  final PharmacieDispo pharmacie;
  final bool selectionnee;
  final VoidCallback onTap;

  const _CartePharmacieDetail({
    required this.pharmacie,
    required this.selectionnee,
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
            border: Border.all(
              color: selectionnee ? Design.primaire : Design.bordure,
              width: selectionnee ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: pharmacie.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Design.radiusSm),
                ),
                child: Icon(Icons.local_pharmacy, color: pharmacie.accent),
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
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (pharmacie.recommande) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Design.primaire.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Recommandée',
                              style: Design.caption.copyWith(
                                color: Design.primaire,
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '★ ${pharmacie.note} · À ${pharmacie.distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km${pharmacie.ouvert24h ? ' · 24h/24' : ''}',
                      style: Design.caption,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _prixFcfa(pharmacie.prixFcfa),
                          style: Design.body2.copyWith(
                            color: Design.primaire,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        BadgeStockDetail(stock: pharmacie.stock),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                selectionnee
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selectionnee ? Design.primaire : Design.bordure,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionsRetrait extends StatelessWidget {
  final ControllerFicheMedicament controller;

  const _OptionsRetrait({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final mode = controller.modeRetrait.value;
      return Row(
        children: [
          Expanded(
            child: _OptionCard(
              selected: mode == ModeRetrait.livraison,
              icone: Icons.delivery_dining_outlined,
              titre: 'Livraison à domicile',
              sousTitre: 'Entre 30 et 60 min',
              prix: '1 000 FCFA',
              onTap: () => controller.selectionnerMode(ModeRetrait.livraison),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _OptionCard(
              selected: mode == ModeRetrait.retrait,
              icone: Icons.shopping_bag_outlined,
              titre: 'Retrait en pharmacie',
              sousTitre: 'Prêt en 15 min',
              prix: 'Gratuit',
              onTap: () => controller.selectionnerMode(ModeRetrait.retrait),
            ),
          ),
        ],
      );
    });
  }
}

class _OptionCard extends StatelessWidget {
  final bool selected;
  final IconData icone;
  final String titre;
  final String sousTitre;
  final String prix;
  final VoidCallback onTap;

  const _OptionCard({
    required this.selected,
    required this.icone,
    required this.titre,
    required this.sousTitre,
    required this.prix,
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
            border: Border.all(
              color: selected ? Design.primaire : Design.bordure,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icone,
                color: selected ? Design.primaire : Design.texteSecondaire,
              ),
              const SizedBox(height: 8),
              Text(
                titre,
                style: Design.body2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Design.texte,
                ),
              ),
              const SizedBox(height: 2),
              Text(sousTitre, style: Design.caption),
              const SizedBox(height: 6),
              Text(
                prix,
                style: Design.body2.copyWith(
                  color: Design.primaire,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarreActions extends StatelessWidget {
  final ControllerFicheMedicament controller;

  const _BarreActions({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Design.s16,
        12,
        Design.s16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Design.blanc,
        border: Border(top: BorderSide(color: Design.bordure)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: controller.ajouterAuPanier,
              icon: const Icon(Icons.shopping_cart_outlined, size: 18),
              label: const Text('Ajouter au panier'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Design.primaire,
                side: const BorderSide(color: Design.primaire),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                ),
                textStyle: Design.body2.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              onPressed: controller.reserver,
              icon: const Icon(Icons.event_available_outlined, size: 18),
              label: const Text('Réserver'),
              style: FilledButton.styleFrom(
                backgroundColor: Design.secondaire,
                foregroundColor: Design.blanc,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                ),
                textStyle: Design.body2.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

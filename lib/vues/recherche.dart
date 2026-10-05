import 'package:flutter/material.dart';
import 'package:gabpharmamobile/composants/badge_statut.dart';
import 'package:gabpharmamobile/composants/bouton_panier.dart';
import 'package:gabpharmamobile/controllers/controller_catalogue.dart';
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

class Recherche extends StatelessWidget {
  const Recherche({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerCatalogue>();
    final nav = Get.find<ControllerNavigation>();

    return Scaffold(
      backgroundColor: Design.blanc,
      body: SafeArea(
        child: Column(
          children: [
            _HeaderRecherche(controller: c, onBack: nav.accueil),
            Expanded(
              child: Obx(() {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _BarreRecherche(controller: c)),
                    if (c.recherchesRecentes.isNotEmpty)
                      SliverToBoxAdapter(child: _RecherchesRecentes(controller: c)),
                    SliverToBoxAdapter(child: _FiltresRapides(controller: c)),
                    if (!c.aRecherche.value)
                      SliverToBoxAdapter(
                        child: _CategoriesPrincipales(controller: c),
                      ),
                    if (c.aRecherche.value) ...[
                      SliverToBoxAdapter(child: _EnteteResultats(controller: c)),
                      if (c.isLoading.value)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(Design.s32),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Design.primaire,
                              ),
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Design.s16,
                          ),
                          sliver: SliverList.separated(
                            itemCount: c.resultats.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: Design.s8),
                            itemBuilder: (context, index) {
                              final item = c.resultats[index];
                              return _CarteResultat(
                                item: item,
                                favori: c.favorisIds.contains(item.id),
                                onFavori: () => c.basculerFavori(item.id),
                                onPanier: () => c.ajouterAuPanier(item),
                                onTap: () => Get.toNamed(
                                  Routes.ficheMedicament,
                                  arguments: {'id': item.id},
                                ),
                              );
                            },
                          ),
                        ),
                      if (!c.isLoading.value && c.resultats.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(Design.s16),
                            child: OutlinedButton(
                              onPressed: () => c.rechercher(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Design.primaire,
                                side: const BorderSide(color: Design.primaire),
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Design.radiusMd,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Voir plus de résultats',
                                style: Design.body1.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Design.primaire,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                    const SliverToBoxAdapter(child: SizedBox(height: Design.s24)),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderRecherche extends StatelessWidget {
  final ControllerCatalogue controller;
  final VoidCallback onBack;

  const _HeaderRecherche({
    required this.controller,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, Design.s16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            color: Design.texte,
          ),
          Expanded(
            child: Text(
              'Recherche de médicaments',
              style: Design.h3.copyWith(fontWeight: FontWeight.w600),
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
        ],
      ),
    );
  }
}

class _BarreRecherche extends StatelessWidget {
  final ControllerCatalogue controller;

  const _BarreRecherche({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Design.s16, Design.s8, Design.s16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.rechercheController,
              textInputAction: TextInputAction.search,
              onSubmitted: controller.rechercher,
              style: Design.body1,
              decoration: InputDecoration(
                hintText:
                    'Rechercher un médicament, un principe actif ou un laboratoire...',
                hintStyle: Design.body2.copyWith(fontSize: 13),
                filled: true,
                fillColor: Design.fond,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Design.texteSecondaire,
                ),
                suffixIcon: IconButton(
                  onPressed: controller.rechercheVocale,
                  icon: const Icon(
                    Icons.mic_none_outlined,
                    color: Design.texteSecondaire,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                  borderSide: const BorderSide(
                    color: Design.primaire,
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: Design.s8),
          Material(
            color: Design.fond,
            borderRadius: BorderRadius.circular(Design.radiusMd),
            child: InkWell(
              onTap: controller.scannerOrdonnance,
              borderRadius: BorderRadius.circular(Design.radiusMd),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.qr_code_scanner_outlined,
                  color: Design.primaire,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecherchesRecentes extends StatelessWidget {
  final ControllerCatalogue controller;

  const _RecherchesRecentes({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Design.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Design.s16),
            child: EnTeteSection(
              titre: 'Recherches récentes',
              actionLabel: 'Tout effacer',
              actionColor: Design.primaire,
              onVoirTout: controller.effacerRecherchesRecentes,
            ),
          ),
          const SizedBox(height: Design.s8),
          SizedBox(
            height: 36,
            child: Obx(() {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: Design.s16),
                scrollDirection: Axis.horizontal,
                itemCount: controller.recherchesRecentes.length,
                separatorBuilder: (_, __) => const SizedBox(width: Design.s8),
                itemBuilder: (context, index) {
                  final term = controller.recherchesRecentes[index];
                  return ActionChip(
                    label: Text(term),
                    onPressed: () => controller.rechercher(term),
                    backgroundColor: Design.primaire.withValues(alpha: 0.1),
                    side: BorderSide.none,
                    labelStyle: Design.body2.copyWith(
                      color: Design.primaire,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Design.radiusPill),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FiltresRapides extends StatelessWidget {
  final ControllerCatalogue controller;

  const _FiltresRapides({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Design.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Design.s16),
            child: EnTeteSection(
              titre: 'Filtres rapides',
              onVoirTout: () {},
            ),
          ),
          const SizedBox(height: Design.s8),
          SizedBox(
            height: 40,
            child: Obx(() {
              final actif = controller.filtreActif.value;
              final items = controller.filtresRapides;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: Design.s16),
                scrollDirection: Axis.horizontal,
                itemCount: items.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: Design.s8),
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    return ActionChip(
                      avatar: const Icon(Icons.add, size: 18),
                      label: const Text('Plus'),
                      onPressed: () {},
                      backgroundColor: Design.fond,
                      side: const BorderSide(color: Design.bordure),
                      labelStyle: Design.body2.copyWith(color: Design.texte),
                    );
                  }
                  final f = items[index];
                  final selected = f.id == actif;
                  return FilterChip(
                    selected: selected,
                    showCheckmark: false,
                    avatar: Icon(
                      f.icone,
                      size: 16,
                      color: selected ? Design.blanc : Design.texteSecondaire,
                    ),
                    label: Text(f.label),
                    onSelected: (_) => controller.selectionnerFiltre(f.id),
                    selectedColor: Design.secondaire,
                    backgroundColor: Design.blanc,
                    side: BorderSide(
                      color: selected ? Design.secondaire : Design.bordure,
                    ),
                    labelStyle: Design.body2.copyWith(
                      color: selected ? Design.blanc : Design.texte,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CategoriesPrincipales extends StatelessWidget {
  final ControllerCatalogue controller;

  const _CategoriesPrincipales({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cats = controller.categoriesPrincipales;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Design.s16,
        Design.s24,
        Design.s16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catégories principales',
            style: Design.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Design.s16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final cat = cats[index];
              return GestureDetector(
                onTap: () => controller.selectionnerCategorie(cat),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: cat.couleur.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cat.icone, color: cat.couleur, size: 26),
                    ),
                    const SizedBox(height: Design.s8),
                    Text(
                      cat.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Design.caption.copyWith(
                        color: Design.texte,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EnteteResultats extends StatelessWidget {
  final ControllerCatalogue controller;

  const _EnteteResultats({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Design.s16,
        Design.s24,
        Design.s16,
        Design.s8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              final q = controller.queryActive.value;
              return Text.rich(
                TextSpan(
                  text: 'Résultats',
                  style: Design.h3.copyWith(fontWeight: FontWeight.w600),
                  children: [
                    if (q.isNotEmpty)
                      TextSpan(
                        text: ' pour "$q"',
                        style: Design.body1.copyWith(
                          color: Design.texteSecondaire,
                        ),
                      ),
                    TextSpan(
                      text: ' (${controller.totalResultats.value})',
                      style: Design.body2.copyWith(
                        color: Design.texteSecondaire,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          Obx(() {
            return PopupMenuButton<TriRecherche>(
              initialValue: controller.tri.value,
              onSelected: controller.changerTri,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _labelTri(controller.tri.value),
                    style: Design.body2.copyWith(
                      color: Design.primaire,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: Design.primaire,
                  ),
                ],
              ),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: TriRecherche.pertinence,
                  child: Text('Pertinence'),
                ),
                const PopupMenuItem(
                  value: TriRecherche.prixAsc,
                  child: Text('Prix croissant'),
                ),
                const PopupMenuItem(
                  value: TriRecherche.prixDesc,
                  child: Text('Prix décroissant'),
                ),
                const PopupMenuItem(
                  value: TriRecherche.distance,
                  child: Text('Distance'),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _labelTri(TriRecherche t) {
    switch (t) {
      case TriRecherche.pertinence:
        return 'Pertinence';
      case TriRecherche.prixAsc:
        return 'Prix ↑';
      case TriRecherche.prixDesc:
        return 'Prix ↓';
      case TriRecherche.distance:
        return 'Distance';
    }
  }
}

class _CarteResultat extends StatelessWidget {
  final ResultatRecherche item;
  final bool favori;
  final VoidCallback onFavori;
  final VoidCallback onPanier;
  final VoidCallback onTap;

  const _CarteResultat({
    required this.item,
    required this.favori,
    required this.onFavori,
    required this.onPanier,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Design.surface,
                  borderRadius: BorderRadius.circular(Design.radiusSm),
                ),
                child: const Icon(
                  Icons.medication_outlined,
                  color: Design.secondaire,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            children: [
                              Text(
                                item.nom,
                                style: Design.body1.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (item.top)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Design.primaire,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'TOP',
                                    style: Design.caption.copyWith(
                                      color: Design.blanc,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onFavori,
                          child: Icon(
                            favori ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: favori
                                ? Design.alerte
                                : Design.texteSecondaire,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.forme} · ${item.principeActif}',
                      style: Design.caption,
                    ),
                    const SizedBox(height: 4),
                    _StockLabel(stock: item.stock),
                    const SizedBox(height: 4),
                    Text(
                      '${item.pharmacie} · À ${item.distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km${item.ouvert24h ? ' · 24h/24' : ''}',
                      style: Design.caption.copyWith(color: Design.texte),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _prixFcfa(item.prixFcfa),
                            style: Design.body1.copyWith(
                              color: Design.primaire,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Material(
                          color: Design.primaire,
                          borderRadius: BorderRadius.circular(Design.radiusSm),
                          child: InkWell(
                            onTap: onPanier,
                            borderRadius: BorderRadius.circular(
                              Design.radiusSm,
                            ),
                            child: const SizedBox(
                              width: 36,
                              height: 36,
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: Design.blanc,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StockLabel extends StatelessWidget {
  final StockStatut stock;

  const _StockLabel({required this.stock});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    switch (stock) {
      case StockStatut.disponible:
        color = Design.secondaire;
        label = 'Disponible';
      case StockStatut.stockFaible:
        color = Design.attention;
        label = 'Stock faible';
      case StockStatut.indisponible:
        color = Design.alerte;
        label = 'Indisponible';
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Design.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

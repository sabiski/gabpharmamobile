import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_navigation.dart';
import 'package:gabpharmamobile/controllers/controller_panier.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/models/order_model.dart';
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

class Panier extends StatelessWidget {
  const Panier({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerPanier>();

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(
        backgroundColor: Design.blanc,
        surfaceTintColor: Design.blanc,
        leading: IconButton(
          onPressed: () {
            if (Get.key.currentState?.canPop() == true) {
              Get.back();
            } else {
              Get.find<ControllerNavigation>().accueil();
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: Obx(
          () => Text(
            'Mon panier (${c.items.fold<int>(0, (s, e) => s + e.quantite)})',
            style: Design.h3.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.find<ControllerNavigation>().favoris(),
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: Obx(() {
        final vide = c.items.isEmpty;
        if (vide) {
          return _PanierVide(onContinuer: c.continuerAchats);
        }
        final articles = c.items.toList();
        return Column(
          children: [
            const _BandeauSecurite(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Design.s16,
                  Design.s16,
                  Design.s16,
                  Design.s16,
                ),
                children: [
                  ...articles.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: Design.s8),
                      child: _CarteArticle(
                        item: item,
                        onMoins: () => c.changerQuantite(item.medicineId, -1),
                        onPlus: () => c.changerQuantite(item.medicineId, 1),
                        onSupprimer: () => c.retirer(item.medicineId),
                      ),
                    ),
                  ),
                  const SizedBox(height: Design.s8),
                  _BlocOrdonnance(controller: c),
                  const SizedBox(height: Design.s8),
                  _BlocPromo(controller: c),
                  const SizedBox(height: Design.s16),
                  _Recapitulatif(controller: c),
                  const SizedBox(height: Design.s8),
                  const _BandeauLivraison(),
                  const SizedBox(height: Design.s24),
                ],
              ),
            ),
            _BarrePaiement(controller: c),
          ],
        );
      }),
    );
  }
}

class _BandeauSecurite extends StatelessWidget {
  const _BandeauSecurite();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Design.surface,
      padding: const EdgeInsets.symmetric(horizontal: Design.s16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 16, color: Design.secondaire),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Vos données et paiements sont 100% sécurisés',
              style: Design.caption.copyWith(
                color: Design.secondaire,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarteArticle extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onMoins;
  final VoidCallback onPlus;
  final VoidCallback onSupprimer;

  const _CarteArticle({
    required this.item,
    required this.onMoins,
    required this.onPlus,
    required this.onSupprimer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.nom,
                        style: Design.body1.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onSupprimer,
                      child: const Icon(
                        Icons.delete_outline,
                        color: Design.alerte,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                if (item.sousTitre.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(item.sousTitre, style: Design.caption),
                ],
                if (item.surOrdonnance) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Sur ordonnance',
                    style: Design.caption.copyWith(
                      color: Design.attention,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _prixFcfa(item.prixFcfa),
                            style: Design.body1.copyWith(
                              color: Design.primaire,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: item.enStock
                                      ? Design.secondaire
                                      : Design.alerte,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item.enStock ? 'En stock' : 'Rupture',
                                style: Design.caption.copyWith(
                                  color: item.enStock
                                      ? Design.secondaire
                                      : Design.alerte,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _Quantite(
                      value: item.quantite,
                      onMoins: onMoins,
                      onPlus: onPlus,
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

class _Quantite extends StatelessWidget {
  final int value;
  final VoidCallback onMoins;
  final VoidCallback onPlus;

  const _Quantite({
    required this.value,
    required this.onMoins,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Design.fond,
        borderRadius: BorderRadius.circular(Design.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QteBtn(icon: Icons.remove, onTap: onMoins),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$value',
              style: Design.body1.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _QteBtn(icon: Icons.add, onTap: onPlus),
        ],
      ),
    );
  }
}

class _QteBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QteBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: Design.texte),
      ),
    );
  }
}

class _BlocOrdonnance extends StatelessWidget {
  final ControllerPanier controller;

  const _BlocOrdonnance({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ok = controller.ordonnanceAjoutee.value;
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Design.primaire.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Design.radiusMd),
        ),
        child: Row(
          children: [
            Icon(
              ok ? Icons.check_circle_outline : Icons.description_outlined,
              color: Design.primaire,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ok
                    ? 'Ordonnance ajoutée'
                    : 'Vous avez une ordonnance ?',
                style: Design.body2.copyWith(
                  color: Design.texte,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: controller.ajouterOrdonnance,
              child: Text(
                ok ? 'Remplacer' : 'Ajouter',
                style: Design.body2.copyWith(
                  color: Design.primaire,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _BlocPromo extends StatelessWidget {
  final ControllerPanier controller;

  const _BlocPromo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, color: Design.texteSecondaire),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller.codePromoController,
              style: Design.body1,
              decoration: InputDecoration(
                hintText: 'Code promo ou coupon',
                hintStyle: Design.body2,
                border: InputBorder.none,
              ),
            ),
          ),
          TextButton(
            onPressed: controller.appliquerCodePromo,
            child: Text(
              'Ajouter',
              style: Design.body2.copyWith(
                color: Design.primaire,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Recapitulatif extends StatelessWidget {
  final ControllerPanier controller;

  const _Recapitulatif({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Design.s16),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Récapitulatif de la commande',
              style: Design.h3.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: Design.s16),
            _LigneRecap(
              label: 'Sous-total (${controller.nombreArticles} articles)',
              value: _prixFcfa(controller.sousTotalFcfa),
            ),
            _LigneRecap(
              label: 'Frais de livraison',
              value: _prixFcfa(controller.fraisLivraisonFcfa.value),
              info: true,
            ),
            _LigneRecap(
              label: 'Frais de service',
              value: _prixFcfa(controller.fraisServiceFcfa.value),
              info: true,
            ),
            if (controller.reductionPromoFcfa.value > 0)
              _LigneRecap(
                label: 'Promo (${controller.codePromoApplique.value})',
                value: '- ${_prixFcfa(controller.reductionPromoFcfa.value)}',
                valueColor: Design.secondaire,
              ),
            const Divider(height: 24, color: Design.bordure),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total à payer',
                    style: Design.h3.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  _prixFcfa(controller.totalFcfa),
                  style: Design.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Design.primaire,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _LigneRecap extends StatelessWidget {
  final String label;
  final String value;
  final bool info;
  final Color? valueColor;

  const _LigneRecap({
    required this.label,
    required this.value,
    this.info = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: Design.body2.copyWith(color: Design.texte),
                  ),
                ),
                if (info) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Design.texteSecondaire,
                  ),
                ],
              ],
            ),
          ),
          Text(
            value,
            style: Design.body2.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor ?? Design.texte,
            ),
          ),
        ],
      ),
    );
  }
}

class _BandeauLivraison extends StatelessWidget {
  const _BandeauLivraison();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Design.surface,
        borderRadius: BorderRadius.circular(Design.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            color: Design.secondaire,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Livraison estimée : Aujourd\'hui entre 30 et 60 min',
              style: Design.body2.copyWith(
                color: Design.secondaire,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarrePaiement extends StatelessWidget {
  final ControllerPanier controller;

  const _BarrePaiement({required this.controller});

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final total = controller.totalFcfa;
            final _ = controller.items.length;
            return SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: controller.payerMaintenant,
                style: FilledButton.styleFrom(
                  backgroundColor: Design.secondaire,
                  foregroundColor: Design.blanc,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Design.radiusMd),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, size: 18),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Payer maintenant  ·  ${_prixFcfa(total)}',
                        style: Design.body1.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Design.blanc,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.continuerAchats,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Design.primaire,
                    side: const BorderSide(color: Design.primaire),
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Design.radiusMd),
                    ),
                  ),
                  child: Text(
                    'Continuer les achats',
                    style: Design.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Design.primaire,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Vider le panier ?',
                      middleText: 'Tous les articles seront retirés.',
                      textCancel: 'Annuler',
                      textConfirm: 'Vider',
                      confirmTextColor: Design.blanc,
                      buttonColor: Design.alerte,
                      onConfirm: () {
                        controller.vider();
                        Get.back();
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: Text(
                    'Vider le panier',
                    style: Design.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Design.alerte,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Design.alerte,
                    side: const BorderSide(color: Design.alerte),
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Design.radiusMd),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PanierVide extends StatelessWidget {
  final VoidCallback onContinuer;

  const _PanierVide({required this.onContinuer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Design.s32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: Design.texteSecondaire,
            ),
            const SizedBox(height: Design.s16),
            Text('Votre panier est vide', style: Design.h3),
            const SizedBox(height: Design.s8),
            Text(
              'Ajoutez des médicaments depuis le catalogue.',
              textAlign: TextAlign.center,
              style: Design.body2,
            ),
            const SizedBox(height: Design.s24),
            FilledButton(
              onPressed: onContinuer,
              style: FilledButton.styleFrom(
                backgroundColor: Design.primaire,
                minimumSize: const Size(200, 48),
              ),
              child: const Text('Continuer les achats'),
            ),
          ],
        ),
      ),
    );
  }
}

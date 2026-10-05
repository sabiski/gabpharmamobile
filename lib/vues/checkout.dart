import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_checkout.dart';
import 'package:gabpharmamobile/controllers/controller_panier.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/models/order_model.dart';
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

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    final panier = Get.find<ControllerPanier>();
    final c = Get.find<ControllerCheckout>();

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
          'Paiement sécurisé',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: c.support,
            icon: const Icon(Icons.headset_mic_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          const _BandeauSecurite(),
          Expanded(
            child: Obx(() {
              // Observer panier
              final items = panier.items.toList();
              final _ = panier.fraisLivraisonFcfa.value;
              final __ = panier.fraisServiceFcfa.value;
              final ___ = panier.reductionPromoFcfa.value;

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  const _StepperPaiement(etapeActive: 1),
                  const SizedBox(height: 20),
                  _RecapCommande(
                    items: items,
                    sousTotal: panier.sousTotalFcfa,
                    fraisLivraison: panier.fraisLivraisonFcfa.value,
                    fraisService: panier.fraisServiceFcfa.value,
                    reduction: panier.reductionPromoFcfa.value,
                    total: panier.totalFcfa,
                    nombreArticles: panier.nombreArticles,
                    onModifier: c.retourPanier,
                  ),
                  const SizedBox(height: 20),
                  _MoyensPaiement(controller: c),
                  const SizedBox(height: 12),
                  _BlocPromoCheckout(panier: panier),
                  const SizedBox(height: 20),
                  _Facturation(controller: c),
                  const SizedBox(height: 24),
                ],
              );
            }),
          ),
          _BarrePayer(panier: panier, checkout: c),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, size: 18, color: Design.secondaire),
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

class _StepperPaiement extends StatelessWidget {
  final int etapeActive; // 0 panier, 1 paiement, 2 livraison, 3 confirmation

  const _StepperPaiement({required this.etapeActive});

  @override
  Widget build(BuildContext context) {
    const labels = ['Panier', 'Paiement', 'Livraison', 'Confirmation'];
    return Row(
      children: List.generate(labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final left = i ~/ 2;
          final done = left < etapeActive;
          return Expanded(
            child: Container(
              height: 2,
              color: done ? Design.primaire : Design.bordure,
            ),
          );
        }
        final index = i ~/ 2;
        final active = index == etapeActive;
        final done = index < etapeActive;
        return Column(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active || done ? Design.primaire : Design.blanc,
                shape: BoxShape.circle,
                border: Border.all(
                  color: active || done ? Design.primaire : Design.bordure,
                  width: 1.5,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, size: 14, color: Design.blanc)
                  : Text(
                      '${index + 1}',
                      style: Design.caption.copyWith(
                        color: active ? Design.blanc : Design.texteSecondaire,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              labels[index],
              style: Design.caption.copyWith(
                fontSize: 9,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? Design.primaire : Design.texteSecondaire,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _RecapCommande extends StatelessWidget {
  final List<CartItemModel> items;
  final int sousTotal;
  final int fraisLivraison;
  final int fraisService;
  final int reduction;
  final int total;
  final int nombreArticles;
  final VoidCallback onModifier;

  const _RecapCommande({
    required this.items,
    required this.sousTotal,
    required this.fraisLivraison,
    required this.fraisService,
    required this.reduction,
    required this.total,
    required this.nombreArticles,
    required this.onModifier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  'Récapitulatif de la commande',
                  style: Design.h3.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              GestureDetector(
                onTap: onModifier,
                child: Text(
                  'Modifier',
                  style: Design.body2.copyWith(
                    color: Design.primaire,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Design.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.medication_outlined,
                      color: Design.secondaire,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.nom,
                          style: Design.body2.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Design.texte,
                          ),
                        ),
                        Text('x${e.quantite}', style: Design.caption),
                      ],
                    ),
                  ),
                  Text(
                    _prixFcfa(e.sousTotal),
                    style: Design.body2.copyWith(
                      color: Design.primaire,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 20, color: Design.bordure),
          _Ligne('Sous-total ($nombreArticles articles)', _prixFcfa(sousTotal)),
          _Ligne('Frais de livraison', _prixFcfa(fraisLivraison)),
          _Ligne('Frais de service', _prixFcfa(fraisService)),
          if (reduction > 0)
            _Ligne(
              'Réduction',
              '- ${_prixFcfa(reduction)}',
              valueColor: Design.secondaire,
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total à payer',
                  style: Design.h3.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                _prixFcfa(total),
                style: Design.h3.copyWith(
                  color: Design.primaire,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Ligne extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Ligne(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Design.body2)),
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

class _MoyensPaiement extends StatelessWidget {
  final ControllerCheckout controller;

  const _MoyensPaiement({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisir un moyen de paiement',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final m = controller.methode.value;
          return Column(
            children: [
              _OptionPaiement(
                selected: m == MethodePaiementUi.mobileMoney,
                titre: 'Mobile Money',
                sousTitre: 'Airtel Money · Moov Money',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BadgeOp('Airtel', const Color(0xFFE31C23)),
                    const SizedBox(width: 4),
                    _BadgeOp('Moov', const Color(0xFF0066B3)),
                  ],
                ),
                onTap: () =>
                    controller.selectionnerMethode(MethodePaiementUi.mobileMoney),
              ),
              if (m == MethodePaiementUi.mobileMoney) ...[
                const SizedBox(height: 8),
                _DetailsMobileMoney(controller: controller),
              ],
              const SizedBox(height: 8),
              _OptionPaiement(
                selected: m == MethodePaiementUi.carte,
                titre: 'Carte bancaire',
                sousTitre: 'Visa · Mastercard',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BadgeOp('Visa', const Color(0xFF1A1F71)),
                    const SizedBox(width: 4),
                    _BadgeOp('MC', const Color(0xFFEB001B)),
                  ],
                ),
                onTap: () =>
                    controller.selectionnerMethode(MethodePaiementUi.carte),
              ),
              if (m == MethodePaiementUi.carte) ...[
                const SizedBox(height: 8),
                _DetailsCarte(controller: controller),
              ],
              const SizedBox(height: 8),
              _OptionPaiement(
                selected: m == MethodePaiementUi.portefeuille,
                titre: 'Portefeuille Gab\'Pharma',
                sousTitre:
                    'Solde : ${_prixFcfa(controller.soldePortefeuilleFcfa.value)}',
                sousTitreColor: Design.secondaire,
                onTap: () => controller
                    .selectionnerMethode(MethodePaiementUi.portefeuille),
              ),
              const SizedBox(height: 8),
              _OptionPaiement(
                selected: m == MethodePaiementUi.aLaLivraison,
                titre: 'Paiement à la livraison',
                sousTitre: 'Payez en espèces à la réception',
                onTap: () => controller
                    .selectionnerMethode(MethodePaiementUi.aLaLivraison),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _BadgeOp extends StatelessWidget {
  final String label;
  final Color color;

  const _BadgeOp(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Design.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 9,
        ),
      ),
    );
  }
}

class _OptionPaiement extends StatelessWidget {
  final bool selected;
  final String titre;
  final String sousTitre;
  final Color? sousTitreColor;
  final Widget? trailing;
  final VoidCallback onTap;

  const _OptionPaiement({
    required this.selected,
    required this.titre,
    required this.sousTitre,
    required this.onTap,
    this.sousTitreColor,
    this.trailing,
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(
              color: selected ? Design.primaire : Design.bordure,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selected ? Design.primaire : Design.bordure,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titre,
                      style: Design.body1.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      sousTitre,
                      style: Design.caption.copyWith(
                        color: sousTitreColor ?? Design.texteSecondaire,
                        fontWeight: sousTitreColor != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsMobileMoney extends StatelessWidget {
  final ControllerCheckout controller;

  const _DetailsMobileMoney({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Design.fond,
        borderRadius: BorderRadius.circular(Design.radiusMd),
      ),
      child: Column(
        children: [
          Obx(() {
            final op = controller.operateurMm.value;
            return Row(
              children: [
                Expanded(
                  child: _ChipOp(
                    label: 'Airtel Money',
                    selected: op == 'airtel',
                    onTap: () => controller.operateurMm.value = 'airtel',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ChipOp(
                    label: 'Moov Money',
                    selected: op == 'moov',
                    onTap: () => controller.operateurMm.value = 'moov',
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          TextField(
            controller: controller.telephoneMmController,
            keyboardType: TextInputType.phone,
            style: Design.body1,
            decoration: InputDecoration(
              hintText: 'Numéro Mobile Money',
              hintStyle: Design.body2,
              filled: true,
              fillColor: Design.blanc,
              prefixIcon: const Icon(Icons.phone_android_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Design.radiusMd),
                borderSide: const BorderSide(color: Design.bordure),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Design.radiusMd),
                borderSide: const BorderSide(color: Design.bordure),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipOp extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChipOp({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Design.primaire.withValues(alpha: 0.12) : Design.blanc,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? Design.primaire : Design.bordure,
          ),
        ),
        child: Text(
          label,
          style: Design.body2.copyWith(
            fontWeight: FontWeight.w700,
            color: selected ? Design.primaire : Design.texte,
          ),
        ),
      ),
    );
  }
}

class _DetailsCarte extends StatelessWidget {
  final ControllerCheckout controller;

  const _DetailsCarte({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Design.fond,
        borderRadius: BorderRadius.circular(Design.radiusMd),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller.numeroCarteController,
            keyboardType: TextInputType.number,
            style: Design.body1,
            decoration: InputDecoration(
              hintText: 'Numéro de carte',
              hintStyle: Design.body2,
              filled: true,
              fillColor: Design.blanc,
              prefixIcon: const Icon(Icons.credit_card),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Design.radiusMd),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Design.radiusMd),
                borderSide: const BorderSide(color: Design.bordure),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.expirationController,
                  style: Design.body1,
                  decoration: InputDecoration(
                    hintText: 'MM/AA',
                    hintStyle: Design.body2,
                    filled: true,
                    fillColor: Design.blanc,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Design.radiusMd),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Design.radiusMd),
                      borderSide: const BorderSide(color: Design.bordure),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => TextField(
                    controller: controller.cvvController,
                    obscureText: !controller.cvvVisible.value,
                    style: Design.body1,
                    decoration: InputDecoration(
                      hintText: 'CVV',
                      hintStyle: Design.body2,
                      filled: true,
                      fillColor: Design.blanc,
                      suffixIcon: IconButton(
                        onPressed: () => controller.cvvVisible.value =
                            !controller.cvvVisible.value,
                        icon: Icon(
                          controller.cvvVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                        borderSide: const BorderSide(color: Design.bordure),
                      ),
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

class _BlocPromoCheckout extends StatelessWidget {
  final ControllerPanier panier;

  const _BlocPromoCheckout({required this.panier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Design.primaire.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(
          color: Design.primaire.withValues(alpha: 0.35),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, color: Design.primaire),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Vous avez un code promo ? Ajoutez-le pour bénéficier d\'une réduction.',
              style: Design.body2.copyWith(color: Design.texte, height: 1.35),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'Code promo',
                content: TextField(
                  controller: panier.codePromoController,
                  decoration: const InputDecoration(hintText: 'Ex: GAB10'),
                ),
                textCancel: 'Annuler',
                textConfirm: 'Ajouter',
                confirmTextColor: Design.blanc,
                buttonColor: Design.primaire,
                onConfirm: () {
                  panier.appliquerCodePromo();
                  Get.back();
                },
              );
            },
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

class _Facturation extends StatelessWidget {
  final ControllerCheckout controller;

  const _Facturation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations de facturation',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Material(
          color: Design.blanc,
          borderRadius: BorderRadius.circular(Design.radiusMd),
          child: InkWell(
            onTap: controller.modifierFacturation,
            borderRadius: BorderRadius.circular(Design.radiusMd),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Design.radiusMd),
                border: Border.all(color: Design.bordure),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Design.primaire),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.adresseFacturation.value,
                            style: Design.body2.copyWith(
                              color: Design.texte,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            controller.telephoneFacturation.value,
                            style: Design.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Design.texteSecondaire),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BarrePayer extends StatelessWidget {
  final ControllerPanier panier;
  final ControllerCheckout checkout;

  const _BarrePayer({required this.panier, required this.checkout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Design.blanc,
        border: Border(top: BorderSide(color: Design.bordure)),
      ),
      child: Obx(() {
        final total = panier.totalFcfa;
        final _ = panier.items.length;
        final loading = checkout.isLoading.value;
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total à payer', style: Design.caption),
                  Text(
                    _prixFcfa(total),
                    style: Design.h3.copyWith(
                      color: Design.primaire,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.lock, size: 12, color: Design.secondaire),
                      const SizedBox(width: 4),
                      Text(
                        'Paiement sécurisé',
                        style: Design.caption.copyWith(
                          color: Design.secondaire,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: loading
                  ? null
                  : () => checkout.payerMaintenant(montantFcfa: total),
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Design.blanc,
                      ),
                    )
                  : const Icon(Icons.lock_outline, size: 18),
              label: const Text('Payer maintenant'),
              style: FilledButton.styleFrom(
                backgroundColor: Design.primaire,
                foregroundColor: Design.blanc,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                ),
                textStyle: Design.body2.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      }      ),
    );
  }
}

import 'package:gabpharmamobile/models/payment_model.dart';
import 'package:gabpharmamobile/ripository/orders_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// Moyens affichés sur l'écran paiement (UI).
enum MethodePaiementUi {
  mobileMoney,
  carte,
  portefeuille,
  aLaLivraison,
}

class ControllerCheckout extends GetxController {
  final PaymentsRepository _repo = PaymentsRepository();

  final methode = MethodePaiementUi.mobileMoney.obs;
  final isLoading = false.obs;
  final soldePortefeuilleFcfa = 2450.obs;

  final adresseFacturation =
      'Libreville, Akanda, Quartier Awendjé, Villa 12'.obs;
  final telephoneFacturation = '+241 06 00 00 00'.obs;

  // Champs carte (UI — brancher E-Billing ensuite)
  final numeroCarteController = TextEditingController();
  final expirationController = TextEditingController();
  final cvvController = TextEditingController();
  final cvvVisible = false.obs;

  // Mobile money
  final telephoneMmController = TextEditingController();
  final operateurMm = 'airtel'.obs; // airtel | moov

  @override
  void onInit() {
    super.onInit();
    // Alignement avec MoyenPaiement API
  }

  @override
  void onClose() {
    numeroCarteController.dispose();
    expirationController.dispose();
    cvvController.dispose();
    telephoneMmController.dispose();
    super.onClose();
  }

  void selectionnerMethode(MethodePaiementUi m) => methode.value = m;

  void modifierFacturation() {
    Get.snackbar(
      'Facturation',
      'Édition adresse / téléphone à brancher.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void support() {
    Get.snackbar(
      'Support',
      'Assistance paiement à brancher.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  MoyenPaiement get moyenApi {
    switch (methode.value) {
      case MethodePaiementUi.mobileMoney:
        return operateurMm.value == 'moov'
            ? MoyenPaiement.moovMoney
            : MoyenPaiement.airtelMoney;
      case MethodePaiementUi.carte:
        return MoyenPaiement.carte;
      case MethodePaiementUi.portefeuille:
        return MoyenPaiement.pharmacie; // placeholder wallet
      case MethodePaiementUi.aLaLivraison:
        return MoyenPaiement.cod;
    }
  }

  Future<void> payerMaintenant({required int montantFcfa}) async {
    if (methode.value == MethodePaiementUi.portefeuille &&
        soldePortefeuilleFcfa.value < montantFcfa) {
      Get.snackbar(
        'Solde insuffisant',
        'Rechargez votre portefeuille Gab\'Pharma.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      // TODO API: POST /api/v1/payments/checkout/ (+ deep link E-Billing)
      await _repo.checkout({
        'amount': montantFcfa,
        'method': moyenApi.name,
        'phone': telephoneMmController.text.trim(),
        'billing_address': adresseFacturation.value,
        'billing_phone': telephoneFacturation.value,
      });

      Get.snackbar(
        'Paiement initié',
        'Checkout prêt à brancher (E-Billing / Mobile Money).',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Après succès API → suivi commande
      // Get.offNamed(Routes.detailCommande, arguments: {'id': orderId});
    } finally {
      isLoading.value = false;
    }
  }

  void retourPanier() => Get.back();
}

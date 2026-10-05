import 'package:flutter/material.dart';
import 'package:gabpharmamobile/models/order_model.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Panier local mono-pharmacie (pas d'API panier dédiée pour l'instant).
class ControllerPanier extends GetxController {
  final items = <CartItemModel>[].obs;
  final pharmacieId = RxnInt();
  final pharmacieNom = RxnString();

  final codePromoController = TextEditingController();
  final codePromoApplique = RxnString();
  final reductionPromoFcfa = 0.obs;
  final ordonnanceAjoutee = false.obs;
  final cheminOrdonnance = RxnString();

  /// Frais mock — brancher forfait Premium (livraison offerte) ensuite.
  final fraisLivraisonFcfa = 500.obs;
  final fraisServiceFcfa = 100.obs;

  int get nombreArticles => items.fold(0, (s, e) => s + e.quantite);
  int get sousTotalFcfa => items.fold(0, (s, e) => s + e.sousTotal);
  int get totalFcfa =>
      (sousTotalFcfa + fraisLivraisonFcfa.value + fraisServiceFcfa.value -
              reductionPromoFcfa.value)
          .clamp(0, 1 << 30);
  bool get estVide => items.isEmpty;
  bool get contientOrdonnance => items.any((e) => e.surOrdonnance);
  bool get ordonnanceRequise => contientOrdonnance && !ordonnanceAjoutee.value;

  @override
  void onInit() {
    super.onInit();
    // Données mock UI si panier vide (retirer quand l'API panier/order sera branchée).
    if (items.isEmpty) {
      _seedDemo();
    }
  }

  @override
  void onClose() {
    codePromoController.dispose();
    super.onClose();
  }

  void _seedDemo() {
    pharmacieId.value = 1;
    pharmacieNom.value = 'Pharmacie Sainte Marie';
    items.assignAll(const [
      CartItemModel(
        medicineId: 1,
        nom: 'Doliprane 1000 mg',
        pharmacyId: 1,
        pharmacyNom: 'Pharmacie Sainte Marie',
        quantite: 1,
        prixFcfa: 1200,
        forme: 'Comprimé sécable',
        principeActif: 'Paracétamol',
      ),
      CartItemModel(
        medicineId: 2,
        nom: 'Amoxicilline 500 mg',
        pharmacyId: 1,
        pharmacyNom: 'Pharmacie Sainte Marie',
        quantite: 2,
        prixFcfa: 800,
        surOrdonnance: true,
        forme: 'Capsule',
        principeActif: 'Amoxicilline',
      ),
      CartItemModel(
        medicineId: 3,
        nom: 'Vitamine C 500 mg',
        pharmacyId: 1,
        pharmacyNom: 'Pharmacie Sainte Marie',
        quantite: 1,
        prixFcfa: 600,
        forme: 'Comprimé effervescent',
        principeActif: 'Acide ascorbique',
      ),
    ]);
  }

  String? ajouter(CartItemModel item) {
    if (pharmacieId.value != null && pharmacieId.value != item.pharmacyId) {
      return 'Une commande = une seule pharmacie. Videz le panier pour changer.';
    }
    pharmacieId.value = item.pharmacyId;
    pharmacieNom.value = item.pharmacyNom;

    final index = items.indexWhere((e) => e.medicineId == item.medicineId);
    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantite: items[index].quantite + item.quantite,
      );
      items.refresh();
    } else {
      items.add(item);
    }
    return null;
  }

  void changerQuantite(int medicineId, int delta) {
    final index = items.indexWhere((e) => e.medicineId == medicineId);
    if (index < 0) return;
    final next = items[index].quantite + delta;
    if (next <= 0) {
      retirer(medicineId);
      return;
    }
    items[index] = items[index].copyWith(quantite: next);
    items.refresh();
  }

  void retirer(int medicineId) {
    items.removeWhere((e) => e.medicineId == medicineId);
    if (items.isEmpty) {
      pharmacieId.value = null;
      pharmacieNom.value = null;
      ordonnanceAjoutee.value = false;
      cheminOrdonnance.value = null;
    }
  }

  void vider() {
    items.clear();
    pharmacieId.value = null;
    pharmacieNom.value = null;
    ordonnanceAjoutee.value = false;
    cheminOrdonnance.value = null;
    codePromoApplique.value = null;
    reductionPromoFcfa.value = 0;
    codePromoController.clear();
  }

  void appliquerCodePromo() {
    final code = codePromoController.text.trim().toUpperCase();
    if (code.isEmpty) {
      Get.snackbar(
        'Code promo',
        'Saisissez un code.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // TODO API: valider coupon
    if (code == 'GAB10') {
      codePromoApplique.value = code;
      reductionPromoFcfa.value = 300;
      Get.snackbar(
        'Promo appliquée',
        'Réduction de 300 FCFA',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Code invalide',
        'Ce coupon n\'est pas reconnu (demo : GAB10).',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void ajouterOrdonnance() {
    // TODO: file_picker PDF/JPG/PNG → upload prescriptions API
    ordonnanceAjoutee.value = true;
    cheminOrdonnance.value = 'ordonnance_locale.pdf';
    Get.snackbar(
      'Ordonnance',
      'Fichier prêt à uploader (API prescriptions).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void payerMaintenant() {
    if (estVide) return;
    if (ordonnanceRequise) {
      Get.snackbar(
        'Ordonnance requise',
        'Ajoutez une ordonnance pour les médicaments sur prescription.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // TODO: paywall forfait + POST /payments/checkout/
    Get.toNamed(Routes.checkout);
  }

  void continuerAchats() {
    if (Get.key.currentState?.canPop() == true) {
      Get.back();
    } else {
      Get.offNamed(Routes.navigation);
    }
  }
}

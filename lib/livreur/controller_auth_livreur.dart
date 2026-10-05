import 'package:flutter/material.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Statut après inscription — l'admin web doit valider avant connexion.
enum StatutCompteLivreur {
  /// Pas encore inscrit / session libre.
  inconnu,
  /// Dossier envoyé, en attente validation admin (rôle livreur déjà connu).
  enAttenteValidation,
  /// Validé côté admin → peut se connecter.
  actif,
  /// Refusé par l'admin.
  refuse,
}

/// Auth + inscription multi-étapes livreur (UI, API à brancher).
class ControllerAuthLivreur extends GetxController {
  // —— Connexion ——
  final telephoneConnexion = TextEditingController();
  final motDePasseConnexion = TextEditingController();
  final mdpConnexionVisible = false.obs;
  final seSouvenir = false.obs;
  final chargementConnexion = false.obs;

  /// Rôle fixé à l'inscription ; l'admin active seulement le compte.
  static const roleCompte = 'livreur';

  /// Statut local (mock) — remplacé par GET /auth/me après API.
  final statutCompte = StatutCompteLivreur.actif.obs;
  final telephoneInscrit = ''.obs;
  final nomLivreurInscrit = ''.obs;

  // —— Wizard ——
  final etape = 0.obs; // 0..3
  final accepteConditions = false.obs;
  final chargementInscription = false.obs;

  // Étape 1 — Société
  final nomSociete = TextEditingController();
  final nomCommercial = TextEditingController();
  final pays = 'Gabon'.obs;
  final numeroRccm = TextEditingController();
  final numeroFiscal = TextEditingController();
  final adresseSiege = TextEditingController();
  final telephoneSociete = TextEditingController();
  final emailSociete = TextEditingController();
  final mdpSociete = TextEditingController();
  final mdpSocieteConfirm = TextEditingController();
  final mdpSocieteVisible = false.obs;
  final mdpSocieteConfirmVisible = false.obs;
  final zonesCouverture = <String>['Libreville', 'Owendo', 'Akanda'].obs;
  final couleurPrincipale = '#6C3AED'.obs;
  final logoChoisi = false.obs;

  // Étape 2 — Livreur
  final nomComplet = TextEditingController();
  final dateNaissance = TextEditingController();
  final telephoneLivreur = TextEditingController();
  final emailLivreur = TextEditingController();
  final adresseResidence = TextEditingController();
  final idLivreur = TextEditingController();
  final zonesLivraison = <String>['Libreville', 'Owendo', 'Akanda'].obs;
  final mdpLivreur = TextEditingController();
  final mdpLivreurConfirm = TextEditingController();
  final mdpLivreurVisible = false.obs;
  final mdpLivreurConfirmVisible = false.obs;
  final accepteConditionsLivreur = false.obs;

  // Étape 3 — Documents
  final pieceIdentite = false.obs;
  final permisConduire = false.obs;
  final assuranceVehicule = false.obs;
  final photoVehicule = false.obs;

  static const zonesDisponibles = [
    'Libreville',
    'Owendo',
    'Akanda',
    'Ntoum',
    'Port-Gentil',
  ];

  static const etapesLabels = [
    'Société',
    'Livreur',
    'Documents',
    'Confirmation',
  ];

  void basculerMdpConnexion() =>
      mdpConnexionVisible.value = !mdpConnexionVisible.value;
  void basculerSeSouvenir(bool? v) => seSouvenir.value = v ?? false;
  void basculerMdpSociete() =>
      mdpSocieteVisible.value = !mdpSocieteVisible.value;
  void basculerMdpSocieteConfirm() =>
      mdpSocieteConfirmVisible.value = !mdpSocieteConfirmVisible.value;
  void basculerMdpLivreur() =>
      mdpLivreurVisible.value = !mdpLivreurVisible.value;
  void basculerMdpLivreurConfirm() =>
      mdpLivreurConfirmVisible.value = !mdpLivreurConfirmVisible.value;

  void ajouterZoneCouverture(String zone) {
    if (!zonesCouverture.contains(zone)) zonesCouverture.add(zone);
  }

  void retirerZoneCouverture(String zone) => zonesCouverture.remove(zone);

  void ajouterZoneLivraison(String zone) {
    if (!zonesLivraison.contains(zone)) zonesLivraison.add(zone);
  }

  void retirerZoneLivraison(String zone) => zonesLivraison.remove(zone);

  /// Simule la validation admin (web) — à remplacer par webhook / polling API.
  void simulerValidationAdmin() {
    statutCompte.value = StatutCompteLivreur.actif;
    Get.snackbar(
      'Compte activé',
      'L\'admin a validé votre dossier. Rôle : $roleCompte. Vous pouvez vous connecter.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  Future<void> connexion() async {
    final tel = telephoneConnexion.text.trim();
    final mdp = motDePasseConnexion.text;
    if (tel.isEmpty || mdp.isEmpty) {
      Get.snackbar(
        'Champs requis',
        'Saisissez votre numéro et votre mot de passe.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    chargementConnexion.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      // TODO: POST login — le backend renvoie déjà role=livreur + statut.

      if (statutCompte.value == StatutCompteLivreur.enAttenteValidation) {
        Get.offAllNamed(Routes.compteEnAttenteLivreur);
        return;
      }
      if (statutCompte.value == StatutCompteLivreur.refuse) {
        Get.snackbar(
          'Compte refusé',
          'Votre dossier a été refusé. Contactez le support.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Compte actif : rôle connu (livreur) → shell livreur.
      Get.offAllNamed(Routes.navigationLivreur);
    } finally {
      chargementConnexion.value = false;
    }
  }

  void connexionOtp() {
    Get.snackbar(
      'OTP',
      'Connexion par code OTP à brancher (API).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void motDePasseOublie() {
    Get.snackbar(
      'Mot de passe oublié',
      'Réinitialisation livreur à brancher (API).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool _validerEtapeSociete() {
    if (nomSociete.text.trim().isEmpty ||
        nomCommercial.text.trim().isEmpty ||
        numeroRccm.text.trim().isEmpty ||
        numeroFiscal.text.trim().isEmpty ||
        adresseSiege.text.trim().isEmpty ||
        telephoneSociete.text.trim().isEmpty ||
        emailSociete.text.trim().isEmpty ||
        mdpSociete.text.isEmpty ||
        mdpSocieteConfirm.text.isEmpty) {
      Get.snackbar(
        'Champs requis',
        'Complétez toutes les informations de la société.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (mdpSociete.text != mdpSocieteConfirm.text) {
      Get.snackbar(
        'Mot de passe',
        'Les mots de passe ne correspondent pas.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (zonesCouverture.isEmpty) {
      Get.snackbar(
        'Zones',
        'Sélectionnez au moins une zone de couverture.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (!accepteConditions.value) {
      Get.snackbar(
        'Conditions',
        'Veuillez accepter les conditions d\'utilisation.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  bool _validerEtapeLivreur() {
    if (nomComplet.text.trim().isEmpty ||
        dateNaissance.text.trim().isEmpty ||
        telephoneLivreur.text.trim().isEmpty ||
        emailLivreur.text.trim().isEmpty ||
        adresseResidence.text.trim().isEmpty ||
        idLivreur.text.trim().isEmpty ||
        mdpLivreur.text.isEmpty ||
        mdpLivreurConfirm.text.isEmpty) {
      Get.snackbar(
        'Champs requis',
        'Complétez toutes les informations du livreur.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (mdpLivreur.text != mdpLivreurConfirm.text) {
      Get.snackbar(
        'Mot de passe',
        'Les mots de passe ne correspondent pas.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (zonesLivraison.isEmpty) {
      Get.snackbar(
        'Zones',
        'Sélectionnez au moins une zone de livraison.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (!accepteConditionsLivreur.value) {
      Get.snackbar(
        'Conditions',
        'Veuillez accepter les conditions d\'utilisation.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  bool _validerDocuments() {
    if (!pieceIdentite.value ||
        !permisConduire.value ||
        !assuranceVehicule.value) {
      Get.snackbar(
        'Documents',
        'Téléversez au minimum pièce d\'identité, permis et assurance.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  void suivant() {
    switch (etape.value) {
      case 0:
        if (!_validerEtapeSociete()) return;
        etape.value = 1;
        break;
      case 1:
        if (!_validerEtapeLivreur()) return;
        etape.value = 2;
        break;
      case 2:
        if (!_validerDocuments()) return;
        etape.value = 3;
        break;
      case 3:
        soumettre();
        break;
    }
  }

  void precedent() {
    if (etape.value > 0) {
      etape.value--;
    } else {
      Get.back();
    }
  }

  Future<void> soumettre() async {
    chargementInscription.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      // TODO: POST inscription — body inclut role=livreur ; statut=pending.
      telephoneInscrit.value = telephoneLivreur.text.trim();
      nomLivreurInscrit.value = nomComplet.text.trim();
      statutCompte.value = StatutCompteLivreur.enAttenteValidation;
      Get.offAllNamed(Routes.compteEnAttenteLivreur);
    } finally {
      chargementInscription.value = false;
    }
  }

  Future<void> choisirDateNaissance(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 18),
    );
    if (picked != null) {
      dateNaissance.text =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  void deconnexion() {
    Get.offAllNamed(Routes.connexionLivreur);
  }

  @override
  void onClose() {
    telephoneConnexion.dispose();
    motDePasseConnexion.dispose();
    nomSociete.dispose();
    nomCommercial.dispose();
    numeroRccm.dispose();
    numeroFiscal.dispose();
    adresseSiege.dispose();
    telephoneSociete.dispose();
    emailSociete.dispose();
    mdpSociete.dispose();
    mdpSocieteConfirm.dispose();
    nomComplet.dispose();
    dateNaissance.dispose();
    telephoneLivreur.dispose();
    emailLivreur.dispose();
    adresseResidence.dispose();
    idLivreur.dispose();
    mdpLivreur.dispose();
    mdpLivreurConfirm.dispose();
    super.onClose();
  }
}

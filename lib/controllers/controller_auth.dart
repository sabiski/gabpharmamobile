import 'package:flutter/material.dart';
import 'package:gabpharmamobile/api/token_storage.dart';
import 'package:gabpharmamobile/models/user_model.dart';
import 'package:gabpharmamobile/ripository/auth_repository.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

class ControllerAuth extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final identifiantController = TextEditingController();
  final motDePasseController = TextEditingController();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final telephoneController = TextEditingController();
  final confirmationController = TextEditingController();

  final isLoading = false.obs;
  final motDePasseVisible = false.obs;
  final seSouvenirDeMoi = false.obs;
  final utilisateur = Rxn<UserModel>();
  final estConnecte = false.obs;

  void basculerVisibiliteMotDePasse() {
    motDePasseVisible.value = !motDePasseVisible.value;
  }

  void basculerSeSouvenir(bool? value) {
    seSouvenirDeMoi.value = value ?? false;
  }

  @override
  void onClose() {
    identifiantController.dispose();
    motDePasseController.dispose();
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    confirmationController.dispose();
    super.onClose();
  }

  Future<void> verifierSession() async {
    final token = await TokenStorage.access;
    estConnecte.value = token != null && token.isNotEmpty;
    if (estConnecte.value) {
      utilisateur.value = await _repo.me();
    }
  }

  Future<void> connexion() async {
    final identifiant = identifiantController.text.trim();
    final password = motDePasseController.text;

    if (identifiant.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Champs requis',
        'Saisissez votre e-mail / téléphone et votre mot de passe.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final data = await _repo.login(
        username: identifiant,
        password: password,
      );
      if (data == null) {
        // Mode UI : accès app jusqu'au branchement JWT.
        // Après API : vérifier rôle client | courier uniquement.
        estConnecte.value = true;
        Get.offAllNamed(Routes.navigation);
        return;
      }
      // TODO: extraire access/refresh selon le JSON réel
      // TODO: TokenStorage.saveTokens + filtrer rôles patient/livreur
      // TODO: si seSouvenirDeMoi → persister le choix localement
      estConnecte.value = true;
      Get.offAllNamed(Routes.navigation);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> connexionGoogle() async {
    Get.snackbar(
      'Bientôt disponible',
      'La connexion Google sera branchée côté API.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> connexionApple() async {
    Get.snackbar(
      'Bientôt disponible',
      'La connexion Apple sera branchée côté API.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void motDePasseOublie() {
    Get.snackbar(
      'Mot de passe oublié',
      'Flux de réinitialisation à brancher (API).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> inscription() async {
    isLoading.value = true;
    try {
      final data = await _repo.register({
        'username': identifiantController.text.trim(),
        'password': motDePasseController.text,
        'email': emailController.text.trim(),
        'first_name': prenomController.text.trim(),
        'last_name': nomController.text.trim(),
        'phone': telephoneController.text.trim(),
      });
      if (data == null) {
        Get.snackbar(
          'API en attente',
          'L\'inscription JWT sera branchée dès réception du contrat.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deconnexion() async {
    await TokenStorage.clear();
    utilisateur.value = null;
    estConnecte.value = false;
    Get.offAllNamed(Routes.connexion);
  }
}

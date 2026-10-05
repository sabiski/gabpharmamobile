import 'package:gabpharmamobile/maps/maps_config.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum PrioriteLivraison { haute, normale, faible }

enum EtapeLivraison {
  demandeAcceptee,
  aRecuperer,
  enCours,
  livree,
}

class ArticleLivraison {
  final String nom;
  final String detail;
  final int quantite;

  const ArticleLivraison({
    required this.nom,
    required this.detail,
    this.quantite = 1,
  });
}

class ContactLivraison {
  final String nom;
  final String adresse;
  final String telephone;
  final double? note;
  final int? avis;
  final LatLng position;

  const ContactLivraison({
    required this.nom,
    required this.adresse,
    required this.telephone,
    required this.position,
    this.note,
    this.avis,
  });
}

class LivraisonLivreur {
  final String id;
  final String reference;
  final DateTime creeeLe;
  final PrioriteLivraison priorite;
  final ContactLivraison pharmacie;
  final ContactLivraison client;
  final double distanceKm;
  final int dureeMinutes;
  final String recupererAvant;
  final String delaiRecuperation;
  final bool payeEnLigne;
  final int montantPercevoir;
  final List<ArticleLivraison> articles;
  final String instructionsPharmacie;
  final String instructionsClient;
  final EtapeLivraison etape;
  final LatLng positionLivreur;
  final double vitesseKmh;

  const LivraisonLivreur({
    required this.id,
    required this.reference,
    required this.creeeLe,
    required this.priorite,
    required this.pharmacie,
    required this.client,
    required this.distanceKm,
    required this.dureeMinutes,
    required this.recupererAvant,
    required this.delaiRecuperation,
    required this.payeEnLigne,
    required this.montantPercevoir,
    required this.articles,
    required this.instructionsPharmacie,
    required this.instructionsClient,
    required this.etape,
    required this.positionLivreur,
    this.vitesseKmh = 28,
  });

  LivraisonLivreur copyWith({EtapeLivraison? etape}) {
    return LivraisonLivreur(
      id: id,
      reference: reference,
      creeeLe: creeeLe,
      priorite: priorite,
      pharmacie: pharmacie,
      client: client,
      distanceKm: distanceKm,
      dureeMinutes: dureeMinutes,
      recupererAvant: recupererAvant,
      delaiRecuperation: delaiRecuperation,
      payeEnLigne: payeEnLigne,
      montantPercevoir: montantPercevoir,
      articles: articles,
      instructionsPharmacie: instructionsPharmacie,
      instructionsClient: instructionsClient,
      etape: etape ?? this.etape,
      positionLivreur: positionLivreur,
      vitesseKmh: vitesseKmh,
    );
  }
}

class ControllerLivraisonLivreur extends GetxController {
  final onglet = 1.obs; // 0 Accueil, 1 Livraisons, 2 Carte, 3 Messages, 4 Profil
  final livraison = Rxn<LivraisonLivreur>();
  final messagesNonLus = 3.obs;

  // Validation récupération
  final codeCommandeScanne = false.obs;
  final signaturePharmacie = false.obs;
  final photoRecuperation = false.obs;

  // Validation livraison
  final otpValide = false.obs;
  final signatureClient = false.obs;
  final photoLivraison = false.obs;

  static const _pharmacieDemo = ContactLivraison(
    nom: 'Pharmacie de l\'Amitié',
    adresse: 'Akanda, Carrefour Okala',
    telephone: '+241 74 12 34 56',
    note: 4.8,
    avis: 235,
    position: LatLng(0.4030, 9.3950),
  );

  static const _clientDemo = ContactLivraison(
    nom: 'Marie Biyogou',
    adresse: 'Akanda, Cité de la Démocratie, Immeuble Horizon, 2ème étage',
    telephone: '+241 66 23 45 67',
    position: LatLng(0.4160, 9.4120),
  );

  @override
  void onInit() {
    super.onInit();
    livraison.value = LivraisonLivreur(
      id: '1',
      reference: 'CMD-2024-0587',
      creeeLe: DateTime(2024, 5, 25, 9, 15),
      priorite: PrioriteLivraison.haute,
      pharmacie: _pharmacieDemo,
      client: _clientDemo,
      distanceKm: 2.4,
      dureeMinutes: 8,
      recupererAvant: '10:30',
      delaiRecuperation: 'dans 45 min',
      payeEnLigne: true,
      montantPercevoir: 2500,
      articles: const [
        ArticleLivraison(
          nom: 'Paracétamol 1g',
          detail: 'Boîte de 20 comprimés',
          quantite: 1,
        ),
      ],
      instructionsPharmacie:
          'Merci de vérifier l\'identité du client avant la remise et obtenir le code de confirmation.',
      instructionsClient:
          'Merci d\'appeler avant d\'arriver. L\'immeuble est derrière la station Petro Gabon.',
      etape: EtapeLivraison.aRecuperer,
      positionLivreur: const LatLng(
        MapsConfig.defaultLat,
        MapsConfig.defaultLng,
      ),
      vitesseKmh: 28,
    );
  }

  void selectionnerOnglet(int i) => onglet.value = i;

  void appeler(String telephone) {
    Get.snackbar(
      'Appel',
      'Appel vers $telephone (à brancher).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void message(String destinataire) {
    Get.snackbar(
      'Message',
      'Messagerie vers $destinataire (à brancher).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void contacterPharmacie() {
    final p = livraison.value?.pharmacie;
    if (p == null) return;
    appeler(p.telephone);
  }

  /// Ouvre la validation récupération (pharmacie).
  void allerValidationRecuperation() {
    Get.toNamed(Routes.validationRecuperation);
  }

  void confirmerRecuperation() {
    final l = livraison.value;
    if (l == null) return;
    livraison.value = l.copyWith(etape: EtapeLivraison.enCours);
    Get.snackbar(
      'Colis récupéré',
      'Mission en cours — dirigez-vous vers le client.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void demarrerLivraison() {
    allerValidationRecuperation();
  }

  void arriverChezClient() {
    Get.toNamed(Routes.validationLivraison);
  }

  void confirmerLivraison() {
    final l = livraison.value;
    if (l == null) return;
    livraison.value = l.copyWith(etape: EtapeLivraison.livree);
    Get.snackbar(
      'Livraison terminée',
      'Mission #${l.reference} clôturée avec succès.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void signalerProbleme() {
    Get.toNamed(Routes.signalementLivreur);
  }

  /// Urgence personnelle (accident livreur, danger…).
  void urgencePersonnelle() {
    Get.snackbar(
      'Urgence personnelle',
      'Contact urgence Gab\'Pharma : +241 11 73 45 67',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Ouvre la mission d'urgence affectée (livraison critique).
  void urgence() {
    Get.toNamed(Routes.missionUrgence);
  }

  void demarrerMissionUrgence() {
    final l = livraison.value;
    if (l == null) return;
    // Priorité haute déjà en place — démarre le flux récupération.
    Get.snackbar(
      'Mission démarrée',
      'Dirigez-vous vers la pharmacie immédiatement.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  int indexEtape(EtapeLivraison e) {
    switch (e) {
      case EtapeLivraison.demandeAcceptee:
        return 0;
      case EtapeLivraison.aRecuperer:
        return 1;
      case EtapeLivraison.enCours:
        return 2;
      case EtapeLivraison.livree:
        return 3;
    }
  }
}

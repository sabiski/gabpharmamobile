import 'package:gabpharmamobile/ripository/orders_repository.dart';
import 'package:get/get.dart';

enum EtapeLivraison {
  validee,
  preparation,
  enLivraison,
  livree,
}

class EtapeSuivi {
  final EtapeLivraison etape;
  final String label;
  final String? heure;
  final bool terminee;
  final bool active;

  const EtapeSuivi({
    required this.etape,
    required this.label,
    this.heure,
    this.terminee = false,
    this.active = false,
  });
}

class LivreurInfo {
  final String nom;
  final double note;
  final int livraisons;
  final String? telephone;
  final String role;

  const LivreurInfo({
    required this.nom,
    required this.note,
    required this.livraisons,
    this.telephone,
    this.role = 'Livreur partenaire Gab\'Pharma',
  });
}

class SuiviCommandeModel {
  final int id;
  final String reference;
  final DateTime date;
  final int nombreArticles;
  final int totalFcfa;
  final EtapeLivraison etapeActuelle;
  final List<EtapeSuivi> etapes;
  final String pharmacie;
  final String adresseLivraison;
  final String instructions;
  final String livraisonEstimee;
  final LivreurInfo? livreur;
  final String statutLabel;

  const SuiviCommandeModel({
    required this.id,
    required this.reference,
    required this.date,
    required this.nombreArticles,
    required this.totalFcfa,
    required this.etapeActuelle,
    required this.etapes,
    required this.pharmacie,
    required this.adresseLivraison,
    required this.instructions,
    required this.livraisonEstimee,
    required this.statutLabel,
    this.livreur,
  });
}

SuiviCommandeModel mockSuiviCommande({
  int id = 1,
  EtapeLivraison etape = EtapeLivraison.enLivraison,
}) {
  final etapes = [
    EtapeSuivi(
      etape: EtapeLivraison.validee,
      label: 'Commande validée',
      heure: '10:30',
      terminee: true,
    ),
    EtapeSuivi(
      etape: EtapeLivraison.preparation,
      label: 'Préparation par la pharmacie',
      heure: '11:00',
      terminee: etape.index >= EtapeLivraison.preparation.index,
      active: etape == EtapeLivraison.preparation,
    ),
    EtapeSuivi(
      etape: EtapeLivraison.enLivraison,
      label: 'En livraison',
      heure: etape.index >= EtapeLivraison.enLivraison.index ? '12:15' : null,
      terminee: etape.index > EtapeLivraison.enLivraison.index,
      active: etape == EtapeLivraison.enLivraison,
    ),
    EtapeSuivi(
      etape: EtapeLivraison.livree,
      label: 'Livrée',
      heure: etape == EtapeLivraison.livree ? '12:45' : null,
      terminee: etape == EtapeLivraison.livree,
      active: etape == EtapeLivraison.livree,
    ),
  ];

  String statut;
  switch (etape) {
    case EtapeLivraison.validee:
      statut = 'Validée';
    case EtapeLivraison.preparation:
      statut = 'En préparation';
    case EtapeLivraison.enLivraison:
      statut = 'En livraison';
    case EtapeLivraison.livree:
      statut = 'Livrée';
  }

  return SuiviCommandeModel(
    id: id,
    reference: 'GP2024061500$id',
    date: DateTime(2024, 6, 15, 10, 30),
    nombreArticles: 3,
    totalFcfa: 3200,
    etapeActuelle: etape,
    statutLabel: statut,
    etapes: etapes,
    pharmacie: 'Pharmacie du Lac',
    adresseLivraison: 'Akanda, Quartier Sablière, Villa 12',
    instructions: 'Sonner à l\'interphone, code 4521',
    livraisonEstimee: 'Entre 12:30 et 13:00',
    livreur: const LivreurInfo(
      nom: 'Jean Daniel',
      note: 4.8,
      livraisons: 128,
      telephone: '+24106000000',
    ),
  );
}

class ControllerSuiviCommande extends GetxController {
  final OrdersRepository _repo = OrdersRepository();

  final isLoading = false.obs;
  final suivi = Rxn<SuiviCommandeModel>();
  final notificationsNonLues = 3.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final id = args is Map ? args['id'] as int? : (args is int ? args : 1);
    charger(id ?? 1);
  }

  Future<void> charger(int id) async {
    isLoading.value = true;
    try {
      // TODO API: GET /api/v1/orders/{id}/ + deliveries tracking
      await _repo.detail(id);
      suivi.value = mockSuiviCommande(id: id);
    } finally {
      isLoading.value = false;
    }
  }

  void appelerLivreur() {
    final tel = suivi.value?.livreur?.telephone;
    Get.snackbar(
      'Appel',
      tel ?? 'Numéro indisponible',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void messageLivreur() {
    Get.snackbar(
      'Message',
      'Messagerie livreur à brancher.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void modifierAdresse() {
    Get.snackbar(
      'Adresse',
      'Modification adresse à brancher.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void modifierInstructions() {
    Get.snackbar(
      'Instructions',
      'Modification instructions à brancher.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void contacterSupport() {
    Get.snackbar(
      'Support',
      'Assistance livraison à brancher.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class ControllerListeCommandes extends GetxController {
  final OrdersRepository _repo = OrdersRepository();
  final isLoading = false.obs;
  final commandes = <SuiviCommandeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    charger();
  }

  Future<void> charger() async {
    isLoading.value = true;
    try {
      await _repo.lister();
      commandes.assignAll([
        mockSuiviCommande(id: 1, etape: EtapeLivraison.enLivraison),
        mockSuiviCommande(id: 2, etape: EtapeLivraison.preparation),
        mockSuiviCommande(id: 3, etape: EtapeLivraison.livree),
      ]);
    } finally {
      isLoading.value = false;
    }
  }
}

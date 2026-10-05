import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_panier.dart';
import 'package:gabpharmamobile/models/medicine_model.dart';
import 'package:gabpharmamobile/models/order_model.dart';
import 'package:gabpharmamobile/models/pharmacy_model.dart';
import 'package:gabpharmamobile/ripository/catalogue_repository.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

enum StockStatut { disponible, stockFaible, indisponible }

enum TriRecherche { pertinence, prixAsc, prixDesc, distance }

class FiltreRapide {
  final String id;
  final String label;
  final IconData icone;

  const FiltreRapide({
    required this.id,
    required this.label,
    required this.icone,
  });
}

class CategoriePrincipale {
  final String id;
  final String label;
  final IconData icone;
  final Color couleur;

  const CategoriePrincipale({
    required this.id,
    required this.label,
    required this.icone,
    required this.couleur,
  });
}

/// Résultat de recherche (affichage UI — brancher API ensuite).
class ResultatRecherche {
  final int id;
  final String nom;
  final String forme;
  final String principeActif;
  final int prixFcfa;
  final StockStatut stock;
  final String pharmacie;
  final double distanceKm;
  final bool ouvert24h;
  final bool top;
  final bool favori;
  final String? image;

  const ResultatRecherche({
    required this.id,
    required this.nom,
    required this.forme,
    required this.principeActif,
    required this.prixFcfa,
    required this.stock,
    required this.pharmacie,
    required this.distanceKm,
    this.ouvert24h = false,
    this.top = false,
    this.favori = false,
    this.image,
  });
}

class ControllerCatalogue extends GetxController {
  final CatalogueRepository _repo = CatalogueRepository();
  final rechercheController = TextEditingController();

  final isLoading = false.obs;
  final medicaments = <MedicineModel>[].obs;
  final stocks = <PharmacyStockModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final pharmacies = <PharmacyModel>[].obs;
  final paywallActif = false.obs;

  final recherchesRecentes = <String>['Doliprane', 'Amoxicilline', 'Vitamine C', 'Smecta'].obs;
  final filtreActif = 'toutes'.obs;
  final tri = TriRecherche.pertinence.obs;
  final resultats = <ResultatRecherche>[].obs;
  final totalResultats = 0.obs;
  final aRecherche = false.obs;
  final queryActive = ''.obs;
  final favorisIds = <int>{}.obs;
  final notificationsNonLues = 2.obs;

  MedicineModel? medicamentSelectionne;

  final filtresRapides = const [
    FiltreRapide(id: 'toutes', label: 'Toutes catégories', icone: Icons.grid_view_rounded),
    FiltreRapide(id: 'antalgiques', label: 'Antalgiques', icone: Icons.sentiment_satisfied_alt_outlined),
    FiltreRapide(id: 'antibiotiques', label: 'Antibiotiques', icone: Icons.shield_outlined),
    FiltreRapide(id: 'vitamines', label: 'Vitamines', icone: Icons.eco_outlined),
  ];

  final categoriesPrincipales = const [
    CategoriePrincipale(
      id: 'douleurs',
      label: 'Douleurs & Fièvre',
      icone: Icons.sick_outlined,
      couleur: Color(0xFF6C3AED),
    ),
    CategoriePrincipale(
      id: 'toux',
      label: 'Toux & Rhume',
      icone: Icons.air,
      couleur: Color(0xFF16A34A),
    ),
    CategoriePrincipale(
      id: 'digestion',
      label: 'Digestion',
      icone: Icons.restaurant_outlined,
      couleur: Color(0xFFF59E0B),
    ),
    CategoriePrincipale(
      id: 'peau',
      label: 'Soins de la peau',
      icone: Icons.spa_outlined,
      couleur: Color(0xFF3B82F6),
    ),
    CategoriePrincipale(
      id: 'hygiene',
      label: 'Hygiène & Soins',
      icone: Icons.sanitizer_outlined,
      couleur: Color(0xFFEC4899),
    ),
    CategoriePrincipale(
      id: 'bebe',
      label: 'Maternité & Bébé',
      icone: Icons.child_care_outlined,
      couleur: Color(0xFF14B8A6),
    ),
    CategoriePrincipale(
      id: 'vitamines',
      label: 'Vitamines & Compléments',
      icone: Icons.medication_outlined,
      couleur: Color(0xFFEAB308),
    ),
    CategoriePrincipale(
      id: 'plus',
      label: 'Plus',
      icone: Icons.more_horiz,
      couleur: Color(0xFF94A3B8),
    ),
  ];

  @override
  void onClose() {
    rechercheController.dispose();
    super.onClose();
  }

  Future<void> chargerCategories() async {
    final api = await _repo.categories();
    categories.assignAll(api);
  }

  Future<void> rechercher([String? query]) async {
    final q = (query ?? rechercheController.text).trim();
    if (q.isEmpty) return;

    rechercheController.text = q;
    rechercheController.selection = TextSelection.collapsed(offset: q.length);
    queryActive.value = q;
    _ajouterRechercheRecente(q);

    isLoading.value = true;
    paywallActif.value = false;
    aRecherche.value = true;
    try {
      final api = await _repo.rechercher(q);
      medicaments.assignAll(api);
      // TODO API: mapper MedicineModel → ResultatRecherche + availability
      if (api.isEmpty) {
        _appliquerMockResultats(q);
      } else {
        resultats.clear();
        totalResultats.value = api.length;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _appliquerMockResultats(String q) {
    final qLower = q.toLowerCase();
    final mock = [
      const ResultatRecherche(
        id: 1,
        nom: 'Doliprane 1000 mg',
        forme: 'Comprimé sécable',
        principeActif: 'Paracétamol',
        prixFcfa: 1200,
        stock: StockStatut.disponible,
        pharmacie: 'Pharmacie Sainte Marie',
        distanceKm: 1.2,
        ouvert24h: true,
        top: true,
      ),
      const ResultatRecherche(
        id: 2,
        nom: 'Doliprane 500 mg',
        forme: 'Comprimé',
        principeActif: 'Paracétamol',
        prixFcfa: 800,
        stock: StockStatut.stockFaible,
        pharmacie: 'Pharmacie du Plateau',
        distanceKm: 2.1,
        ouvert24h: false,
      ),
      const ResultatRecherche(
        id: 3,
        nom: 'Efferalgan 1000 mg',
        forme: 'Comprimé effervescent',
        principeActif: 'Paracétamol',
        prixFcfa: 1500,
        stock: StockStatut.disponible,
        pharmacie: 'Pharmacie Akanda',
        distanceKm: 3.4,
        ouvert24h: true,
      ),
    ];

    final filtered = mock
        .where((r) =>
            r.nom.toLowerCase().contains(qLower) ||
            r.principeActif.toLowerCase().contains(qLower) ||
            qLower.length < 3)
        .toList();

    resultats.assignAll(filtered.isEmpty ? mock : filtered);
    totalResultats.value = filtered.isEmpty ? 12 : filtered.length + 9;
  }

  void _ajouterRechercheRecente(String q) {
    recherchesRecentes.remove(q);
    recherchesRecentes.insert(0, q);
    if (recherchesRecentes.length > 8) {
      recherchesRecentes.removeRange(8, recherchesRecentes.length);
    }
  }

  void effacerRecherchesRecentes() => recherchesRecentes.clear();

  void selectionnerFiltre(String id) {
    filtreActif.value = id;
    // TODO API: refiltrer /categories/ + search
    if (aRecherche.value) {
      rechercher();
    }
  }

  void selectionnerCategorie(CategoriePrincipale cat) {
    if (cat.id == 'plus') {
      Get.snackbar(
        'Catégories',
        'Liste complète à brancher (GET /categories/).',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    rechercheController.text = cat.label;
    rechercher(cat.label);
  }

  void changerTri(TriRecherche value) {
    tri.value = value;
    final list = [...resultats];
    switch (value) {
      case TriRecherche.prixAsc:
        list.sort((a, b) => a.prixFcfa.compareTo(b.prixFcfa));
      case TriRecherche.prixDesc:
        list.sort((a, b) => b.prixFcfa.compareTo(a.prixFcfa));
      case TriRecherche.distance:
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      case TriRecherche.pertinence:
        break;
    }
    resultats.assignAll(list);
  }

  void basculerFavori(int id) {
    if (favorisIds.contains(id)) {
      favorisIds.remove(id);
    } else {
      favorisIds.add(id);
    }
    // TODO API: POST/DELETE /api/v1/favorites/
  }

  void ajouterAuPanier(ResultatRecherche item) {
    // TODO: vérifier forfait (paywall) avant ajout
    final err = Get.find<ControllerPanier>().ajouter(
      CartItemModel(
        medicineId: item.id,
        nom: item.nom,
        pharmacyId: 1,
        pharmacyNom: item.pharmacie,
        quantite: 1,
        prixFcfa: item.prixFcfa,
        forme: item.forme,
        principeActif: item.principeActif,
        enStock: item.stock == StockStatut.disponible,
      ),
    );
    if (err != null) {
      Get.snackbar('Panier', err, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.snackbar(
      'Ajouté',
      item.nom,
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: () => Get.toNamed(Routes.panier),
        child: const Text('Voir panier'),
      ),
    );
  }

  void scannerOrdonnance() {
    Get.snackbar(
      'Scanner',
      'Scan / upload ordonnance à brancher.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void rechercheVocale() {
    Get.snackbar(
      'Vocal',
      'Recherche vocale à brancher.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void effacerRecherche() {
    rechercheController.clear();
    resultats.clear();
    aRecherche.value = false;
    queryActive.value = '';
    totalResultats.value = 0;
  }

  /// Stocks : uniquement après recherche explicite ou forfait (CDC v1.1).
  Future<void> chargerDisponibilite() async {
    final q = rechercheController.text.trim();
    if (q.isEmpty) return;
    try {
      stocks.assignAll(await _repo.disponibilite(q));
    } catch (_) {
      paywallActif.value = true;
      stocks.clear();
    }
  }

  Future<void> chargerPharmacies({bool nearby = false, bool onDuty = false}) async {
    pharmacies.assignAll(
      await _repo.pharmacies(nearby: nearby, onDuty: onDuty),
    );
  }
}

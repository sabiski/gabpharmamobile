import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_catalogue.dart';
import 'package:gabpharmamobile/controllers/controller_panier.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/models/order_model.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

enum ModeRetrait { livraison, retrait }

enum StockDetail {
  disponible,
  stockFaible,
  indisponible,
  surCommande,
}

class PharmacieDispo {
  final int id;
  final String nom;
  final double note;
  final double distanceKm;
  final bool ouvert24h;
  final bool recommande;
  final int prixFcfa;
  final StockDetail stock;
  final Color accent;

  const PharmacieDispo({
    required this.id,
    required this.nom,
    required this.note,
    required this.distanceKm,
    required this.prixFcfa,
    required this.stock,
    this.ouvert24h = false,
    this.recommande = false,
    this.accent = Design.secondaire,
  });
}

class DetailMedicament {
  final int id;
  final String nom;
  final String forme;
  final String principeActif;
  final String dosage;
  final String conditionnement;
  final String age;
  final int prixFcfa;
  final StockDetail stock;
  final bool surOrdonnance;
  final String description;
  final List<String> composition;
  final List<String> conseils;
  final List<PharmacieDispo> pharmacies;
  final String? image;

  const DetailMedicament({
    required this.id,
    required this.nom,
    required this.forme,
    required this.principeActif,
    required this.dosage,
    required this.conditionnement,
    required this.age,
    required this.prixFcfa,
    required this.stock,
    required this.description,
    required this.composition,
    required this.conseils,
    required this.pharmacies,
    this.surOrdonnance = false,
    this.image,
  });
}

class ControllerFicheMedicament extends GetxController {
  final isLoading = false.obs;
  final detail = Rxn<DetailMedicament>();
  final estFavori = false.obs;
  final modeRetrait = ModeRetrait.livraison.obs;
  final pharmacieSelectionneeId = RxnInt();

  final descriptionOuverte = false.obs;
  final compositionOuverte = false.obs;
  final conseilsOuverts = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final id = args is Map ? args['id'] as int? : (args is int ? args : null);
    charger(id ?? 1);
  }

  Future<void> charger(int id) async {
    isLoading.value = true;
    try {
      // TODO API: GET médicament + availability (402 si paywall)
      await Future<void>.delayed(const Duration(milliseconds: 200));
      detail.value = _mock(id);
      pharmacieSelectionneeId.value =
          detail.value?.pharmacies.isNotEmpty == true
              ? detail.value!.pharmacies.first.id
              : null;
      final favs = Get.isRegistered<ControllerCatalogue>()
          ? Get.find<ControllerCatalogue>().favorisIds
          : <int>{};
      estFavori.value = favs.contains(id);
    } finally {
      isLoading.value = false;
    }
  }

  DetailMedicament _mock(int id) {
    return DetailMedicament(
      id: id,
      nom: 'Doliprane 1000 mg',
      forme: 'Comprimé sécable',
      principeActif: 'Paracétamol',
      dosage: '1000 mg',
      conditionnement: 'Boîte de 8 comprimés',
      age: 'À partir de 15 ans',
      prixFcfa: 1200,
      stock: StockDetail.disponible,
      surOrdonnance: false,
      description:
          'Médicament antalgique et antipyrétique indiqué dans le traitement symptomatique des douleurs d’intensité légère à modérée et/ou de la fièvre.',
      composition: const [
        'Paracétamol ……………… 1000 mg',
        'Excipients ……………… q.s.p.',
      ],
      conseils: const [
        'Réservé à l’adulte et à l’adolescent à partir de 15 ans.',
        '1 comprimé avec un grand verre d’eau.',
        'Renouveler si besoin après 6 à 8 heures.',
        'Ne pas dépasser 3 g de paracétamol par jour.',
      ],
      pharmacies: const [
        PharmacieDispo(
          id: 1,
          nom: 'Pharmacie Sainte Marie',
          note: 4.5,
          distanceKm: 1.2,
          ouvert24h: true,
          recommande: true,
          prixFcfa: 1200,
          stock: StockDetail.disponible,
          accent: Design.secondaire,
        ),
        PharmacieDispo(
          id: 2,
          nom: 'Pharmacie du Lac',
          note: 4.2,
          distanceKm: 2.1,
          ouvert24h: true,
          prixFcfa: 1200,
          stock: StockDetail.stockFaible,
          accent: Design.information,
        ),
        PharmacieDispo(
          id: 3,
          nom: 'Pharmacie Akanda',
          note: 4.0,
          distanceKm: 3.4,
          prixFcfa: 1300,
          stock: StockDetail.disponible,
          accent: Design.primaire,
        ),
      ],
    );
  }

  void basculerFavori() {
    final d = detail.value;
    if (d == null) return;
    estFavori.value = !estFavori.value;
    if (Get.isRegistered<ControllerCatalogue>()) {
      Get.find<ControllerCatalogue>().basculerFavori(d.id);
    }
    // TODO API: POST/DELETE /api/v1/favorites/
  }

  void partager() {
    final d = detail.value;
    Get.snackbar(
      'Partager',
      d == null ? 'Produit indisponible' : d.nom,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void selectionnerMode(ModeRetrait mode) => modeRetrait.value = mode;

  void selectionnerPharmacie(int id) => pharmacieSelectionneeId.value = id;

  PharmacieDispo? get pharmacieSelectionnee {
    final d = detail.value;
    if (d == null) return null;
    final id = pharmacieSelectionneeId.value;
    for (final p in d.pharmacies) {
      if (p.id == id) return p;
    }
    return d.pharmacies.isEmpty ? null : d.pharmacies.first;
  }

  void ajouterAuPanier() {
    final d = detail.value;
    final ph = pharmacieSelectionnee;
    if (d == null || ph == null) return;

    // TODO: vérifier forfait (paywall) avant ajout panier
    final err = Get.find<ControllerPanier>().ajouter(
      CartItemModel(
        medicineId: d.id,
        nom: d.nom,
        pharmacyId: ph.id,
        pharmacyNom: ph.nom,
        quantite: 1,
        prixFcfa: ph.prixFcfa,
        surOrdonnance: d.surOrdonnance,
        forme: d.forme,
        principeActif: d.principeActif,
      ),
    );
    if (err != null) {
      Get.snackbar('Panier', err, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.snackbar(
      'Ajouté',
      '${d.nom} · ${ph.nom}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Design.surface,
      mainButton: TextButton(
        onPressed: () => Get.toNamed(Routes.panier),
        child: const Text('Voir panier'),
      ),
    );
  }

  void reserver() {
    final d = detail.value;
    Get.snackbar(
      'Réservation',
      d == null
          ? 'Produit indisponible'
          : 'Réservation de ${d.nom} à brancher (API orders).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

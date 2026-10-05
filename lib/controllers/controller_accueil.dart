import 'package:gabpharmamobile/models/medicine_model.dart';
import 'package:gabpharmamobile/models/pharmacy_model.dart';
import 'package:gabpharmamobile/ripository/catalogue_repository.dart';
import 'package:get/get.dart';

/// Données d'affichage accueil (mock UI jusqu'au branchement API).
class OffreMoment {
  final int id;
  final String nom;
  final String forme;
  final int prixFcfa;
  final bool disponible;
  final bool favori;
  final String? image;

  const OffreMoment({
    required this.id,
    required this.nom,
    required this.forme,
    required this.prixFcfa,
    this.disponible = true,
    this.favori = false,
    this.image,
  });
}

class PharmacieProximite {
  final int id;
  final String nom;
  final double note;
  final int avis;
  final double distanceKm;
  final bool ouvert;
  final bool ouvert24h;
  final String? telephone;

  const PharmacieProximite({
    required this.id,
    required this.nom,
    required this.note,
    required this.avis,
    required this.distanceKm,
    this.ouvert = true,
    this.ouvert24h = false,
    this.telephone,
  });
}

class BannerAccueil {
  final String titre;
  final String sousTitre;
  final String cta;

  const BannerAccueil({
    required this.titre,
    required this.sousTitre,
    required this.cta,
  });
}

class ControllerAccueil extends GetxController {
  final CatalogueRepository _repo = CatalogueRepository();

  final localisation = 'Libreville, Akanda'.obs;
  final notificationsNonLues = 3.obs;
  final bannerIndex = 0.obs;
  final isLoading = false.obs;

  final bannieres = <BannerAccueil>[
    const BannerAccueil(
      titre: 'Prenez soin de vous et de vos proches',
      sousTitre: 'Trouvez vos médicaments rapidement et en toute sécurité.',
      cta: 'Rechercher un médicament',
    ),
    const BannerAccueil(
      titre: 'Pharmacies de garde près de vous',
      sousTitre: 'Localisez une officine ouverte 24h/24 en un clin d’œil.',
      cta: 'Voir les pharmacies',
    ),
    const BannerAccueil(
      titre: 'Livraison à domicile',
      sousTitre: 'Commandez en ligne et recevez vos médicaments rapidement.',
      cta: 'Découvrir',
    ),
  ].obs;

  final offres = <OffreMoment>[].obs;
  final pharmaciesProximite = <PharmacieProximite>[].obs;
  final favorisIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    chargerAccueil();
  }

  /// Charge l'accueil : mock UI pour l'instant, API à brancher ensuite.
  Future<void> chargerAccueil() async {
    isLoading.value = true;
    try {
      // TODO API: GET pharmacies nearby + offres / catalogue
      await _repo.pharmacies(nearby: true);
      _appliquerMockUi();
    } finally {
      isLoading.value = false;
    }
  }

  void _appliquerMockUi() {
    offres.assignAll(const [
      OffreMoment(
        id: 1,
        nom: 'Doliprane 1000 mg',
        forme: 'Comprimé',
        prixFcfa: 1200,
        disponible: true,
      ),
      OffreMoment(
        id: 2,
        nom: 'Amoxicilline 500',
        forme: 'Gélule',
        prixFcfa: 3500,
        disponible: true,
      ),
      OffreMoment(
        id: 3,
        nom: 'Vitamine C 500',
        forme: 'Comprimé',
        prixFcfa: 2500,
        disponible: true,
      ),
    ]);

    pharmaciesProximite.assignAll(const [
      PharmacieProximite(
        id: 1,
        nom: 'Pharmacie Sainte Marie',
        note: 4.5,
        avis: 128,
        distanceKm: 1.2,
        ouvert: true,
        ouvert24h: true,
        telephone: '+24101123456',
      ),
      PharmacieProximite(
        id: 2,
        nom: 'Pharmacie du Plateau',
        note: 4.2,
        avis: 86,
        distanceKm: 2.4,
        ouvert: true,
        ouvert24h: false,
        telephone: '+24101111222',
      ),
    ]);
  }

  void changerBanner(int index) => bannerIndex.value = index;

  void basculerFavori(int id) {
    if (favorisIds.contains(id)) {
      favorisIds.remove(id);
    } else {
      favorisIds.add(id);
    }
    // TODO API: POST/DELETE /api/v1/favorites/
  }

  void changerLocalisation() {
    // TODO: sélecteur de ville / GPS
    Get.snackbar(
      'Localisation',
      'Sélecteur de zone à brancher (GPS / villes).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Mapping futur depuis MedicineModel API.
  static OffreMoment depuisMedicine(MedicineModel m, {int? prix}) {
    return OffreMoment(
      id: m.id ?? 0,
      nom: m.nom ?? 'Médicament',
      forme: m.categorie?.nom ?? '—',
      prixFcfa: prix ?? 0,
      image: m.image,
    );
  }

  static PharmacieProximite depuisPharmacy(PharmacyModel p) {
    return PharmacieProximite(
      id: p.id ?? 0,
      nom: p.nom ?? 'Pharmacie',
      note: 0,
      avis: 0,
      distanceKm: 0,
      ouvert: true,
      ouvert24h: p.deGarde,
      telephone: p.telephone,
    );
  }
}

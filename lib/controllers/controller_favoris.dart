import 'package:gabpharmamobile/ripository/patient_repository.dart';
import 'package:get/get.dart';

enum OngletFavoris { pharmacies, medicaments }

class FavoriPharmacie {
  final int id;
  final String nom;
  final bool ouvert;
  final double note;
  final int avis;
  final String adresse;

  const FavoriPharmacie({
    required this.id,
    required this.nom,
    required this.ouvert,
    required this.note,
    required this.avis,
    required this.adresse,
  });
}

class FavoriMedicament {
  final int id;
  final String nom;
  final String forme;
  final int prixFcfa;

  const FavoriMedicament({
    required this.id,
    required this.nom,
    required this.forme,
    required this.prixFcfa,
  });
}

class ControllerFavorisUi extends GetxController {
  final FavorisRepository _repo = FavorisRepository();

  final onglet = OngletFavoris.pharmacies.obs;
  final isLoading = false.obs;
  final pharmacies = <FavoriPharmacie>[].obs;
  final medicaments = <FavoriMedicament>[].obs;
  final notificationsNonLues = 3.obs;
  final rechercheLocale = ''.obs;

  @override
  void onInit() {
    super.onInit();
    charger();
  }

  Future<void> charger() async {
    isLoading.value = true;
    try {
      // TODO API: GET /api/v1/favorites/ (pharmacies + medicines)
      await _repo.lister();
      pharmacies.assignAll(const [
        FavoriPharmacie(
          id: 1,
          nom: 'Pharmacie du Lac',
          ouvert: true,
          note: 4.6,
          avis: 210,
          adresse: 'Boulevard Triomphal, Libreville',
        ),
        FavoriPharmacie(
          id: 2,
          nom: 'Pharmacie de la Gare',
          ouvert: false,
          note: 4.2,
          avis: 98,
          adresse: 'Avenue de la Gare, Libreville',
        ),
        FavoriPharmacie(
          id: 3,
          nom: 'Pharmacie Sainte Marie',
          ouvert: true,
          note: 4.5,
          avis: 128,
          adresse: 'Akanda, Sablière',
        ),
        FavoriPharmacie(
          id: 4,
          nom: 'Pharmacie des Anges',
          ouvert: true,
          note: 4.1,
          avis: 64,
          adresse: 'Owendo, Centre-ville',
        ),
      ]);
      medicaments.assignAll(const [
        FavoriMedicament(
          id: 1,
          nom: 'Doliprane 1000 mg',
          forme: 'Comprimé sécable',
          prixFcfa: 1200,
        ),
        FavoriMedicament(
          id: 2,
          nom: 'Amoxicilline 500 mg',
          forme: 'Capsule',
          prixFcfa: 800,
        ),
        FavoriMedicament(
          id: 3,
          nom: 'Vitamine C 500 mg',
          forme: 'Comprimé effervescent',
          prixFcfa: 600,
        ),
        FavoriMedicament(
          id: 4,
          nom: 'Smecta',
          forme: 'Sachet',
          prixFcfa: 2500,
        ),
        FavoriMedicament(
          id: 5,
          nom: 'Spasfon',
          forme: 'Comprimé',
          prixFcfa: 1800,
        ),
        FavoriMedicament(
          id: 6,
          nom: 'Dafalgan 500 mg',
          forme: 'Gélule',
          prixFcfa: 900,
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void changerOnglet(OngletFavoris value) => onglet.value = value;

  void retirerPharmacie(int id) {
    pharmacies.removeWhere((e) => e.id == id);
    // TODO API: DELETE favorite pharmacy
  }

  void retirerMedicament(int id) {
    medicaments.removeWhere((e) => e.id == id);
    // TODO API: DELETE /api/v1/favorites/{id}/
  }

  void ajouterFavori() {
    Get.snackbar(
      'Favoris',
      'Recherche pour ajouter un favori à brancher.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void appeler(FavoriPharmacie p) {
    Get.snackbar('Appel', p.nom, snackPosition: SnackPosition.BOTTOM);
  }

  void itineraires(FavoriPharmacie p) {
    Get.snackbar('Itinéraire', p.adresse, snackPosition: SnackPosition.BOTTOM);
  }

  void message(FavoriPharmacie p) {
    Get.snackbar('Message', p.nom, snackPosition: SnackPosition.BOTTOM);
  }
}

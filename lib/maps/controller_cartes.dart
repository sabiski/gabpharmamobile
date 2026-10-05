import 'package:gabpharmamobile/maps/maps_config.dart';
import 'package:gabpharmamobile/maps/maps_markers.dart';
import 'package:gabpharmamobile/maps/maps_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// État carte suivi livraison (client + pharmacie + livreur + itinéraire).
class ControllerCarteSuivi extends GetxController {
  final isLoading = true.obs;
  final client = Rxn<LatLng>();
  final pharmacie = Rxn<LatLng>();
  final livreur = Rxn<LatLng>();
  final distanceKm = 0.0.obs;
  final dureeMin = 0.obs;
  final adresseClient = ''.obs;

  // Coordonnées démo Libreville / Akanda
  static const _pharmaDemo = LatLng(0.3920, 9.4540); // Pharmacie du Lac
  static const _clientDemo = LatLng(0.5050, 9.4120); // Akanda
  static const _livreurDemo = LatLng(0.4480, 9.4330); // en route

  @override
  void onInit() {
    super.onInit();
    initialiser();
  }

  Future<void> initialiser() async {
    isLoading.value = true;
    try {
      LatLng clientPos;
      try {
        clientPos = await MapsService.instance.positionClient();
      } catch (_) {
        clientPos = _clientDemo;
      }
      // Si trop loin du Gabon (GPS défaut), utilise démo
      if ((clientPos.latitude - MapsConfig.defaultLat).abs() > 5) {
        clientPos = _clientDemo;
      }

      client.value = clientPos;
      pharmacie.value = _pharmaDemo;
      livreur.value = _livreurDemo;

      final itineraire = await MapsService.instance.itineraire(
        origin: _pharmaDemo,
        destination: clientPos,
      );
      distanceKm.value = itineraire.distanceKm;
      dureeMin.value = itineraire.dureeMinutes;

      adresseClient.value =
          await MapsService.instance.adresseDepuis(clientPos) ??
              'Akanda, Quartier Sablière';
    } finally {
      isLoading.value = false;
    }
  }

  List<PointCarteData> get points {
    final list = <PointCarteData>[];
    if (pharmacie.value != null) {
      list.add(
        PointCarteData(
          id: 'pharmacie',
          titre: 'Pharmacie du Lac',
          sousTitre: 'Départ',
          position: pharmacie.value!,
          type: TypeMarqueurMaps.pharmacie,
        ),
      );
    }
    if (client.value != null) {
      list.add(
        PointCarteData(
          id: 'client',
          titre: 'Adresse de livraison',
          sousTitre: adresseClient.value,
          position: client.value!,
          type: TypeMarqueurMaps.client,
        ),
      );
    }
    if (livreur.value != null) {
      list.add(
        PointCarteData(
          id: 'livreur',
          titre: 'Livreur',
          sousTitre: 'En route',
          position: livreur.value!,
          type: TypeMarqueurMaps.livreur,
        ),
      );
    }
    return list;
  }
}

class PointCarteData {
  final String id;
  final String titre;
  final String? sousTitre;
  final LatLng position;
  final TypeMarqueurMaps type;

  const PointCarteData({
    required this.id,
    required this.titre,
    required this.position,
    required this.type,
    this.sousTitre,
  });
}

/// Carte pharmacies à proximité.
class ControllerCartePharmacies extends GetxController {
  final isLoading = true.obs;
  final client = Rxn<LatLng>();
  final pharmacies = <PointCarteData>[].obs;
  final selection = Rxn<PointCarteData>();

  static const _demos = [
    PointCarteData(
      id: 'p1',
      titre: 'Pharmacie du Lac',
      sousTitre: 'Ouvert · 24h/24',
      position: LatLng(0.3920, 9.4540),
      type: TypeMarqueurMaps.pharmacie,
    ),
    PointCarteData(
      id: 'p2',
      titre: 'Pharmacie Sainte Marie',
      sousTitre: 'Ouvert',
      position: LatLng(0.4300, 9.4700),
      type: TypeMarqueurMaps.pharmacie,
    ),
    PointCarteData(
      id: 'p3',
      titre: 'Pharmacie du Plateau',
      sousTitre: 'Ouvert',
      position: LatLng(0.3905, 9.4555),
      type: TypeMarqueurMaps.pharmacie,
    ),
    PointCarteData(
      id: 'p4',
      titre: 'Pharmacie Akanda',
      sousTitre: 'Ouvert',
      position: LatLng(0.5050, 9.4120),
      type: TypeMarqueurMaps.pharmacie,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    charger();
  }

  Future<void> charger() async {
    isLoading.value = true;
    try {
      try {
        client.value = await MapsService.instance.positionClient();
      } catch (_) {
        client.value = const LatLng(
          MapsConfig.defaultLat,
          MapsConfig.defaultLng,
        );
      }
      // TODO API: GET /pharmacies/?nearby=true → mapper lat/lng
      pharmacies.assignAll(_demos);
    } finally {
      isLoading.value = false;
    }
  }

  void selectionner(PointCarteData p) => selection.value = p;

  double? distanceVers(PointCarteData p) {
    final c = client.value;
    if (c == null) return null;
    return distanceKm(c, p.position);
  }

  List<PointCarteData> get tousLesPoints {
    final list = [...pharmacies];
    if (client.value != null) {
      list.insert(
        0,
        PointCarteData(
          id: 'moi',
          titre: 'Ma position',
          position: client.value!,
          type: TypeMarqueurMaps.client,
        ),
      );
    }
    return list;
  }
}

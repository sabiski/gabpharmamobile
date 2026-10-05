import 'package:gabpharmamobile/models/forfait_model.dart';
import 'package:gabpharmamobile/models/order_model.dart';
import 'package:gabpharmamobile/models/payment_model.dart';
import 'package:gabpharmamobile/models/prescription_model.dart';
import 'package:gabpharmamobile/ripository/orders_repository.dart';
import 'package:gabpharmamobile/ripository/patient_repository.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

class ControllerForfaits extends GetxController {
  final ForfaitsRepository _repo = ForfaitsRepository();
  final offres = ForfaitOffre.toutes;
  final acces = Rxn<PatientAccessModel>();
  final isLoading = false.obs;

  bool get aAcces => acces.value?.actif == true;

  Future<void> chargerEtat() async {
    isLoading.value = true;
    try {
      await _repo.etatAcces();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acheter(ForfaitOffre offre) async {
    isLoading.value = true;
    try {
      await _repo.acheter(offre.type.name);
      Get.snackbar('API en attente', 'Achat forfait ${offre.nom} à brancher.');
    } finally {
      isLoading.value = false;
    }
  }
}

class ControllerCommandes extends GetxController {
  final OrdersRepository _repo = OrdersRepository();
  final commandes = <OrderModel>[].obs;
  final isLoading = false.obs;
  OrderModel? selection;

  Future<void> charger() async {
    isLoading.value = true;
    try {
      commandes.assignAll(await _repo.lister());
    } finally {
      isLoading.value = false;
    }
  }
}

class ControllerPaiements extends GetxController {
  final PaymentsRepository _repo = PaymentsRepository();
  final moyen = Rxn<MoyenPaiement>();
  final isLoading = false.obs;
  final utiliserAssurance = false.obs;

  Future<void> payer(Map<String, dynamic> payload) async {
    isLoading.value = true;
    try {
      await _repo.checkout(payload);
    } finally {
      isLoading.value = false;
    }
  }
}

class ControllerOrdonnances extends GetxController {
  final PrescriptionsRepository _repo = PrescriptionsRepository();
  final ordonnances = <PrescriptionModel>[].obs;
  final isLoading = false.obs;

  Future<void> charger() async {
    ordonnances.assignAll(await _repo.lister());
  }

  Future<void> uploader(String chemin) async {
    isLoading.value = true;
    try {
      await _repo.uploader(chemin);
    } finally {
      isLoading.value = false;
    }
  }
}

class ControllerFavoris extends GetxController {
  final FavorisRepository _repo = FavorisRepository();
  final favoris = <FavoriteModel>[].obs;

  Future<void> charger() async {
    favoris.assignAll(await _repo.lister());
  }
}

class ControllerNotifications extends GetxController {
  final NotificationsRepository _repo = NotificationsRepository();
  final notifications = <NotificationModel>[].obs;
  final filtre = FiltreNotifications.toutes.obs;
  final isLoading = false.obs;

  int get nonLuesCount => notifications.where((e) => !e.lue).length;

  List<NotificationModel> get filtrees {
    switch (filtre.value) {
      case FiltreNotifications.toutes:
        return notifications.toList();
      case FiltreNotifications.nonLues:
        return notifications.where((e) => !e.lue).toList();
      case FiltreNotifications.lues:
        return notifications.where((e) => e.lue).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    charger();
  }

  Future<void> charger() async {
    isLoading.value = true;
    try {
      final api = await _repo.lister();
      if (api.isEmpty) {
        notifications.assignAll(_mock());
      } else {
        notifications.assignAll(api);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void changerFiltre(FiltreNotifications f) => filtre.value = f;

  void marquerLue(int id) {
    final i = notifications.indexWhere((e) => e.id == id);
    if (i < 0) return;
    notifications[i] = notifications[i].copyWith(lue: true);
    notifications.refresh();
    // TODO API: PATCH notification read
  }

  void toutMarquerLu() {
    notifications.assignAll(
      notifications.map((e) => e.copyWith(lue: true)).toList(),
    );
    // TODO API: mark all read
  }

  void ouvrir(NotificationModel n) {
    if (n.id != null) marquerLue(n.id!);
    if (n.type == 'livraison' || n.type == 'commande') {
      Get.toNamed(Routes.detailCommande, arguments: {'id': 1});
      return;
    }
    Get.snackbar(
      n.titre ?? 'Notification',
      n.message ?? '',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  List<NotificationModel> _mock() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 1,
        titre: 'Votre commande est en livraison',
        sousTitre: 'Commande #GP20240612008',
        message: 'Jean Daniel est en route vers votre adresse.',
        type: 'livraison',
        reference: 'GP20240612008',
        lue: false,
        createdAt: DateTime(now.year, now.month, now.day, 12, 15),
      ),
      NotificationModel(
        id: 2,
        titre: 'Commande livrée avec succès',
        sousTitre: 'Commande #GP20240611003',
        message: 'Merci d\'avoir choisi Gab\'Pharma.',
        type: 'commande',
        lue: false,
        createdAt: DateTime(now.year, now.month, now.day, 9, 40),
      ),
      NotificationModel(
        id: 3,
        titre: 'Promotion spéciale pour vous !',
        sousTitre: 'Offre limitée',
        message: '-15% sur les vitamines jusqu\'à dimanche.',
        type: 'promo',
        lue: false,
        createdAt: DateTime(now.year, now.month, now.day, 8, 5),
      ),
      NotificationModel(
        id: 4,
        titre: 'Paiement accepté',
        sousTitre: 'Moov Money · 3 200 FCFA',
        message: 'Votre paiement a été confirmé.',
        type: 'paiement',
        lue: true,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      NotificationModel(
        id: 5,
        titre: 'Sécurité du compte',
        sousTitre: 'Nouvelle connexion',
        message: 'Une connexion a été détectée sur un nouvel appareil.',
        type: 'securite',
        lue: true,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}

enum FiltreNotifications { toutes, nonLues, lues }

class ControllerAssurance extends GetxController {
  final AssuranceRepository _repo = AssuranceRepository();
  final demandes = <CoverageRequestModel>[].obs;
  final factures = <CoverageInvoiceModel>[].obs;

  Future<void> charger() async {
    demandes.assignAll(await _repo.demandesPc());
    factures.assignAll(await _repo.factures());
  }
}

class ControllerMessagerie extends GetxController {
  final MessagerieRepository _repo = MessagerieRepository();
  final conversations = <dynamic>[].obs;

  Future<void> charger() async {
    conversations.assignAll(await _repo.conversations());
  }
}

class ControllerUrgence extends GetxController {
  final UrgenceRepository _repo = UrgenceRepository();
  final isLoading = false.obs;

  Future<void> declencherSos() async {
    isLoading.value = true;
    try {
      await _repo.declencher();
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:gabpharmamobile/api/api.dart';
import 'package:gabpharmamobile/api/api_url.dart';
import 'package:gabpharmamobile/models/payment_model.dart';
import 'package:gabpharmamobile/models/prescription_model.dart';

class PrescriptionsRepository {
  /// GET /api/v1/prescriptions/
  Future<List<PrescriptionModel>> lister() async {
    apiEnAttente(ApiUrl.prescriptions);
    return [];
  }

  /// POST /api/v1/prescriptions/ — PDF / JPG / PNG
  Future<PrescriptionModel?> uploader(String cheminFichier) async {
    apiEnAttente('POST ${ApiUrl.prescriptions} (multipart)');
    return null;
  }
}

class FavorisRepository {
  /// GET /api/v1/favorites/
  Future<List<FavoriteModel>> lister() async {
    apiEnAttente(ApiUrl.favorites);
    return [];
  }

  Future<void> ajouter(int medicineId) async {
    apiEnAttente('POST ${ApiUrl.favorites}');
  }

  Future<void> retirer(int id) async {
    apiEnAttente('DELETE ${ApiUrl.favorites}$id/');
  }
}

class NotificationsRepository {
  /// GET /api/v1/notifications/
  Future<List<NotificationModel>> lister() async {
    apiEnAttente(ApiUrl.notifications);
    return [];
  }
}

class AssuranceRepository {
  /// Gap API : CoverageRequest / CoverageInvoice (surtout web aujourd'hui)
  Future<List<CoverageRequestModel>> demandesPc() async {
    apiEnAttente(ApiUrl.coverageRequests);
    return [];
  }

  Future<List<CoverageInvoiceModel>> factures() async {
    apiEnAttente(ApiUrl.coverageInvoices);
    return [];
  }
}

class MessagerieRepository {
  /// Gap API : messagerie pharmacie complète
  Future<List<dynamic>> conversations() async {
    apiEnAttente(ApiUrl.messages);
    return [];
  }
}

class UrgenceRepository {
  /// SOS — à confirmer côté API
  Future<Map<String, dynamic>?> declencher() async {
    return apiEnAttente<Map<String, dynamic>>(ApiUrl.sos);
  }
}

import 'package:gabpharmamobile/api/api.dart';
import 'package:gabpharmamobile/api/api_url.dart';
import 'package:gabpharmamobile/models/medicine_model.dart';
import 'package:gabpharmamobile/models/pharmacy_model.dart';

class CatalogueRepository {
  /// GET /api/v1/medicines/search/?q=
  Future<List<MedicineModel>> rechercher(String q) async {
    apiEnAttente('${ApiUrl.medicinesSearch}?q=$q');
    return [];
  }

  /// GET /api/v1/medicines/availability/?q=
  /// 402 si paywall (sans forfait / sans recherche explicite).
  Future<List<PharmacyStockModel>> disponibilite(String q) async {
    apiEnAttente('${ApiUrl.medicinesAvailability}?q=$q');
    return [];
  }

  /// GET /api/v1/categories/
  Future<List<CategoryModel>> categories() async {
    apiEnAttente(ApiUrl.categories);
    return [];
  }

  /// GET /api/v1/pharmacies/ (+ nearby, on_duty)
  Future<List<PharmacyModel>> pharmacies({
    bool nearby = false,
    bool onDuty = false,
  }) async {
    apiEnAttente(
      '${ApiUrl.pharmacies}?nearby=$nearby&on_duty=$onDuty',
    );
    return [];
  }
}

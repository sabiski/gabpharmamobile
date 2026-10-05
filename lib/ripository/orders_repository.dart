import 'package:gabpharmamobile/api/api.dart';
import 'package:gabpharmamobile/api/api_url.dart';
import 'package:gabpharmamobile/models/forfait_model.dart';
import 'package:gabpharmamobile/models/order_model.dart';

class OrdersRepository {
  /// GET /api/v1/orders/
  Future<List<OrderModel>> lister() async {
    apiEnAttente(ApiUrl.orders);
    return [];
  }

  /// POST /api/v1/orders/ — une commande = une seule pharmacie
  Future<OrderModel?> creer(Map<String, dynamic> payload) async {
    apiEnAttente('POST ${ApiUrl.orders}');
    return null;
  }

  /// GET /api/v1/orders/{id}/
  Future<OrderModel?> detail(int id) async {
    apiEnAttente('${ApiUrl.orders}$id/');
    return null;
  }
}

class PaymentsRepository {
  /// POST /api/v1/payments/charge/
  Future<Map<String, dynamic>?> charge(Map<String, dynamic> payload) async {
    return apiEnAttente<Map<String, dynamic>>(ApiUrl.paymentsCharge);
  }

  /// POST /api/v1/payments/checkout/
  Future<Map<String, dynamic>?> checkout(Map<String, dynamic> payload) async {
    return apiEnAttente<Map<String, dynamic>>(ApiUrl.paymentsCheckout);
  }

  /// GET /api/v1/payments/status/<reference>/
  Future<Map<String, dynamic>?> statut(String reference) async {
    return apiEnAttente<Map<String, dynamic>>(ApiUrl.paymentsStatus(reference));
  }
}

class ForfaitsRepository {
  /// Gap API : PatientAccessPurchase (à confirmer)
  Future<PatientAccessModel?> etatAcces() async {
    apiEnAttente(ApiUrl.forfaits);
    return null;
  }

  Future<Map<String, dynamic>?> acheter(String codeForfait) async {
    return apiEnAttente<Map<String, dynamic>>('POST ${ApiUrl.forfaits}');
  }
}

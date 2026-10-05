import 'package:flutter/foundation.dart';

/// Contrats REST /api/v1/ — les corps JSON seront branchés
/// quand les réponses backend seront fournies.
class ApiUrl {
  ApiUrl._();

  static String get base {
    if (kIsWeb) return 'http://127.0.0.1:8080/api/v1';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api/v1';
    }
    return 'http://127.0.0.1:8080/api/v1';
  }

  // Auth JWT
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String refresh = '/auth/refresh/';
  static const String me = '/users/me/';
  static const String health = '/health/';

  // Catalogue
  static const String pharmacies = '/pharmacies/';
  static const String medicinesSearch = '/medicines/search/';
  static const String medicinesAvailability = '/medicines/availability/';
  static const String categories = '/categories/';

  // Commandes / ordonnances / favoris
  static const String orders = '/orders/';
  static const String prescriptions = '/prescriptions/';
  static const String favorites = '/favorites/';
  static const String notifications = '/notifications/';

  // Paiements
  static const String paymentsCharge = '/payments/charge/';
  static const String paymentsCheckout = '/payments/checkout/';
  static String paymentsStatus(String reference) =>
      '/payments/status/$reference/';

  // Livraisons
  static String deliveryAssign(int id) => '/deliveries/$id/assign/';
  static String deliveryValidate(int id) => '/deliveries/$id/validate/';

  // Gaps API à prévoir (pas encore / partiel)
  // POST/GET forfaits patient (PatientAccessPurchase)
  // Module assurance PC/FAC (CoverageRequest)
  // Messagerie pharmacie
  // Panier dédié (aujourd'hui session web)
  static const String forfaits = '/patient-access/';
  static const String coverageRequests = '/coverage-requests/';
  static const String coverageInvoices = '/coverage-invoices/';
  static const String messages = '/messages/';
  static const String cart = '/cart/';
  static const String sos = '/emergency/sos/';
}

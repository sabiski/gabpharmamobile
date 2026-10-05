enum MoyenPaiement {
  moovMoney,
  airtelMoney,
  carte,
  cod,
  pharmacie,
  assurance,
}

class PaymentModel {
  final int? id;
  final String? reference;
  final String? statut;
  final int? montantFcfa;
  final MoyenPaiement? moyen;

  const PaymentModel({
    this.id,
    this.reference,
    this.statut,
    this.montantFcfa,
    this.moyen,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int?,
      reference: json['reference'] as String?,
      statut: (json['status'] ?? json['statut']) as String?,
      montantFcfa: (json['amount'] ?? json['montant']) as int?,
    );
  }
}

/// Demande de prise en charge PC-XXXXXX
class CoverageRequestModel {
  final int? id;
  final String? reference;
  final String? statut;

  const CoverageRequestModel({this.id, this.reference, this.statut});

  factory CoverageRequestModel.fromJson(Map<String, dynamic> json) {
    return CoverageRequestModel(
      id: json['id'] as int?,
      reference: json['reference'] as String?,
      statut: (json['status'] ?? json['statut']) as String?,
    );
  }
}

/// Facture FAC-XXXXXX
class CoverageInvoiceModel {
  final int? id;
  final String? reference;
  final int? resteAChargeFcfa;
  final String? statut;

  const CoverageInvoiceModel({
    this.id,
    this.reference,
    this.resteAChargeFcfa,
    this.statut,
  });

  factory CoverageInvoiceModel.fromJson(Map<String, dynamic> json) {
    return CoverageInvoiceModel(
      id: json['id'] as int?,
      reference: json['reference'] as String?,
      resteAChargeFcfa: (json['remaining'] ?? json['reste_a_charge']) as int?,
      statut: (json['status'] ?? json['statut']) as String?,
    );
  }
}

class PrescriptionModel {
  final int? id;
  final String? fichierUrl;
  final String? statut;
  final DateTime? createdAt;

  const PrescriptionModel({
    this.id,
    this.fichierUrl,
    this.statut,
    this.createdAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as int?,
      fichierUrl: (json['file'] ?? json['fichier']) as String?,
      statut: (json['status'] ?? json['statut']) as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

class FavoriteModel {
  final int? id;
  final int? medicineId;
  final String? nom;

  const FavoriteModel({this.id, this.medicineId, this.nom});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as int?,
      medicineId: (json['medicine'] ?? json['medicine_id']) as int?,
      nom: (json['name'] ?? json['nom']) as String?,
    );
  }
}

class NotificationModel {
  final int? id;
  final String? titre;
  final String? sousTitre;
  final String? message;
  final bool lue;
  final DateTime? createdAt;
  final String? type; // livraison | commande | promo | paiement | securite
  final String? reference;

  const NotificationModel({
    this.id,
    this.titre,
    this.sousTitre,
    this.message,
    this.lue = false,
    this.createdAt,
    this.type,
    this.reference,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int?,
      titre: (json['title'] ?? json['titre']) as String?,
      sousTitre: (json['subtitle'] ?? json['sous_titre']) as String?,
      message: json['message'] as String?,
      lue: json['read'] == true || json['lue'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      type: json['type'] as String?,
      reference: json['reference'] as String?,
    );
  }

  NotificationModel copyWith({bool? lue}) {
    return NotificationModel(
      id: id,
      titre: titre,
      sousTitre: sousTitre,
      message: message,
      lue: lue ?? this.lue,
      createdAt: createdAt,
      type: type,
      reference: reference,
    );
  }
}

class CartItemModel {
  final int medicineId;
  final String nom;
  final int pharmacyId;
  final String pharmacyNom;
  final int quantite;
  final int prixFcfa;
  final bool surOrdonnance;
  final String? forme;
  final String? principeActif;
  final bool enStock;

  const CartItemModel({
    required this.medicineId,
    required this.nom,
    required this.pharmacyId,
    required this.pharmacyNom,
    required this.quantite,
    required this.prixFcfa,
    this.surOrdonnance = false,
    this.forme,
    this.principeActif,
    this.enStock = true,
  });

  int get sousTotal => prixFcfa * quantite;

  String get sousTitre {
    final parts = <String>[
      if (forme != null && forme!.isNotEmpty) forme!,
      if (principeActif != null && principeActif!.isNotEmpty) principeActif!,
    ];
    return parts.join(', ');
  }

  CartItemModel copyWith({
    int? quantite,
    String? forme,
    String? principeActif,
    bool? enStock,
  }) {
    return CartItemModel(
      medicineId: medicineId,
      nom: nom,
      pharmacyId: pharmacyId,
      pharmacyNom: pharmacyNom,
      quantite: quantite ?? this.quantite,
      prixFcfa: prixFcfa,
      surOrdonnance: surOrdonnance,
      forme: forme ?? this.forme,
      principeActif: principeActif ?? this.principeActif,
      enStock: enStock ?? this.enStock,
    );
  }
}

class OrderModel {
  final int? id;
  final String? reference;
  final int? pharmacyId;
  final String? statut;
  final int? totalFcfa;
  final DateTime? createdAt;
  final List<CartItemModel> items;

  const OrderModel({
    this.id,
    this.reference,
    this.pharmacyId,
    this.statut,
    this.totalFcfa,
    this.createdAt,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int?,
      reference: json['reference'] as String?,
      pharmacyId: (json['pharmacy'] ?? json['pharmacy_id']) as int?,
      statut: (json['status'] ?? json['statut']) as String?,
      totalFcfa: (json['total'] ?? json['total_fcfa']) as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

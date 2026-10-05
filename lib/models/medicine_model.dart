class CategoryModel {
  final int? id;
  final String? nom;
  final String? slug;

  const CategoryModel({this.id, this.nom, this.slug});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int?,
      nom: (json['name'] ?? json['nom']) as String?,
      slug: json['slug'] as String?,
    );
  }
}

class MedicineModel {
  final int? id;
  final String? nom;
  final String? description;
  final bool surOrdonnance;
  final String? image;
  final CategoryModel? categorie;
  final Map<String, dynamic>? extra;

  const MedicineModel({
    this.id,
    this.nom,
    this.description,
    this.surOrdonnance = false,
    this.image,
    this.categorie,
    this.extra,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] as int?,
      nom: (json['name'] ?? json['nom']) as String?,
      description: json['description'] as String?,
      surOrdonnance:
          json['requires_prescription'] == true || json['sur_ordonnance'] == true,
      image: (json['image'] ?? json['photo']) as String?,
      categorie: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      extra: json,
    );
  }
}

/// Stock : n'est exposé qu'après recherche explicite ou forfait actif (CDC v1.1).
class PharmacyStockModel {
  final int? id;
  final int? pharmacyId;
  final int? medicineId;
  final int? quantite;
  final int? prixFcfa;
  final bool disponible;

  const PharmacyStockModel({
    this.id,
    this.pharmacyId,
    this.medicineId,
    this.quantite,
    this.prixFcfa,
    this.disponible = false,
  });

  factory PharmacyStockModel.fromJson(Map<String, dynamic> json) {
    return PharmacyStockModel(
      id: json['id'] as int?,
      pharmacyId: (json['pharmacy'] ?? json['pharmacy_id']) as int?,
      medicineId: (json['medicine'] ?? json['medicine_id']) as int?,
      quantite: (json['quantity'] ?? json['quantite']) as int?,
      prixFcfa: (json['price'] ?? json['prix']) as int?,
      disponible: json['available'] == true || (json['quantity'] ?? 0) > 0,
    );
  }
}

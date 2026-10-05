class PharmacyModel {
  final int? id;
  final String? nom;
  final String? adresse;
  final String? telephone;
  final double? latitude;
  final double? longitude;
  final bool deGarde;
  final bool aProximite;

  const PharmacyModel({
    this.id,
    this.nom,
    this.adresse,
    this.telephone,
    this.latitude,
    this.longitude,
    this.deGarde = false,
    this.aProximite = false,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'] as int?,
      nom: (json['name'] ?? json['nom']) as String?,
      adresse: (json['address'] ?? json['adresse']) as String?,
      telephone: (json['phone'] ?? json['telephone']) as String?,
      latitude: (json['lat'] ?? json['latitude']) is num
          ? (json['lat'] ?? json['latitude']).toDouble()
          : null,
      longitude: (json['lng'] ?? json['longitude']) is num
          ? (json['lng'] ?? json['longitude']).toDouble()
          : null,
      deGarde: json['on_duty'] == true || json['de_garde'] == true,
      aProximite: json['nearby'] == true,
    );
  }
}

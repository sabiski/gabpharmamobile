enum TypeForfait { pass1h, standardJournee, premium }

/// Offres patient (paywall catalogue / panier / messagerie).
class ForfaitOffre {
  final TypeForfait type;
  final String nom;
  final int prixFcfa;
  final String dureeLabel;
  final List<String> avantages;

  const ForfaitOffre({
    required this.type,
    required this.nom,
    required this.prixFcfa,
    required this.dureeLabel,
    required this.avantages,
  });

  static const pass1h = ForfaitOffre(
    type: TypeForfait.pass1h,
    nom: 'Pass 1h',
    prixFcfa: 500,
    dureeLabel: '1 heure',
    avantages: [
      'Stocks visibles',
      'Panier débloqué',
      'Messagerie pharmacie',
    ],
  );

  static const standard = ForfaitOffre(
    type: TypeForfait.standardJournee,
    nom: 'Standard journée',
    prixFcfa: 2000,
    dureeLabel: '24 heures',
    avantages: [
      'Stocks visibles',
      'Panier débloqué',
      'Messagerie pharmacie',
    ],
  );

  static const premium = ForfaitOffre(
    type: TypeForfait.premium,
    nom: 'Premium',
    prixFcfa: 5000,
    dureeLabel: 'Selon offre',
    avantages: [
      'Stocks visibles',
      'Panier débloqué',
      'Messagerie pharmacie',
      'Livraison offerte',
      'Urgence SOS',
    ],
  );

  static const toutes = [pass1h, standard, premium];
}

class PatientAccessModel {
  final int? id;
  final TypeForfait? type;
  final DateTime? debut;
  final DateTime? fin;
  final bool actif;

  const PatientAccessModel({
    this.id,
    this.type,
    this.debut,
    this.fin,
    this.actif = false,
  });

  factory PatientAccessModel.fromJson(Map<String, dynamic> json) {
    return PatientAccessModel(
      id: json['id'] as int?,
      debut: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'].toString())
          : null,
      fin: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'].toString())
          : null,
      actif: json['is_active'] == true || json['actif'] == true,
    );
  }
}

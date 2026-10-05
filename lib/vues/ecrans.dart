import 'package:flutter/material.dart';
import 'package:gabpharmamobile/composants/input_component.dart';
import 'package:gabpharmamobile/design/design.dart';

export 'package:gabpharmamobile/vues/accueil.dart' show Accueil;
export 'package:gabpharmamobile/vues/recherche.dart' show Recherche;
export 'package:gabpharmamobile/vues/fiche_medicament.dart' show FicheMedicament;
export 'package:gabpharmamobile/vues/panier.dart' show Panier;
export 'package:gabpharmamobile/vues/suivi_commande.dart'
    show Commandes, DetailCommande;
export 'package:gabpharmamobile/vues/favoris.dart' show Favoris;
export 'package:gabpharmamobile/vues/pharmacies.dart' show Pharmacies;
export 'package:gabpharmamobile/vues/checkout.dart' show Checkout;
export 'package:gabpharmamobile/vues/notifications.dart' show NotificationsPage;
export 'package:gabpharmamobile/vues/profil.dart' show Profil;

class Forfaits extends StatelessWidget {
  const Forfaits({super.key});

  @override
  Widget build(BuildContext context) {
    return const PagePlaceholder(
      titre: 'Forfaits',
      description: 'Pass 1h 500 F · Standard 2000 F · Premium 5000 F (FCFA).',
      icone: Icons.workspace_premium_outlined,
    );
  }
}

class Ordonnances extends StatelessWidget {
  const Ordonnances({super.key});

  @override
  Widget build(BuildContext context) {
    return const PagePlaceholder(
      titre: 'Ordonnances',
      description: 'Upload PDF / JPG / PNG. Données de santé — jamais publiques.',
      icone: Icons.description_outlined,
    );
  }
}

class UrgenceSos extends StatelessWidget {
  const UrgenceSos({super.key});

  @override
  Widget build(BuildContext context) {
    return const PagePlaceholder(
      titre: 'Urgence SOS',
      description: 'Premium = urgence. Interface SOS à venir.',
      icone: Icons.emergency_outlined,
    );
  }
}

class Assurance extends StatelessWidget {
  const Assurance({super.key});

  @override
  Widget build(BuildContext context) {
    return const PagePlaceholder(
      titre: 'Mon Assurance',
      description:
          'Carte, garanties, PC-XXXXXX, FAC-XXXXXX, reste à charge. API encore surtout web.',
      icone: Icons.health_and_safety_outlined,
    );
  }
}

class Messagerie extends StatelessWidget {
  const Messagerie({super.key});

  @override
  Widget build(BuildContext context) {
    return const PagePlaceholder(
      titre: 'Messagerie',
      description: 'Bloquée sans forfait. API messagerie pharmacie à étendre.',
      icone: Icons.chat_bubble_outline,
    );
  }
}

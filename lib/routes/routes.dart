import 'package:gabpharmamobile/authentification/connexion.dart';
import 'package:gabpharmamobile/authentification/inscription.dart';
import 'package:gabpharmamobile/controllers/controller_checkout.dart';
import 'package:gabpharmamobile/controllers/controller_fiche_medicament.dart';
import 'package:gabpharmamobile/controllers/controller_suivi_commande.dart';
import 'package:gabpharmamobile/livreur/aide_support.dart';
import 'package:gabpharmamobile/livreur/carte_suivi.dart';
import 'package:gabpharmamobile/livreur/compte_en_attente.dart';
import 'package:gabpharmamobile/livreur/connexion_livreur.dart';
import 'package:gabpharmamobile/livreur/controller_auth_livreur.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/detail_livraison.dart';
import 'package:gabpharmamobile/livreur/inscription_livreur.dart';
import 'package:gabpharmamobile/livreur/mission_urgence.dart';
import 'package:gabpharmamobile/livreur/navigation_livreur.dart';
import 'package:gabpharmamobile/livreur/signalement.dart';
import 'package:gabpharmamobile/livreur/validation_mission.dart';
import 'package:gabpharmamobile/livreur/vehicule_documents.dart';
import 'package:gabpharmamobile/vues/ecrans.dart';
import 'package:gabpharmamobile/vues/navigation.dart';
import 'package:gabpharmamobile/vues/splash.dart';
import 'package:get/get.dart';

class Routes {
  static const String splash = '/';
  static const String connexion = '/connexion';
  static const String inscription = '/inscription';
  static const String connexionLivreur = '/connexion-livreur';
  static const String inscriptionLivreur = '/inscription-livreur';
  static const String compteEnAttenteLivreur = '/compte-en-attente-livreur';
  static const String navigationLivreur = '/navigation-livreur';
  static const String detailLivraisonLivreur = '/detail-livraison-livreur';
  static const String carteSuiviLivreur = '/carte-suivi-livreur';
  static const String validationRecuperation = '/validation-recuperation';
  static const String validationLivraison = '/validation-livraison';
  static const String aideSupportLivreur = '/aide-support-livreur';
  static const String signalementLivreur = '/signalement-livreur';
  static const String vehiculeDocumentsLivreur = '/vehicule-documents-livreur';
  static const String missionUrgence = '/mission-urgence';
  static const String navigation = '/navigation';

  static const String accueil = '/accueil';
  static const String ficheMedicament = '/fiche-medicament';
  static const String pharmacies = '/pharmacies';
  static const String forfaits = '/forfaits';
  static const String panier = '/panier';
  static const String checkout = '/checkout';
  static const String commandes = '/commandes';
  static const String detailCommande = '/detail-commande';
  static const String ordonnances = '/ordonnances';
  static const String favoris = '/favoris';
  static const String notifications = '/notifications';
  static const String urgenceSos = '/urgence-sos';
  static const String assurance = '/assurance';
  static const String messagerie = '/messagerie';
  static const String profil = '/profil';
}

void _bindLivreurLivraison() {
  if (!Get.isRegistered<ControllerLivraisonLivreur>()) {
    Get.put(ControllerLivraisonLivreur(), permanent: true);
  }
}

final getPages = [
  GetPage(name: Routes.splash, page: () => const Splash()),
  GetPage(name: Routes.connexion, page: () => Connexion()),
  GetPage(name: Routes.inscription, page: () => Inscription()),
  GetPage(
    name: Routes.connexionLivreur,
    page: () => ConnexionLivreur(),
    binding: BindingsBuilder(() {
      if (!Get.isRegistered<ControllerAuthLivreur>()) {
        Get.put(ControllerAuthLivreur(), permanent: true);
      }
    }),
  ),
  GetPage(
    name: Routes.inscriptionLivreur,
    page: () => InscriptionLivreur(),
    binding: BindingsBuilder(() {
      if (!Get.isRegistered<ControllerAuthLivreur>()) {
        Get.put(ControllerAuthLivreur(), permanent: true);
      }
    }),
  ),
  GetPage(
    name: Routes.compteEnAttenteLivreur,
    page: () => const CompteEnAttenteLivreur(),
    binding: BindingsBuilder(() {
      if (!Get.isRegistered<ControllerAuthLivreur>()) {
        Get.put(ControllerAuthLivreur(), permanent: true);
      }
    }),
  ),
  GetPage(
    name: Routes.navigationLivreur,
    page: () => const NavigationLivreur(),
    binding: BindingsBuilder(_bindLivreurLivraison),
  ),
  GetPage(
    name: Routes.detailLivraisonLivreur,
    page: () => const DetailLivraisonLivreur(),
    binding: BindingsBuilder(_bindLivreurLivraison),
  ),
  GetPage(
    name: Routes.carteSuiviLivreur,
    page: () => const CarteSuiviLivreur(),
    binding: BindingsBuilder(_bindLivreurLivraison),
  ),
  GetPage(
    name: Routes.validationRecuperation,
    page: () => const ValidationRecuperation(),
    binding: BindingsBuilder(_bindLivreurLivraison),
  ),
  GetPage(
    name: Routes.validationLivraison,
    page: () => const ValidationLivraison(),
    binding: BindingsBuilder(_bindLivreurLivraison),
  ),
  GetPage(
    name: Routes.aideSupportLivreur,
    page: () => const AideSupportLivreur(),
    binding: BindingsBuilder(_bindLivreurLivraison),
  ),
  GetPage(
    name: Routes.signalementLivreur,
    page: () => const SignalementLivreur(),
    binding: BindingsBuilder(_bindLivreurLivraison),
  ),
  GetPage(
    name: Routes.vehiculeDocumentsLivreur,
    page: () => const VehiculeDocumentsLivreur(),
    binding: BindingsBuilder(_bindLivreurLivraison),
  ),
  GetPage(
    name: Routes.missionUrgence,
    page: () => const MissionUrgence(),
    binding: BindingsBuilder(_bindLivreurLivraison),
  ),
  GetPage(name: Routes.navigation, page: () => const Navigation()),
  GetPage(name: Routes.accueil, page: () => const Accueil()),
  GetPage(
    name: Routes.ficheMedicament,
    page: () => const FicheMedicament(),
    binding: BindingsBuilder(() {
      Get.put(ControllerFicheMedicament());
    }),
  ),
  GetPage(name: Routes.pharmacies, page: () => const Pharmacies()),
  GetPage(name: Routes.forfaits, page: () => const Forfaits()),
  GetPage(name: Routes.panier, page: () => const Panier()),
  GetPage(
    name: Routes.checkout,
    page: () => const Checkout(),
    binding: BindingsBuilder(() {
      Get.put(ControllerCheckout());
    }),
  ),
  GetPage(name: Routes.commandes, page: () => const Commandes()),
  GetPage(
    name: Routes.detailCommande,
    page: () => const DetailCommande(),
    binding: BindingsBuilder(() {
      Get.put(ControllerSuiviCommande());
    }),
  ),
  GetPage(name: Routes.ordonnances, page: () => const Ordonnances()),
  GetPage(name: Routes.favoris, page: () => const Favoris()),
  GetPage(name: Routes.notifications, page: () => const NotificationsPage()),
  GetPage(name: Routes.urgenceSos, page: () => const UrgenceSos()),
  GetPage(name: Routes.assurance, page: () => const Assurance()),
  GetPage(name: Routes.messagerie, page: () => const Messagerie()),
  GetPage(name: Routes.profil, page: () => const Profil()),
];

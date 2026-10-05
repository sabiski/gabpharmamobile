import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_accueil.dart';
import 'package:gabpharmamobile/controllers/controller_auth.dart';
import 'package:gabpharmamobile/controllers/controller_catalogue.dart';
import 'package:gabpharmamobile/controllers/controller_metier.dart';
import 'package:gabpharmamobile/controllers/controller_navigation.dart';
import 'package:gabpharmamobile/controllers/controller_panier.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GabPharmaApp());
}

class GabPharmaApp extends StatelessWidget {
  const GabPharmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Gab'Pharma",
      debugShowCheckedModeBanner: false,
      theme: Design.theme,
      initialBinding: AppBindings(),
      initialRoute: Routes.splash,
      getPages: getPages,
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ControllerAuth(), permanent: true);
    Get.put(ControllerNavigation(), permanent: true);
    Get.put(ControllerAccueil(), permanent: true);
    Get.put(ControllerCatalogue(), permanent: true);
    Get.put(ControllerPanier(), permanent: true);
    Get.put(ControllerForfaits(), permanent: true);
    Get.put(ControllerCommandes(), permanent: true);
    Get.put(ControllerPaiements(), permanent: true);
    Get.put(ControllerOrdonnances(), permanent: true);
    Get.put(ControllerFavoris(), permanent: true);
    Get.put(ControllerNotifications(), permanent: true);
    Get.put(ControllerAssurance(), permanent: true);
    Get.put(ControllerMessagerie(), permanent: true);
    Get.put(ControllerUrgence(), permanent: true);
  }
}

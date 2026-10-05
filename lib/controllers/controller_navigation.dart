import 'package:get/get.dart';

/// Index de la bottom navigation (patient).
class ControllerNavigation extends GetxController {
  final index = 0.obs;

  void allerA(int i) => index.value = i;

  void accueil() => allerA(0);
  void recherche() => allerA(1);
  void commandes() => allerA(2);
  void favoris() => allerA(3);
  void profil() => allerA(4);
}
